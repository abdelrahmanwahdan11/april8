#!/bin/bash

# Ensure emcc is in the PATH or activated via emsdk
if ! command -v emcc &> /dev/null
then
    echo "emcc could not be found. Please install emsdk and run 'source ./emsdk_env.sh'"
    exit 1
fi

mkdir -p ../web/wasm

# Compile to WebAssembly
# -O3: Optimize for performance
# -s EXPORTED_RUNTIME_METHODS: Export ccall, cwrap
# -s EXPORTED_FUNCTIONS: Ensure we can call our methods (with _ prefix)
emcc CanvasEngine.cpp bridge.cpp -o ../web/wasm/paint_engine.js \
    -O3 \
    -s WASM=1 \
    -s ALLOW_MEMORY_GROWTH=1 \
    -s EXPORTED_RUNTIME_METHODS='["ccall","cwrap"]' \
    -s EXPORTED_FUNCTIONS='["_engine_init", "_engine_clear", "_engine_draw_stroke", "_engine_get_buffer", "_engine_get_width", "_engine_get_height", "_malloc", "_free"]'

echo "WASM build complete. Artifacts placed in ../web/wasm/"
