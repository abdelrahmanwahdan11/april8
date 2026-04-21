cmake_minimum_required(VERSION 3.15)
project(video_engine_cpp C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(FetchContent)

# Fetch gRPC
FetchContent_Declare(
  gRPC
  GIT_REPOSITORY https://github.com/grpc/grpc.git
  GIT_TAG        v1.54.0
)
set(FETCHCONTENT_QUIET OFF)
set(gRPC_INSTALL OFF CACHE BOOL "Disable installation of gRPC")
set(gRPC_BUILD_TESTS OFF CACHE BOOL "Disable building tests of gRPC")
FetchContent_MakeAvailable(gRPC)

# Fetch MLT Framework
FetchContent_Declare(
  mltframework
  GIT_REPOSITORY https://github.com/mltframework/mlt.git
  GIT_TAG        v7.16.0
)
set(MOD_QT OFF CACHE BOOL "" FORCE)
set(MOD_GLAXNIMATE OFF CACHE BOOL "" FORCE)
set(MOD_QT6 OFF CACHE BOOL "" FORCE)
set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
set(MOD_RTAUDIO OFF CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(mltframework)

# We need protoc to generate cpp code
set(_PROTOBUF_PROTOC $<TARGET_FILE:protoc>)
set(_GRPC_CPP_PLUGIN_EXECUTABLE $<TARGET_FILE:grpc_cpp_plugin>)

# Setup proto compilation
set(PROTO_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../proto")
set(HW_PROTO "${PROTO_SRC_DIR}/video_engine.proto")
set(HW_PROTO_SRC "${CMAKE_CURRENT_BINARY_DIR}/video_engine.pb.cc")
set(HW_PROTO_HEADER "${CMAKE_CURRENT_BINARY_DIR}/video_engine.pb.h")
set(HW_GRPC_SRC "${CMAKE_CURRENT_BINARY_DIR}/video_engine.grpc.pb.cc")
set(HW_GRPC_HEADER "${CMAKE_CURRENT_BINARY_DIR}/video_engine.grpc.pb.h")

add_custom_command(
      OUTPUT "${HW_PROTO_SRC}" "${HW_PROTO_HEADER}" "${HW_GRPC_SRC}" "${HW_GRPC_HEADER}"
      COMMAND ${_PROTOBUF_PROTOC}
      ARGS --grpc_out="${CMAKE_CURRENT_BINARY_DIR}"
        --cpp_out="${CMAKE_CURRENT_BINARY_DIR}"
        -I "${PROTO_SRC_DIR}"
        --plugin=protoc-gen-grpc="${_GRPC_CPP_PLUGIN_EXECUTABLE}"
        "${HW_PROTO}"
      DEPENDS "${HW_PROTO}")

add_library(video_engine_proto
  ${HW_PROTO_SRC}
  ${HW_PROTO_HEADER}
  ${HW_GRPC_SRC}
  ${HW_GRPC_HEADER}
)

target_link_libraries(video_engine_proto PUBLIC grpc++ libprotobuf)
target_include_directories(video_engine_proto PUBLIC "${CMAKE_CURRENT_BINARY_DIR}")

add_executable(server src/server.cpp src/mlt_translator.cpp)

# Link against video_engine_proto, gRPC, and mlt++
target_link_libraries(server
  PRIVATE
  video_engine_proto
  grpc++
  libprotobuf
  mlt++
)
set(MOD_QT OFF CACHE BOOL "")
