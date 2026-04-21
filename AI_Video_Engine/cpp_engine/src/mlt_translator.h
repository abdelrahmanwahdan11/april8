// File: cpp_engine/src/mlt_translator.h
#pragma once

#include <grpcpp/grpcpp.h>
#include "video_engine.grpc.pb.h"

namespace mlt_translator {
    void execute_plan(const video_core::CorrectionPlan& plan, grpc::ServerWriter<video_core::ExecutionProgress>* writer);
}
