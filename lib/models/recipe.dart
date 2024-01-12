import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String recipeId;
  final String title;
  final String description;
  final String image;
  final double calories;
  final double fats;
  final double proteins;
  final double carbohydrates;
  final int time;
  final String uid;
  final String createdBy;
  final String ingredients;
  final String instructions;
  final savedBy;

  Recipe({
    required this.recipeId,
    required this.title,
    required this.description,
    required this.image,
    required this.calories,
    required this.fats,
    required this.proteins,
    required this.carbohydrates,
    required this.time,
    required this.uid,
    required this.createdBy,
    required this.ingredients,
    required this.savedBy,
    required this.instructions,
  });

  static Recipe fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Recipe(
      recipeId: snapshot["recipeId"],
      title: snapshot["title"],
      description: snapshot["description"],
      image: snapshot["image"],
      calories: snapshot["calories"],
      fats: snapshot["fats"],
      proteins: snapshot["proteins"],
      carbohydrates: snapshot["carbohydrates"],
      time: snapshot["time"],
      uid: snapshot["uid"],
      createdBy: snapshot["createdBy"],
      ingredients: snapshot["ingredients"],
      savedBy: snapshot["savedBy"],
      instructions: snapshot["instructions"],
    );
  }

  Map<String, dynamic> toJson() => {
    "recipeId": recipeId,
    "title": title,
    "description": description,
    "image": image,
    "calories": calories,
    "fats": fats,
    "proteins": proteins,
    "carbohydrates": carbohydrates,
    "time": time,
    "uid": uid,
    "createdBy": createdBy,
    "ingredients": ingredients,
    "savedBy": savedBy,
    "instructions": instructions,
  };
}
