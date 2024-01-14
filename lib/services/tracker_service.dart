import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrijourney/models/meal.dart';
import 'package:nutrijourney/providers/user_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/recipe.dart';
import '../utils/utils.dart';

class TrackerService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> trackMeal(
      email,
      mealType,
      selectedDate,
      mealName,
      calories,
      carbohydrates,
      proteins,
      fats,
      image
      ) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management

    String res = "Some error occurred"; // set res as error first

    try {
      String imageLink =
          "https://docs.flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png";

      imageLink = await uploadImageToStorage('recipes', image);

      String trackerId = const Uuid().v1(); // creates unique id based on time

      Meal meal = Meal(
        mealId: trackerId,
        mealName: mealName,
        mealType: mealType,
        image: imageLink,
        selectedDate: selectedDate,
        calories: calories,
        fats: fats,
        proteins: proteins,
        carbohydrates: carbohydrates,
      );

      firestore.collection('users')
            .doc(email)
            .collection('tracker')
            .doc(selectedDate)
            .collection(selectedDate).add(meal.toJson());

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
