import 'dart:js_interop';
import 'dart:typed_data';
import 'engine_bridge.dart';

@JS('Module')
external JSObject get _module;

extension on JSObject {
  external void _engine_init(int width, int height);
  external void _engine_clear(int color);
  external void _engine_draw_stroke(int x0, int y0, int x1, int y1, int color, int radius);
  external int _engine_get_buffer();
  external int _engine_get_width();
  external int _engine_get_height();
  external JSUint8Array get HEAPU8;
}

class EngineBridgeWeb implements EngineBridge {
  @override
  void initEngine(int width, int height) {
    _module._engine_init(width, height);
  }

  @override
  void clear(int color) {
    _module._engine_clear(color);
  }

  @override
  void drawStroke(int x0, int y0, int x1, int y1, int color, int radius) {
    _module._engine_draw_stroke(x0, y0, x1, y1, color, radius);
  }

  @override
  Uint8List getBuffer() {
    int w = getWidth();
    int h = getHeight();
    if (w == 0 || h == 0) return Uint8List(0);

    int ptr = _module._engine_get_buffer();
    if (ptr == 0) return Uint8List(0);

    // View into WASM memory.
    // Convert JSUint8Array to Dart Uint8List, then slice to get the correct buffer
    final heapList = _module.HEAPU8.toDart;
    int length = w * h * 4;
    return Uint8List.sublistView(heapList, ptr, ptr + length);
  }

  @override
  int getWidth() => _module._engine_get_width();

  @override
  int getHeight() => _module._engine_get_height();
}

EngineBridge getPlatformBridge() {
  return EngineBridgeWeb();
}
