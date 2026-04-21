// File: cpp_engine/src/mlt_translator.cpp
#include "mlt_translator.h"
#include <mlt++/Mlt.h>
#include <iostream>
#include <thread>
#include <chrono>

namespace mlt_translator {

void execute_plan(const video_core::CorrectionPlan& plan, grpc::ServerWriter<video_core::ExecutionProgress>* writer) {
    video_core::ExecutionProgress progress;
    progress.set_progress_percentage(0);
    progress.set_current_task("Initializing MLT...");
    progress.set_is_finished(false);
    progress.set_has_error(false);
    writer->Write(progress);

    Mlt::Factory::init();

    Mlt::Profile profile;
    Mlt::Playlist playlist(profile);

    double fps = profile.fps();

    // Iterate commands to build the playlist using cuts
    bool has_cuts = false;
    for (int i = 0; i < plan.commands_size(); ++i) {
        const auto& cmd = plan.commands(i);
        if (cmd.type() == video_core::CommandType::CUT_SEGMENT) {
            has_cuts = true;
            Mlt::Producer producer(profile, plan.input_video_path().c_str());
            if (!producer.is_valid()) {
                throw std::runtime_error("Failed to load input video: " + plan.input_video_path());
            }

            int in_frame = static_cast<int>((cmd.start_time_ms() / 1000.0) * fps);
            int out_frame = static_cast<int>((cmd.end_time_ms() / 1000.0) * fps);

            producer.set_in_and_out(in_frame, out_frame);
            playlist.append(producer);
        }
    }

    // If no cuts, append the whole video
    if (!has_cuts) {
        Mlt::Producer producer(profile, plan.input_video_path().c_str());
        if (!producer.is_valid()) {
            throw std::runtime_error("Failed to load input video: " + plan.input_video_path());
        }
        playlist.append(producer);
    }

    // Apply filters
    for (int i = 0; i < plan.commands_size(); ++i) {
        const auto& cmd = plan.commands(i);
        if (cmd.type() == video_core::CommandType::STABILIZE) {
            Mlt::Filter filter(profile, "vidstab");
            if (filter.is_valid()) {
                for (const auto& [key, value] : cmd.parameters()) {
                    filter.set(key.c_str(), value.c_str());
                }
                playlist.attach(filter);
            } else {
                std::cerr << "Warning: vidstab filter not available." << std::endl;
            }
        } else if (cmd.type() == video_core::CommandType::COLOR_CORRECT) {
            Mlt::Filter filter(profile, "brightness"); // Assuming brightness for color correction example
            if (filter.is_valid()) {
                for (const auto& [key, value] : cmd.parameters()) {
                    filter.set(key.c_str(), value.c_str());
                }
                playlist.attach(filter);
            } else {
                std::cerr << "Warning: brightness filter not available." << std::endl;
            }
        }
    }

    progress.set_progress_percentage(10);
    progress.set_current_task("Rendering...");
    writer->Write(progress);

    Mlt::Consumer consumer(profile, "avformat", plan.output_video_path().c_str());
    if (!consumer.is_valid()) {
         throw std::runtime_error("Failed to create consumer for output: " + plan.output_video_path());
    }

    consumer.connect(playlist);
    consumer.start();

    int total_length = playlist.get_length();
    while (!consumer.is_stopped()) {
        int current_position = consumer.position();
        if (total_length > 0) {
            int percentage = 10 + static_cast<int>((static_cast<double>(current_position) / total_length) * 90);
            if (percentage > 99) percentage = 99;
            progress.set_progress_percentage(percentage);
            writer->Write(progress);
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(500));
    }

    progress.set_progress_percentage(100);
    progress.set_current_task("Finished rendering");
    progress.set_is_finished(true);
    writer->Write(progress);

    Mlt::Factory::close();
}

} // namespace mlt_translator