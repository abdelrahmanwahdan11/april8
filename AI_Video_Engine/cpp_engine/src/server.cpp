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

using video_core::EngineController;
using video_core::CorrectionPlan;
using video_core::ExecutionProgress;

class EngineControllerImpl final : public EngineController::Service {
  Status ExecutePlan(ServerContext* context, const CorrectionPlan* request, ServerWriter<ExecutionProgress>* writer) override {
    std::cout << "Received request to process video: " << request->input_video_path() << std::endl;

    // Call the MLT translator to process the video
    bool success = process_video(*request, writer);

    if (success) {
      ExecutionProgress progress;
      progress.set_progress_percentage(100);
      progress.set_current_task("Finished");
      progress.set_is_finished(true);
      progress.set_has_error(false);
      writer->Write(progress);
      return Status::OK;
    } else {
      ExecutionProgress progress;
      progress.set_has_error(true);
      progress.set_error_details("Failed to process video");
      writer->Write(progress);
      return Status(grpc::StatusCode::INTERNAL, "Video processing failed");
    }
  }
};

void RunServer() {
  std::string server_address("0.0.0.0:50051");
  EngineControllerImpl service;

  ServerBuilder builder;
  // Listen on the given address without any authentication mechanism.
  builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
  // Register "service" as the instance through which we'll communicate with
  // clients. In this case it corresponds to an *synchronous* service.
  builder.RegisterService(&service);
  // Finally assemble the server.
  std::unique_ptr<Server> server(builder.BuildAndStart());
  std::cout << "Server listening on " << server_address << std::endl;

  // Wait for the server to shutdown. Note that some other thread must be
  // responsible for shutting down the server for this call to ever return.
  server->Wait();
}

int main(int argc, char** argv) {
  // Initialize MLT here so it's ready
  mlt_translator_init();
  RunServer();
  return 0;
}
