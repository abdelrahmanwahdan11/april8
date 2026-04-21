#include "mlt_translator.h"
#include <iostream>
#include <thread>
#include <chrono>
#include <algorithm>

// MLT headers
#include <Mlt.h>

using video_core::CorrectionPlan;
using video_core::ExecutionProgress;
using video_core::CommandType;

void mlt_translator_init() {
  Mlt::Factory::init();
}

bool process_video(const CorrectionPlan& request, grpc::ServerWriter<ExecutionProgress>* writer) {
  std::cout << "Starting MLT processing..." << std::endl;

  Mlt::Profile profile;
  Mlt::Playlist playlist(profile);

  // Load the input video
  Mlt::Producer producer(profile, request.input_video_path().c_str());
  if (!producer.is_valid()) {
      ExecutionProgress progress;
      progress.set_has_error(true);
      progress.set_error_details("Failed to load input video");
      writer->Write(progress);
      return false;
  }

  double fps = profile.fps();
  int total_frames = producer.get_length();
  std::cout << "Video loaded. Total frames: " << total_frames << ", FPS: " << fps << std::endl;

  // Track valid segments for cutting
  struct Segment { int start; int end; };
  std::vector<Segment> keep_segments;

  // By default, keep the whole video, then subtract cuts.
  // However, the instructions say: Iterate over CUT_SEGMENT commands... append the valid segments to the Playlist.
  // We'll calculate the non-cut segments.
  std::vector<std::pair<int, int>> cuts;
  for (int i = 0; i < request.commands_size(); i++) {
    const auto& cmd = request.commands(i);
    if (cmd.type() == video_core::CUT_SEGMENT) {
      int start_frame = cmd.start_time_ms() * fps / 1000.0;
      int end_frame = cmd.end_time_ms() * fps / 1000.0;
      cuts.push_back({start_frame, end_frame});
    }
  }

  // Sort cuts and find keep segments
  std::sort(cuts.begin(), cuts.end());
  int current_frame = 0;
  for (const auto& cut : cuts) {
    if (current_frame < cut.first) {
      keep_segments.push_back({current_frame, cut.first - 1});
    }
    current_frame = std::max(current_frame, cut.second + 1);
  }
  if (current_frame < total_frames) {
    keep_segments.push_back({current_frame, total_frames - 1});
  }

  // If no cuts, keep everything
  if (cuts.empty()) {
    keep_segments.push_back({0, total_frames - 1});
  }

  // Append segments to playlist
  for (const auto& seg : keep_segments) {
    Mlt::Producer cut_producer(profile, request.input_video_path().c_str());
    cut_producer.set_in_and_out(seg.start, seg.end);
    playlist.append(cut_producer);
  }

  // Apply filters
  for (int i = 0; i < request.commands_size(); i++) {
    const auto& cmd = request.commands(i);
    if (cmd.type() == video_core::STABILIZE) {
      Mlt::Filter filter(profile, "vidstab");
      if (filter.is_valid()) {
        for (const auto& pair : cmd.parameters()) {
          filter.set(pair.first.c_str(), pair.second.c_str());
        }
        playlist.attach(filter);
      }
    } else if (cmd.type() == video_core::COLOR_CORRECT) {
      Mlt::Filter filter(profile, "brightness");
      if (filter.is_valid()) {
        for (const auto& pair : cmd.parameters()) {
          // MLT's brightness filter expects specific params, we'll just map them generically for now
          filter.set(pair.first.c_str(), pair.second.c_str());
        }
        playlist.attach(filter);
      }
    }
  }

  // Render
  Mlt::Consumer consumer(profile, "avformat", request.output_video_path().c_str());
  if (!consumer.is_valid()) {
      ExecutionProgress progress;
      progress.set_has_error(true);
      progress.set_error_details("Failed to create output consumer");
      writer->Write(progress);
      return false;
  }

  consumer.connect(playlist);
  consumer.start();

  // Progress streaming
  int playlist_length = playlist.get_length();
  while (!consumer.is_stopped()) {
    int position = consumer.position();
    int percentage = playlist_length > 0 ? (position * 100) / playlist_length : 100;

    ExecutionProgress progress;
    progress.set_progress_percentage(percentage);
    progress.set_current_task("Rendering");
    progress.set_is_finished(false);
    progress.set_has_error(false);
    writer->Write(progress);

    std::this_thread::sleep_for(std::chrono::milliseconds(200));
  }

  return true;
}
