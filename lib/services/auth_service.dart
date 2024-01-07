
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user.dart' as model;
import '../utils/utils.dart';

class AuthService {
  final FirebaseAuth _firebaseauth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signUp({
    required String username,
    required String email,
    required String password,
    required Uint8List file,
  }) async {

    if(username.isEmpty || email.isEmpty || password.isEmpty || file == null ){
      return "Please Fill in All Fields";
    }

    try {

      //first, we upload the image to the firebase storage, and getback the image link
      String imageLink = await uploadImageToStorage('profilePicture', file);

      UserCredential userCredential = await _firebaseauth.createUserWithEmailAndPassword(email: email, password: password);

      //second, we create Dart model based on the data we get from signup form
      model.User _user = model.User(
        uid: userCredential.user!.uid,
        username: username,
        email: email,
        profileImage: imageLink,
      );

      //add the user into firestore DB
      await _firestore
          .collection("users")
          .doc(userCredential.user!.email)
          .set(_user.toJson());

      return null; // Success

    } on FirebaseAuthException catch (e) {
      return e.message; // Return error message
    }
  }

  //# FUNCTION to login the user
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    String response = "error signin user...";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _firebaseauth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        response = "success";
      } else {
        response = "Please enter all fields";
      }
    } catch (error) {
      return error.toString();
    }

    return response;
  }


}
