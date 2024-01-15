import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

class ImageRecog2 extends StatefulWidget {
  const ImageRecog2({Key? key}) : super(key: key);

  @override
  State<ImageRecog2> createState() => _ImageRecog2State();
}

class _ImageRecog2State extends State<ImageRecog2> {
  late ImagePicker imagePicker;
  File? _image;
  String result = "Results will be shown here";

  dynamic imageLabeler;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();
    final ImageLabelerOptions options = ImageLabelerOptions(confidenceThreshold: 0.5);
    imageLabeler = ImageLabeler(options: options);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  //Capture image from gallery
  _imgFromGallery() async {
    XFile? pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery);
    _image = File(pickedFile!.path);
    setState(() {
      _image;
      doImageLabelling();
    });
  }

  //Capture image from camera
  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    _image = File(pickedFile!.path);
    setState(() {
      _image;
      doImageLabelling();
    });
  }

    doImageLabelling() async {
      InputImage inputImage = InputImage.fromFile(_image!);
      final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);

      result = "";
      for (ImageLabel label in labels) {
        final String text = label.label;
        final int index = label.index;
        final double confidence = label.confidence;

        result += text + " " + confidence.toStringAsFixed(2) +"\n";
      }
      setState(() {
        result;
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Hello Image"),
          // Image.asset("")
          ElevatedButton(
            onPressed: _imgFromGallery,
            onLongPress: _imgFromCamera,
            child: _image != null
              ? Image.file(
              _image!,
              width: 335,
              height: 495,
              fit: BoxFit.fill,
            )
            :Container(
              width: 340,
              height: 495,
              child: const Icon(
                Icons.camera_alt,
                color: Colors.black,
                size: 100,
              ),
            ),
          ),
          Text(result),

        ],
      ),
    );
  }




}
