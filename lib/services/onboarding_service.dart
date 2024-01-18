import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutrijourney/models/user.dart';

class OnboardingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users')
          .doc(user.email).set(userData, SetOptions(merge: true));
    }
  }

  num calculateSuggestedCalories(UserModel user){

    num suggestedCalories = 0;
    num? weight = user?.weight;
    num? height = user?.height;
    num? age = user?.age;
    String? username = user?.username;
    String? activeLevel = user?.activeLevel;
    String? goal = user?.goal;

    num BMR = 0;


    if (user?.gender == 'Male') {
      BMR = 66.5 + (13.75 * weight!) + (5.003 * height!) - (6.75 * age!);
    } else if (user?.gender == 'Female') {
      BMR = 655.1 + (9.563 * weight!) + (1.850 * height!) - (4.676 * age!);
    }

    //based on active level
    if(activeLevel == "Sedentary"){
      suggestedCalories = BMR*1.2;
    }
    if(activeLevel == "Lightly Active"){
      suggestedCalories = BMR * 1.375;
    }
    if(activeLevel == "Moderately Active"){
      suggestedCalories = BMR*1.55;
    }
    if(activeLevel == "Very Active"){
      suggestedCalories = BMR*1.725;
    }
    if(activeLevel == "Extra Active"){
      suggestedCalories = BMR*1.9;
    }

    if(goal == "Lose Weight"){
      suggestedCalories -= 550;
    }

    if(goal == "Gain Weight"){
      suggestedCalories += 550;
    }

    //update the suggestedCalories
    saveUserData({"suggestedCalories", suggestedCalories} as Map<String, dynamic>);


    return suggestedCalories;
  }


}
