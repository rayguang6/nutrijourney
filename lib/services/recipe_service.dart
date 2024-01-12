import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/recipe.dart';
import '../utils/utils.dart';


class RecipeService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> createRecipe(
      title,
      description,
      time,
      instructions,
      image,
      calories,
      fats,
      proteins,
      carbohydrates,
      createdBy,
      uid,
      ingredients,
      savedBy,
      ) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management

    String res = "Some error occurred"; // set res as error first

    try {
      String imageLink =
          "https://docs.flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png";

      imageLink = await uploadImageToStorage('recipes', image);

      String recipeId = const Uuid().v1(); // creates unique id based on time

      List savedBy = []; // temp

      Recipe recipe = Recipe(
        recipeId: recipeId,
        title: title,
        description: description,
        image: imageLink,
        calories: calories,
        fats: fats,
        proteins: proteins,
        carbohydrates: carbohydrates,
        time: time,
        uid: uid,
        createdBy: createdBy,
        ingredients: ingredients,
        savedBy: savedBy,
        instructions: instructions,
      );

      firestore.collection('recipes').doc(recipeId).set(recipe.toJson());

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> saveRecipe(String recipeId, String uid, List savedBy) async {
    String response = "Some error occurred";

    // print("recipeID: " + recipeId);
    // print("UID: " + uid);
    // print(savedBy.toString());

    try {
      if (savedBy.contains(uid)) {
        // if the savedBy list contains the user uid, we need to remove it
        firestore.collection('recipes').doc(recipeId).update({
          'savedBy': FieldValue.arrayRemove([uid])
        });

        response = 'Removed from Save';
      } else {
        // else we need to add uid to the savedBy array
        firestore.collection('recipes').doc(recipeId).update({
          'savedBy': FieldValue.arrayUnion([uid])
        });
        response = 'Saved';
      }
    } catch (error) {
      response = error.toString();
    }
    return response;
  }

  Future<String> deleteRecipe(String recipeId) async {
    String res = "error deleting recipe";
    try {
      await firestore.collection('recipes').doc(recipeId).delete();
      res = 'success';
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<String> updateRecipe(
      recipeId,
      title,
      description,
      time,
      instructions,
      calories,
      fats,
      proteins,
      carbohydrates,
      ingredients,
      ) async {
    String response = "update recipe";
    try {
      await firestore.collection('recipes').doc(recipeId).update({
        "title": title,
        "description": description,
        "time": time,
        "instructions": instructions,
        "calories": calories,
        "fats": fats,
        "proteins": proteins,
        "carbohydrates": carbohydrates,
        "ingredients": ingredients,
      });

      response = "success";
    } catch (error) {
      response = error.toString();
    }

    return response;
  }
}
