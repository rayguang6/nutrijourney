import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'constants.dart';


final FirebaseAuth _firebaseauth = FirebaseAuth.instance;
final FirebaseStorage _firebasestorage = FirebaseStorage.instance;

// for displaying snackbars (popup)
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      backgroundColor: kBlack,
      elevation: 8.0,
      margin: const EdgeInsets.all(8.0),
    ),
  );
}

//for picking image from gallery
selectImage(ImageSource imageSource) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: imageSource);
  if (_file != null) {
    return await _file.readAsBytes();
  }

  print("No Image is Selected! ");

}


// # Upload image to firebase storage
Future<String> uploadImageToStorage(String childName, Uint8List file) async {
  // creating location to our firebase storage

  Reference ref = _firebasestorage.ref().child(childName).child(_firebaseauth.currentUser!.uid);

  String id = const Uuid().v1();
  ref = ref.child(id);

  // putting in uint8list format -> Upload task like a future but not future
  UploadTask uploadTask = ref.putData(file);

  TaskSnapshot snapshot = await uploadTask;
  String downloadUrl = await snapshot.ref.getDownloadURL();
  return downloadUrl;
}

//return formatted date
String formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date).toString();
}