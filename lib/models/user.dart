import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String profileImage;
  List<String>? preference;
  List<String>? allergies;
  String? gender;
  num? weight;
  num? height;
  num? age;
  String? goal;
  String? activeLevel;
  num? suggestedCalories;
  num? BMR;


  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.profileImage,
    this.preference,
    this.allergies,
    this.gender,
    this.weight,
    this.height,
    this.age,
    this.goal,
    this.activeLevel,
    this.suggestedCalories,
    this.BMR,
  });

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    List<String>? preference = [];
    if (snapshot["preference"] != null) {
      preference = List<String>.from(snapshot["preference"]);
    }
    List<String>? allergies = [];
    if (snapshot["allergies"] != null) {
      allergies = List<String>.from(snapshot["allergies"]);
    }

    return UserModel(
      uid: snapshot["uid"],
      username: snapshot["username"],
      email: snapshot["email"],
      profileImage: snapshot["profileImage"],
      preference: preference,
      allergies: allergies,
      gender: snapshot["gender"],
      weight: snapshot["weight"],
      height: snapshot["height"],
      age: snapshot["age"],
      goal: snapshot["goal"],
      activeLevel: snapshot["activeLevel"],
      suggestedCalories: snapshot["suggestedCalories"],
      BMR : snapshot["BMR"],
    );
  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "username": username,
    "email": email,
    "profileImage": profileImage,
    "preference": preference ?? [],
    "allergies": allergies ?? [],
    "gender": gender,
    "weight": weight,
    "height": height,
    "age": age,
    "goal": goal,
    "activeLevel": activeLevel,
    "suggestedCalories": suggestedCalories,
    "BMR": BMR,
  };
}
