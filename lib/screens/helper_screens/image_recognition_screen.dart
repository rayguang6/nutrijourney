import 'package:flutter/material.dart';
import '../../services/image_recog_service.dart';
import 'dart:io';

class FoodRecognitionScreen extends StatefulWidget {
  @override
  _FoodRecognitionScreenState createState() => _FoodRecognitionScreenState();
}

class _FoodRecognitionScreenState extends State<FoodRecognitionScreen> {

  @override
  void initState() {
    super.initState();
    _imageRecognitionService.loadModel();
  }



  final ImageRecognitionService _imageRecognitionService = ImageRecognitionService();
  String _recognizedFood = '';

  void _onImageRecognitionTap() async {
    try {
      File image = await _imageRecognitionService.pickImage();
      var recognitions = await _imageRecognitionService.runTfliteModel(image);
      if (recognitions.isNotEmpty) {
        setState(() {
          _recognizedFood = recognitions[0]['label'] as String;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Recognition'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _onImageRecognitionTap,
              child: Text('Scan Food Item'),
            ),
            SizedBox(height: 20),
            Text(
              'Recognized Food: $_recognizedFood',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
