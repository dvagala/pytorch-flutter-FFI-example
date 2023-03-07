import 'dart:ffi';
import 'dart:io';

import 'native_pytorch_platform_interface.dart';

class NativePytorch {
  Future<String?> getPlatformVersion() {
    return NativePytorchPlatform.instance.getPlatformVersion();
  }
}

final DynamicLibrary nativeAddLib =
    Platform.isAndroid ? DynamicLibrary.open('libnative_pytorch.so') : DynamicLibrary.process();

final int Function(int x, int y) nativeAdd =
    nativeAddLib.lookup<NativeFunction<Int32 Function(Int32, Int32)>>('native_add').asFunction();
