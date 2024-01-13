class Meal {
  String id;
  String name;
  DateTime date;
  int calories;
  double carbs; // in grams
  double proteins; // in grams
  double fats; // in grams
  String type; // 'breakfast', 'lunch', 'dinner'

  Meal({required this.id, required this.name, required this.date, required this.calories, required this.carbs, required this.proteins, required this.fats, required this.type});

// Serialization and deserialization methods
}
