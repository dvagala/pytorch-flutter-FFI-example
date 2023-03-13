# PyTorch / LibTorch in Flutter through C++ FFI

FFI is faster the method channels, and I couldn't find a good example for this so I've made one.

This example app is working as it is on Android and iOS. No further dependency needs to be installed. Tested on Flutter 3.3.8

### Steps I took when making this example app:
1. Create FFI plugin from this [guide](https://docs.flutter.dev/development/platform-integration/android/c-interop)
2. Android: copied `native_pytorch/libtorch-android` and setup `native_pytorch/CMakeLists.txt`
3. iOS: setup `native_pytorch/ios/native_pytorch.podspec` (note that `s.static_framework = true` is mandatory)
4. iOS: drag `native_pytorch/ios/Classes/native_pytorch.cpp` to xCode to projects files (on the left side under the runner). Otherwise it say `symbols not found`


### Some benchmarks - FFI vs Current version of the flutter_pytorch_mobile package

The inference is significantly faster through FFI on Android. Moreover, with bigger input tensors, I was getting an `OutOfMemoryError` before, and now with the FFI it's totally fine.

```
The current version of the package:
Input shape (1, 3, 350, 350) - inference 886ms
Input shape (1, 3, 700, 700) -  inference 3050ms
Input shape (1, 3, 2000, 2000) -  inference `OutOfMemoryError`
Input shape (1, 3, 8750, 8750) -  inference `OutOfMemoryError`

FFI:
Input shape (1, 3, 350, 350) - inference 250ms
Input shape (1, 3, 700, 700) -  inference 314ms
Input shape (1, 3, 2000, 2000) -  inference 580ms
Input shape (1, 3, 8750, 8750) -  inference 12114ms
```

(I measured the time to make the model inference from `Dart List`, and get the output to `Dart List`, so the conversions to/from C++ data structures are already included in the measures. Testing ML model was [LDC](https://github.com/xavysp/LDC))
