cmake_minimum_required(VERSION 3.10)

project(paint_engine VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_library(paint_engine SHARED
    CanvasEngine.cpp
    bridge.cpp
)

# Adjust standard library for Android/iOS if needed, though CMake usually handles this.
target_include_directories(paint_engine PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

if (WIN32)
    # Ensure Windows exports are set correctly if ever ported.
    set_target_properties(paint_engine PROPERTIES WINDOWS_EXPORT_ALL_SYMBOLS ON)
endif()
