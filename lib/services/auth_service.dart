
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart' as model;
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/utils.dart';

class AuthService {
  final FirebaseAuth _firebaseauth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signUp({
    required String username,
    required String email,
    required String password,
    Uint8List? file,
  }) async {

    if(username.isEmpty || email.isEmpty || password.isEmpty || file == null ){
      return "Please Fill in All Fields";
    }

    UserCredential userCredential = await _firebaseauth.createUserWithEmailAndPassword(email: email, password: password);

    try {
      String imageLink = "";
      try {
        //first, we upload the image to the firebase storage, and getback the image link
        imageLink = await uploadImageToStorage('profilePicture', file);
      }
      catch(e){
        return "Failed to upload image: ${e.toString()}";
      }


      //second, we create Dart model based on the data we get from signup form
      model.UserModel _user = model.UserModel(
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

    //by default will return an error,
    //if got something happens, then will update the message
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

  // get user details
  Future<UserModel> getUserDetails() async {
    User loggedInUser = _firebaseauth.currentUser!;

    DocumentSnapshot documentSnapshot =
    await _firestore.collection('users').doc(loggedInUser.email).get();

    return UserModel.fromSnap(documentSnapshot);
  }

  Future<void> signOut() async {
    await _firebaseauth.signOut();
  }

}
