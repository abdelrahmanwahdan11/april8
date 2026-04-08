import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'engine_bridge.dart';

// FFI Signatures
typedef EngineInitC = Void Function(Int32 width, Int32 height);
typedef EngineInitDart = void Function(int width, int height);

typedef EngineClearC = Void Function(Uint32 color);
typedef EngineClearDart = void Function(int color);

typedef EngineDrawStrokeC = Void Function(Int32 x0, Int32 y0, Int32 x1, Int32 y1, Uint32 color, Int32 radius);
typedef EngineDrawStrokeDart = void Function(int x0, int y0, int x1, int y1, int color, int radius);

typedef EngineGetBufferC = Pointer<Uint8> Function();
typedef EngineGetBufferDart = Pointer<Uint8> Function();

typedef EngineGetIntC = Int32 Function();
typedef EngineGetIntDart = int Function();

class EngineBridgeFFI implements EngineBridge {
  late final DynamicLibrary _lib;

  late final EngineInitDart _engineInit;
  late final EngineClearDart _engineClear;
  late final EngineDrawStrokeDart _engineDrawStroke;
  late final EngineGetBufferDart _engineGetBuffer;
  late final EngineGetIntDart _engineGetWidth;
  late final EngineGetIntDart _engineGetHeight;

  EngineBridgeFFI() {
    if (Platform.isAndroid) {
      _lib = DynamicLibrary.open('libpaint_engine.so');
    } else if (Platform.isIOS) {
      _lib = DynamicLibrary.process();
    } else {
      throw UnsupportedError('Unsupported platform for FFI');
    }

    _engineInit = _lib.lookupFunction<EngineInitC, EngineInitDart>('engine_init');
    _engineClear = _lib.lookupFunction<EngineClearC, EngineClearDart>('engine_clear');
    _engineDrawStroke = _lib.lookupFunction<EngineDrawStrokeC, EngineDrawStrokeDart>('engine_draw_stroke');
    _engineGetBuffer = _lib.lookupFunction<EngineGetBufferC, EngineGetBufferDart>('engine_get_buffer');
    _engineGetWidth = _lib.lookupFunction<EngineGetIntC, EngineGetIntDart>('engine_get_width');
    _engineGetHeight = _lib.lookupFunction<EngineGetIntC, EngineGetIntDart>('engine_get_height');
  }

  @override
  void initEngine(int width, int height) {
    _engineInit(width, height);
  }

  @override
  void clear(int color) {
    _engineClear(color);
  }

  @override
  void drawStroke(int x0, int y0, int x1, int y1, int color, int radius) {
    _engineDrawStroke(x0, y0, x1, y1, color, radius);
  }

  @override
  Uint8List getBuffer() {
    int w = getWidth();
    int h = getHeight();
    if (w == 0 || h == 0) return Uint8List(0);

    Pointer<Uint8> ptr = _engineGetBuffer();
    if (ptr == nullptr) return Uint8List(0);

    // Create a view of the C++ memory
    return ptr.asTypedList(w * h * 4);
  }

  @override
  int getWidth() => _engineGetWidth();

  @override
  int getHeight() => _engineGetHeight();
}

EngineBridge getPlatformBridge() {
  return EngineBridgeFFI();
}
