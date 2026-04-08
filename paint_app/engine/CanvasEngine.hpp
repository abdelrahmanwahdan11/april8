#pragma once

#include <vector>
#include <memory>
#include <cstdint>

// Forward declarations
class CanvasEngine;

/**
 * Base Command interface for all actions that modify the canvas.
 * This supports the Command pattern for extensibility and potential Undo/Redo.
 */
class Command {
public:
    virtual ~Command() = default;
    virtual void execute(CanvasEngine& engine) = 0;
};

/**
 * Command to draw a basic stroke (line) between two points.
 */
class StrokeCommand : public Command {
public:
    StrokeCommand(int x0, int y0, int x1, int y1, uint32_t color, int radius);
    void execute(CanvasEngine& engine) override;

private:
    int m_x0, m_y0, m_x1, m_y1;
    uint32_t m_color;
    int m_radius;
};

/**
 * The core engine holding the pixel state.
 * Manages the raw RGBA buffer and applies commands to it.
 */
class CanvasEngine {
public:
    CanvasEngine(int width, int height);
    ~CanvasEngine() = default;

    // Delete copy and assignment
    CanvasEngine(const CanvasEngine&) = delete;
    CanvasEngine& operator=(const CanvasEngine&) = delete;

    void clear(uint32_t color = 0xFFFFFFFF); // Default white background (AARRGGBB in memory, usually treated as RGBA based on platform endianness)

    // Executes a command and applies it to the buffer
    void executeCommand(std::unique_ptr<Command> command);

    // Provide access to the raw buffer and dimensions
    const uint8_t* getBuffer() const;
    int getWidth() const;
    int getHeight() const;

    // Helper for direct pixel manipulation by commands
    void setPixel(int x, int y, uint32_t color);

private:
    int m_width;
    int m_height;
    std::vector<uint32_t> m_buffer; // 32-bit RGBA pixels
};
