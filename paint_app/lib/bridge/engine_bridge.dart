import 'dart:typed_data';

/// Abstract interface for bridging Flutter to the C++ Core Engine.
/// Implementations exist for FFI (Mobile) and Web (JS-Interop/WASM).
abstract class EngineBridge {
  /// Initializes the canvas engine with the given dimensions.
  void initEngine(int width, int height);

  /// Clears the canvas with the specified color.
  void clear(int color);

  /// Draws a stroke between two points with the given color and radius.
  void drawStroke(int x0, int y0, int x1, int y1, int color, int radius);

  /// Retrieves the current pixel buffer from the engine.
  Uint8List getBuffer();

  /// Gets the width of the canvas.
  int getWidth();

  /// Gets the height of the canvas.
  int getHeight();
}
