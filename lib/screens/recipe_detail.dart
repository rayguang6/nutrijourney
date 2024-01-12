import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../services/recipe_service.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class RecipeDetailScreen extends StatefulWidget {
  final recipe;

  const RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  DateTime selectedDate = DateTime.now();
  List<String> mealTypes = ["Breakfast", "Lunch", "Dinner"];
  String selectedMealType = "Breakfast";

  @override
  Widget build(BuildContext context) {
    final recipeId = widget.recipe['recipeId'].toString();
    final title = widget.recipe['title'].toString();
    final description = widget.recipe['description'].toString();
    final image = widget.recipe['image'].toString();
    final calories = double.parse(widget.recipe['calories'].toString());
    final fats = double.parse(widget.recipe['fats'].toString());
    final proteins = double.parse(widget.recipe['proteins'].toString());
    final carbohydrates =
    double.parse(widget.recipe['carbohydrates'].toString());
    final time = int.parse(widget.recipe['time'].toString());
    final uid = widget.recipe['uid'].toString();
    final createdBy = widget.recipe['createdBy'].toString();
    final instructions = widget.recipe['instructions'].toString();
    final ingredients = widget.recipe['ingredients'].toString();

    final UserModel? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: kPrimaryGreen,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              image,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: kPrimaryGreen,
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0), // Adjust the padding as needed
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        onPressed: () {
                          showPlannerDialog(context);
                        },
                        child: const Text('Add to Planner'),
                      ),
                      IconButton(
                        icon: widget.recipe['savedBy'].contains(user!.uid)
                            ? const Icon(
                          Icons.bookmark,
                          color: kPrimaryGreen,
                        )
                            : const Icon(
                          Icons.bookmark_outline,
                        ),
                        onPressed: () => RecipeService()
                            .saveRecipe(
                          widget.recipe['recipeId'].toString(),
                          user!.uid,
                          widget.recipe['savedBy'],
                        )
                            .then(
                              (response) => showSnackBar(context, response),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 23,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(description),
                  const SizedBox(height: 24),
                  const Text(
                    'Nutritional Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNutritionItem('Calories', calories),
                      _buildNutritionItem('Fats', fats),
                      _buildNutritionItem('Proteins', proteins),
                      _buildNutritionItem('Carbohydrates', carbohydrates),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text(
                        'Prepare Time',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.access_time,
                        size: 24,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('$time mins'),
                  const SizedBox(height: 16),
                  const Text(
                    'Instructions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(instructions),
                  const SizedBox(height: 16),
                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(ingredients),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionItem(String label, double value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(value.toString()),
      ],
    );
  }

  void showPlannerDialog(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context, listen: false).getUser;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add to Planner'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text('Date'),
                    trailing: TextButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Text(
                        DateFormat('MMM d, yyyy').format(selectedDate),
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('Meal Type'),
                    trailing: DropdownButton<String>(
                      value: selectedMealType,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedMealType = newValue;
                          });
                        }
                      },
                      items: mealTypes.map((String mealType) {
                        return DropdownMenuItem<String>(
                          value: mealType,
                          child: Text(mealType),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                String email = user!.email;
                String formattedDate =
                DateFormat('yyyy-MM-dd').format(selectedDate);

                FirebaseFirestore.instance
                    .collection('users')
                    .doc(email)
                    .collection('planner')
                    .doc(formattedDate)
                    .collection(formattedDate)
                    .add({
                  'mealType': selectedMealType,
                  'mealName': widget.recipe['title'],
                  'calories': widget.recipe['calories'],
                  'fats': widget.recipe['fats'],
                  'carbohydrates': widget.recipe['carbohydrates'],
                  'proteins': widget.recipe['proteins'],
                  'imageUrl': widget.recipe['image'],
                  'recipeId': widget.recipe['recipeId'],
                  'date': selectedDate,
                }).then((value) {
                  showSnackBar(context, "Successfully added to planner");
                  Navigator.pop(context); // Close the dialog
                }).catchError((error) {
                  showSnackBar(
                      context, 'Failed to add meal to planner: $error');
                });
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
