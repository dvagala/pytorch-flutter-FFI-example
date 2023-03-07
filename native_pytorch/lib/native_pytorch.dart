import 'dart:ffi';
import 'dart:io';

import 'native_pytorch_platform_interface.dart';

class NativePytorch {
  Future<String?> getPlatformVersion() {
    return NativePytorchPlatform.instance.getPlatformVersion();
  }
}

final DynamicLibrary nativeLib =
    Platform.isAndroid ? DynamicLibrary.open('libnative_pytorch.so') : DynamicLibrary.process();

final void Function(Pointer<Uint8> modelPath) nativeLoadMlModel = nativeLib
    .lookup<NativeFunction<Void Function(Pointer<Uint8> modelPath)>>("load_ml_model")
    .asFunction();

final Pointer<Pointer<Float>> Function(Pointer<Float> inputData) nativeModelInference = nativeLib
    .lookup<NativeFunction<Pointer<Pointer<Float>> Function(Pointer<Float> inputData)>>(
        "model_inference")
    .asFunction();

final Pointer<Uint8> Function() nativeGetPrintingBufferAndClear = nativeLib
    .lookup<NativeFunction<Pointer<Uint8> Function()>>("get_printing_buffer_and_clear")
    .asFunction();
