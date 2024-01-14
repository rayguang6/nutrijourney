import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ImageRecognitionService {
  final _picker = ImagePicker();
  Interpreter? _interpreter;

  // Future<void> loadModel() async {
  //   _interpreter = await Interpreter.fromAsset('mobilenet_v1_1.0_224.tflite');
  // }

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/mobilenet_v1_1.0_224.tflite');
      print('!!!Model loaded successfully');
    } catch (e) {
      print('###Error loading the model: $e');
    }
  }

  Future<File> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      throw Exception('No image selected.');
    }
  }

  Future<List<dynamic>> runTfliteModel(File image) async {
    var imageBytes = (await img.decodeImage(File(image.path).readAsBytesSync()))!;
    img.Image resizedImg = img.copyResize(imageBytes, width: 224, height: 224);

    var input = resizedImg.getBytes();
    var output = List.filled(1 * 1000, 0).reshape([1, 1000]); // Adjust size according to the model's output

    _interpreter?.run(input, output);

    if (output.isNotEmpty && output[0] is List<dynamic>) {
      var outputList = output[0] as List<dynamic>;
      if (outputList.isNotEmpty && outputList[0] is Map<String, dynamic>) {
        return outputList.map((e) {
          if (e is Map<String, dynamic> && e.containsKey('label')) {
            return {
              'label': e['label'] as String,
              'confidence': e['confidence'] as double,
            };
          } else {
            // Handle any other case where 'label' or 'confidence' is missing.
            return {'label': 'Unknown', 'confidence': 0.0};
          }
        }).toList();
      }
    }

    // If the structure of the output is not as expected, return an empty list or handle the error accordingly.
    return [];
  }

}
