#pragma once

#include <grpcpp/grpcpp.h>
#include "video_engine.grpc.pb.h"

void mlt_translator_init();
bool process_video(const video_core::CorrectionPlan& request, grpc::ServerWriter<video_core::ExecutionProgress>* writer);
