#include "CanvasEngine.hpp"
#include <memory>

#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#define EXPORT EMSCRIPTEN_KEEPALIVE
#else
#if defined(_WIN32)
#define EXPORT __declspec(dllexport)
#else
#define EXPORT __attribute__((visibility("default"))) __attribute__((used))
#endif
#endif

// Global instance of the engine for simplicity.
// In a more complex app, we might return a pointer/handle to an engine instance.
static std::unique_ptr<CanvasEngine> g_engine = nullptr;

extern "C" {

EXPORT void engine_init(int width, int height) {
    g_engine = std::make_unique<CanvasEngine>(width, height);
}

EXPORT void engine_clear(uint32_t color) {
    if (g_engine) {
        g_engine->clear(color);
    }
}

EXPORT void engine_draw_stroke(int x0, int y0, int x1, int y1, uint32_t color, int radius) {
    if (g_engine) {
        g_engine->executeCommand(std::make_unique<StrokeCommand>(x0, y0, x1, y1, color, radius));
    }
}

EXPORT const uint8_t* engine_get_buffer() {
    if (g_engine) {
        return g_engine->getBuffer();
    }
    return nullptr;
}

EXPORT int engine_get_width() {
    return g_engine ? g_engine->getWidth() : 0;
}

EXPORT int engine_get_height() {
    return g_engine ? g_engine->getHeight() : 0;
}

} // extern "C"
