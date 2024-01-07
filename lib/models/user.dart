import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String username;
  final String email;
  final String profileImage;
  List<String>? preference;

  User({
    required this.uid,
    required this.username,
    required this.email,
    required this.profileImage,
    this.preference,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    List<String>? preference = [];
    if (snapshot["preference"] != null) {
      preference = List<String>.from(snapshot["preference"]);
    }

    return User(
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
}
