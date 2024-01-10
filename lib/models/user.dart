import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String profileImage;
  List<String>? preference;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.profileImage,
    this.preference,
  });

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    List<String>? preference = [];
    if (snapshot["preference"] != null) {
      preference = List<String>.from(snapshot["preference"]);
    }

    return UserModel(
      uid: snapshot["uid"],
      username: snapshot["username"],
      email: snapshot["email"],
      profileImage: snapshot["profileImage"],
      preference: preference,
    );
  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "username": username,
    "email": email,
    "profileImage": profileImage,
    "preference": preference ?? [],
  };

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      username: data['username'],
      email: data['email'],
      profileImage: data['profileImage'],
    );
  }
}
