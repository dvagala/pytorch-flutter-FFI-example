import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:native_pytorch/cString.dart';
import 'package:native_pytorch/native_pytorch.dart';

class NativeCommunicatorService {
  void loadMlModel(String mlModelLocalFilePath) {
    nativeLoadMlModel(_toNativeASCII(mlModelLocalFilePath));
    print('loaded model:$mlModelLocalFilePath');
  }

  List<double> modelInference(List inputList) {
    final inputDataPtr = allocate<Float>(inputList.length * sizeOf<Float>());
    for (var i = 0; i < inputList.length; i++) {
      inputDataPtr[i] = inputList[i];
    }

    Pointer<Pointer<Float>> outputDataPtr = nativeModelInference(inputDataPtr);
    _printBuffer();

    free(inputDataPtr);

    final outDataLength = outputDataPtr.elementAt(1).value.asTypedList(2)[0].toInt();
    final outputList = outputDataPtr.elementAt(0).value.asTypedList(outDataLength);
    return outputList;
  }

  void _printBuffer() {
    // To be able to print something to console from the C++. It's not ideal. Maybe it would be
    // possible to set up callback, so C++ can call a dart function and pass it what you want to print
    final printBufferPtr = nativeGetPrintingBufferAndClear();
    print('c++ print buffer: \n${CString.getDartString(printBufferPtr)}');
  }

  Pointer<Uint8> _toNativeASCII(String string) {
    return CString(string).cPointer!;
  }
}
