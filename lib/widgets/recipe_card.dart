import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../screens/helper_screens/edit_recipe.dart';
import '../services/recipe_service.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class RecipeCard extends StatefulWidget {
  final recipe;
  final VoidCallback onTap;

  const RecipeCard({
    Key? key,
    required this.recipe,
    required this.onTap,
  }) : super(key: key);

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  DateTime selectedDate = DateTime.now();
  List<String> mealTypes = ["Breakfast", "Lunch", "Dinner"];
  String selectedMealType = "Breakfast";

  _editRecipe() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRecipeScreen(recipe: widget.recipe),
      ),
    );
  }

  _deleteRecipe() async {
    String recipeId = widget.recipe["recipeId"];

    try {
      String response = await RecipeService().deleteRecipe(recipeId);
      if (response == "success") {
        showSnackBar(context, "Deleted Successful");
      } else {
        showSnackBar(context, response);
      }
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  void _confirmDeleteRecipe() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text(
              'Are you sure you want to delete the Recipe "${widget.recipe['title']}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteRecipe();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    widget.recipe['image'].toString(),
                    height: 150.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.purple, width: 1.0),
                              borderRadius:
                              BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Text(
                              "Japan",
                              style: TextStyle(color: Colors.purple),
                            ),
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_filled,
                                    size: 24,
                                    color: Colors.amber,
                                  ),
                                  SizedBox(
                                      width:
                                      4), // Adjust the spacing between the icon and text
                                  Text(
                                    '${widget.recipe['time']} min',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.local_fire_department,
                                    size: 24,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                      width:
                                      4), // Adjust the spacing between the icon and text
                                  Text(
                                    '${widget.recipe['calories']} cal',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        widget.recipe['title'].toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: kPrimaryGreen,
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal:
                                  16.0), // Adjust the padding as needed
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
                            icon: widget.recipe['savedBy'].contains(user?.uid)
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.recipe['uid'].toString() == user!.uid)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.4),
                ),
                child: PopupMenuButton<String>(
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      // Handle Edit
                      _editRecipe();
                    } else if (value == 'delete') {
                      // Handle Delete
                      _confirmDeleteRecipe();
                    }
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
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
                String? email = user?.email;
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
