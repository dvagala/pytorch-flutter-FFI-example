import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class MLService {
  final _mlModelAssetName = 'functional_external_model.pt';

  late final File mlModelFile;

  Future<void> init() async {
    await copyMlModelFromAssetsToLocalStorage();
  }

  Future<void> copyMlModelFromAssetsToLocalStorage() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final mlModelsDir = Directory('${documentsDir.path}/ml_models');
    if (!mlModelsDir.existsSync()) {
      mlModelsDir.createSync(recursive: true);
    }
    mlModelFile = File('${mlModelsDir.path}/$_mlModelAssetName');

    ByteData byteData = await rootBundle.load('assets/ml_models/$_mlModelAssetName');

    await mlModelFile.writeAsBytes(
      byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );

    print('ML model copied to local storage');
  }
}
