export 'dart:ffi';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

class CString {
  String string;
  Pointer<Uint8>? cPointer;

  CString(this.string) {
    cPointer = allocate<Uint8>((string.length + 1) * sizeOf<Uint8>());

    for (var i = 0; i < string.length; i++) {
      cPointer![i] = string.codeUnitAt(i);
    }
    cPointer![string.length] = 0;
  }

  static String getDartString(Pointer<Uint8> cPointer) {
    String string = "";
    for (var i = 0; i < 7; i++) {
      final char = cPointer.elementAt(i).value;
      if (char == 0) {
        break;
      } else {
        string += String.fromCharCode(char);
      }
    }
    return string;
  }

  void free() {
    if (cPointer != null) {
      cPointer = null;
    }
  }
}

Pointer<T> allocate<T extends NativeType>(int byteCount, {int? alignment}) {
  return calloc.allocate<T>(byteCount);
}

void free(Pointer<NativeType> pointer) {
  calloc.free(pointer);
}
