import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:native_pytorch/cString.dart';
import 'package:native_pytorch/native_pytorch.dart';

Pointer<Uint8> _toNativeASCII(String string) {
  return CString(string).cPointer!;
}

class NativeCommunicatorService {
  void loadMlModel(String mlModelLocalFilePath) {
    nativeLoadMlModel(_toNativeASCII(mlModelLocalFilePath));
    print('loaded model:$mlModelLocalFilePath');
  }

  Float32List modelInference(List inputList) {
    Pointer<Pointer<Float>> outputDataPtr;

    final inputDataPtr = allocate<Float>(inputList.length * sizeOf<Float>());
    for (var i = 0; i < inputList.length; i++) {
      inputDataPtr[i] = inputList[i];
    }

    outputDataPtr = nativeModelInference(inputDataPtr);

    final outDataLength = outputDataPtr.elementAt(0).value.asTypedList(1)[0].toInt();
    final outputList = outputDataPtr.elementAt(1).value.asTypedList(outDataLength);
    print('inference done');

    return outputList;
  }
}
