#include "CanvasEngine.hpp"
#include <algorithm>
#include <cmath>

// --- CanvasEngine Implementation ---

CanvasEngine::CanvasEngine(int width, int height)
    : m_width(width), m_height(height), m_buffer(width * height, 0xFFFFFFFF) {
}

void CanvasEngine::clear(uint32_t color) {
    std::fill(m_buffer.begin(), m_buffer.end(), color);
}

void CanvasEngine::executeCommand(std::unique_ptr<Command> command) {
    if (command) {
        command->execute(*this);
        // For a full undo/redo system, we would store `command` in a history list here.
    }
}

const uint8_t* CanvasEngine::getBuffer() const {
    return reinterpret_cast<const uint8_t*>(m_buffer.data());
}

int CanvasEngine::getWidth() const { return m_width; }
int CanvasEngine::getHeight() const { return m_height; }

void CanvasEngine::setPixel(int x, int y, uint32_t color) {
    if (x >= 0 && x < m_width && y >= 0 && y < m_height) {
        m_buffer[y * m_width + x] = color;
    }
}

// --- StrokeCommand Implementation ---

StrokeCommand::StrokeCommand(int x0, int y0, int x1, int y1, uint32_t color, int radius)
    : m_x0(x0), m_y0(y0), m_x1(x1), m_y1(y1), m_color(color), m_radius(radius) {
}

void StrokeCommand::execute(CanvasEngine& engine) {
    // Simple Bresenham's line algorithm with thickness
    int dx = std::abs(m_x1 - m_x0);
    int dy = -std::abs(m_y1 - m_y0);
    int sx = m_x0 < m_x1 ? 1 : -1;
    int sy = m_y0 < m_y1 ? 1 : -1;
    int err = dx + dy;
    int e2;

    int currentX = m_x0;
    int currentY = m_y0;

    auto drawBrush = [&](int cx, int cy) {
        if (m_radius <= 1) {
            engine.setPixel(cx, cy, m_color);
            return;
        }
        int rSquared = m_radius * m_radius;
        for (int y = -m_radius; y <= m_radius; ++y) {
            for (int x = -m_radius; x <= m_radius; ++x) {
                if (x * x + y * y <= rSquared) {
                    engine.setPixel(cx + x, cy + y, m_color);
                }
            }
        }
    };

    while (true) {
        drawBrush(currentX, currentY);

        if (currentX == m_x1 && currentY == m_y1) break;
        e2 = 2 * err;
        if (e2 >= dy) {
            err += dy;
            currentX += sx;
        }
        if (e2 <= dx) {
            err += dx;
            currentY += sy;
        }
    }
}
