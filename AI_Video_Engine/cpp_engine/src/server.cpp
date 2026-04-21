// File: cpp_engine/src/server.cpp
#include <iostream>
#include <memory>
#include <string>

#include <grpcpp/grpcpp.h>
#include "video_engine.grpc.pb.h"
#include "mlt_translator.h"

using grpc::Server;
using grpc::ServerBuilder;
using grpc::ServerContext;
using grpc::Status;
using grpc::ServerWriter;
using video_core::CorrectionPlan;
using video_core::ExecutionProgress;
using video_core::EngineController;

class EngineControllerImpl final : public EngineController::Service {
    Status ExecutePlan(ServerContext* context, const CorrectionPlan* plan, ServerWriter<ExecutionProgress>* writer) override {
        std::cout << "Received plan to execute: " << plan->input_video_path() << " -> " << plan->output_video_path() << std::endl;

        try {
            mlt_translator::execute_plan(*plan, writer);
            return Status::OK;
        } catch (const std::exception& e) {
            ExecutionProgress error_progress;
            error_progress.set_has_error(true);
            error_progress.set_error_details(e.what());
            error_progress.set_is_finished(true);
            writer->Write(error_progress);
            return Status(grpc::StatusCode::INTERNAL, e.what());
        }
    }
};

void RunServer() {
    std::string server_address("0.0.0.0:50051");
    EngineControllerImpl service;

    ServerBuilder builder;
    builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
    builder.RegisterService(&service);

    std::unique_ptr<Server> server(builder.BuildAndStart());
    std::cout << "Server listening on " << server_address << std::endl;
    server->Wait();
}

int main(int argc, char** argv) {
    RunServer();
    return 0;
}
