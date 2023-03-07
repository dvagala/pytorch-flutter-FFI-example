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

final int Function(int x, int y) nativeAdd =
    nativeLib.lookup<NativeFunction<Int32 Function(Int32, Int32)>>('native_add').asFunction();

final void Function(Pointer<Uint8> modelPath) nativeLoadMlModel = nativeLib
    .lookup<NativeFunction<Void Function(Pointer<Uint8> modelPath)>>("load_ml_model")
    .asFunction();

final Pointer<Pointer<Float>> Function(Pointer<Float> inputData) nativeModelInference = nativeLib
    .lookup<NativeFunction<Pointer<Pointer<Float>> Function(Pointer<Float> inputData)>>(
        "model_inference")
    .asFunction();
