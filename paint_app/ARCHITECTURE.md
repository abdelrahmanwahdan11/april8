# Paint App Architecture

## Strict Separation of Concerns

This cross-platform drawing application strictly separates the UI layer and the Core Engine:

### UI Layer (Flutter)
- Built exclusively with Flutter.
- Contains **ZERO** business logic, drawing logic, coordinate math, state management, or image processing.
- Acts solely as a "dumb" UI layer. It captures user inputs (like pointer events) and forwards coordinates to the Core Engine.
- Displays the pixel buffer (rendered by the C++ engine) using Flutter's `ui.decodeImageFromPixels` in a CustomPaint or Texture widget.

### Core Engine (C++)
- The heart of the application. Without it, the app will not function.
- Manages the entire state of the canvas, pixel data, and processes every single stroke.
- Designed to be highly scalable and extensible from day one, allowing for future additions such as image editing, layer management, and color filters.
- Implements appropriate design patterns like the Command Pattern to support Undo/Redo operations and a Bridge Pattern for platform-agnostic rendering.

## Native Integration (The Bridge)

The application bridges the Flutter UI and the C++ Core Engine using two distinct mechanisms to ensure native performance across all supported platforms:

### Mobile (Android & iOS)
- Utilizes `dart:ffi` to bridge Flutter with the C++ engine.
- C++ functions are exposed via `extern "C"` to be accessible as C-style functions, which are then bound in Dart.

### Web (WASM)
- The C++ engine is compiled to WebAssembly (WASM) using Emscripten.
- Uses JS-Interop (`dart:js_interop` and `dart:js_util`) in Flutter Web to interface with the Emscripten-generated JavaScript glue code, which interacts with the WASM module.
- Functions are exported to WASM using `EMSCRIPTEN_KEEPALIVE`.

## Scalability & Extensibility

The C++ Core Engine is structured to support scaling:
- **Command Pattern:** Every drawing action (e.g., a stroke) is encapsulated in a command, making it trivial to implement Undo/Redo functionality later.
- **CanvasEngine:** The central manager for the pixel buffer. It handles executing commands and outputting the final RGBA buffer.
- **Modular Design:** Operations like cropping, applying filters, or managing layers can be added as new command types or modular processing steps without altering the Dart code.
