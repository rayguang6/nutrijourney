import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {
  final String mealId;
  final String mealName;
  final String mealType;
  final String selectedDate;
  final String image;
  final double calories;
  final double fats;
  final double proteins;
  final double carbohydrates;

  Meal({
    required this.mealId,
    required this.mealName,
    required this.mealType,
    required this.selectedDate,
    required this.image,
    required this.calories,
    required this.fats,
    required this.proteins,
    required this.carbohydrates,
  });

  static Meal fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Meal(
      mealId: snapshot["mealId"],
      mealName: snapshot["mealName"],
      mealType: snapshot["mealType"],
      selectedDate: snapshot["date"],
      image: snapshot["imageUrl"],
      calories: snapshot["calories"],
      fats: snapshot["fats"],
      proteins: snapshot["proteins"],
      carbohydrates: snapshot["carbohydrates"],

    );
  }

  Map<String, dynamic> toJson() => {
    "mealId": mealId,
    "mealName": mealName,
    "mealType": mealType,
    "selectedDate": selectedDate,
    "imageUrl": image,
    "calories": calories,
    "fats": fats,
    "proteins": proteins,
    "carbohydrates": carbohydrates,
  };
}
