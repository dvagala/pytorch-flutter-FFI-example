import 'package:flutter/material.dart';
import 'package:pytorch_flutter_ffi_example/const.dart';
import 'package:pytorch_flutter_ffi_example/ml_service.dart';
import 'package:pytorch_flutter_ffi_example/native_communicator_service.dart';
import 'package:pytorch_flutter_ffi_example/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pytorch-flutter-FFI-example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<double> outputList = [];
  int? inferenceTimeMs;
  bool loading = false;

  Future<void> initAndMakeInference() async {
    setState(() {
      loading = true;
    });

    final nativeCommunicatorService = NativeCommunicatorService();
    final mLService = MLService();
    await mLService.init();

    nativeCommunicatorService.loadMlModel(mLService.mlModelFile.path);

    final inputList = List<double>.generate(17, (counter) => 0.4);

    final start = DateTime.now();
    outputList = nativeCommunicatorService.modelInference(inputList);
    inferenceTimeMs = DateTime.now().difference(start).inMilliseconds;

    print('Inference outputList: ${outputList}');

    assert(listRoughlyEquals(outputList, expectedOutputList));

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    initAndMakeInference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(loading ? "loading..." : ""),
            Text(loading ? "" : 'It took ${inferenceTimeMs}ms to make inference'),
            const SizedBox(height: 30),
            Text(loading ? "" : 'Result tensor:\n${outputList}'),
          ],
        ),
      ),
    );
  }
}
