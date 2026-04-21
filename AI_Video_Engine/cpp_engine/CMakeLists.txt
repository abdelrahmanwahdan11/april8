cmake_minimum_required(VERSION 3.15)
project(VideoEngine CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(FetchContent)

# Fetch gRPC
FetchContent_Declare(
  gRPC
  GIT_REPOSITORY https://github.com/grpc/grpc.git
  GIT_TAG        v1.54.2
)
set(FETCHCONTENT_QUIET OFF)
set(gRPC_INSTALL OFF CACHE BOOL "" FORCE)
set(gRPC_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(gRPC_BUILD_CSHARP_EXT OFF CACHE BOOL "" FORCE)
set(gRPC_BUILD_GRPC_CSHARP_PLUGIN OFF CACHE BOOL "" FORCE)
set(gRPC_BUILD_GRPC_NODE_PLUGIN OFF CACHE BOOL "" FORCE)
set(gRPC_BUILD_GRPC_OBJECTIVE_C_PLUGIN OFF CACHE BOOL "" FORCE)
set(gRPC_BUILD_GRPC_PHP_PLUGIN OFF CACHE BOOL "" FORCE)
set(gRPC_BUILD_GRPC_PYTHON_PLUGIN OFF CACHE BOOL "" FORCE)
set(gRPC_BUILD_GRPC_RUBY_PLUGIN OFF CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(gRPC)

# Fetch MLT framework
FetchContent_Declare(
  mlt
  GIT_REPOSITORY https://github.com/mltframework/mlt.git
  GIT_TAG        v7.16.0
)
set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(mlt)

# Protobuf generation
set(PROTO_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../proto")
set(PROTO_FILE "${PROTO_DIR}/video_engine.proto")
set(PROTO_SRC "${CMAKE_CURRENT_BINARY_DIR}/video_engine.pb.cc")
set(PROTO_HEADER "${CMAKE_CURRENT_BINARY_DIR}/video_engine.pb.h")
set(GRPC_SRC "${CMAKE_CURRENT_BINARY_DIR}/video_engine.grpc.pb.cc")
set(GRPC_HEADER "${CMAKE_CURRENT_BINARY_DIR}/video_engine.grpc.pb.h")

add_custom_command(
    OUTPUT "${PROTO_SRC}" "${PROTO_HEADER}" "${GRPC_SRC}" "${GRPC_HEADER}"
    COMMAND protobuf::protoc
    ARGS --grpc_out="${CMAKE_CURRENT_BINARY_DIR}"
         --cpp_out="${CMAKE_CURRENT_BINARY_DIR}"
         -I "${PROTO_DIR}"
         --plugin=protoc-gen-grpc=$<TARGET_FILE:gRPC::grpc_cpp_plugin>
         "${PROTO_FILE}"
    DEPENDS "${PROTO_FILE}" protobuf::protoc gRPC::grpc_cpp_plugin
)

add_library(proto_lib ${PROTO_SRC} ${PROTO_HEADER} ${GRPC_SRC} ${GRPC_HEADER})
target_link_libraries(proto_lib PUBLIC gRPC::grpc++ protobuf::libprotobuf)
target_include_directories(proto_lib PUBLIC "${CMAKE_CURRENT_BINARY_DIR}")

# Build the executable
add_executable(video_engine_server
  src/server.cpp
  src/mlt_translator.cpp
)

target_include_directories(video_engine_server PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/src")

# Need to include MLT headers correctly based on how it's structured from FetchContent
target_include_directories(video_engine_server PRIVATE "${mlt_SOURCE_DIR}/src/mlt++" "${mlt_SOURCE_DIR}/src")

target_link_libraries(video_engine_server
  proto_lib
  gRPC::grpc++
  mlt++
  mlt
)
