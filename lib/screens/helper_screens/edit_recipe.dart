import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/recipe_service.dart';
import '../../utils/constants.dart';
import '../../utils/numeric_formatter.dart';
import '../../utils/utils.dart';

class EditRecipeScreen extends StatefulWidget {
  final recipe;
  const EditRecipeScreen({super.key, this.recipe});

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController fatsController = TextEditingController();
  final TextEditingController proteinsController = TextEditingController();
  final TextEditingController carbohydratesController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false; //used to show the loading indicator

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.recipe["title"].toString();
    descriptionController.text = widget.recipe["description"].toString();
    timeController.text = widget.recipe["time"].toString();
    instructionsController.text = widget.recipe["instructions"].toString();
    caloriesController.text = widget.recipe["calories"].toString();
    fatsController.text = widget.recipe["fats"].toString();
    proteinsController.text = widget.recipe["proteins"].toString();
    carbohydratesController.text = widget.recipe["carbohydrates"].toString();
    ingredientsController.text = widget.recipe["ingredients"].toString();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    timeController.dispose();
    instructionsController.dispose();
    caloriesController.dispose();
    fatsController.dispose();
    proteinsController.dispose();
    carbohydratesController.dispose();
    ingredientsController.dispose();
    super.dispose();
  }

  _removeImage() {
    setState(() {
      _image = null;
    });
  }

  //function to create post
  void editRecipe() async {
    setState(() {
      isLoading = true;
    });

    String title = titleController.text;
    String description = descriptionController.text;
    int time = int.parse(timeController.text);
    String instructions = instructionsController.text;
    double calories = double.parse(caloriesController.text);
    double fats = double.parse(fatsController.text);
    double proteins = double.parse(proteinsController.text);
    double carbohydrates = double.parse(carbohydratesController.text);
    String ingredients = ingredientsController.text;

    try {
      String response = await RecipeService().updateRecipe(
        widget.recipe['recipeId'],
        title,
        description,
        time,
        instructions,
        calories,
        fats,
        proteins,
        carbohydrates,
        ingredients,
      );

      if (response == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, 'Edited Successfully');
        Navigator.pop(context);
      } else {
        showSnackBar(context, response);
        Navigator.pop(context);
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text(
          'Create a Recipe',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                editRecipe();
              }
            },
            child: const Text(
              "Create",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: isLoading
            ? const LinearProgressIndicator()
            : Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    widget.recipe["image"],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: timeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [NumericInputFormatter()],
                      decoration: const InputDecoration(
                        labelText: 'Time (Minutes)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a time';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: caloriesController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [NumericInputFormatter()],
                      decoration: const InputDecoration(
                        labelText: 'Calories',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter calories';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: fatsController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [NumericInputFormatter()],
                      decoration: const InputDecoration(
                        labelText: 'Fats',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter fats';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: proteinsController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [NumericInputFormatter()],
                      decoration: const InputDecoration(
                        labelText: 'Proteins',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter proteins';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: carbohydratesController,
                keyboardType: TextInputType.number,
                inputFormatters: [NumericInputFormatter()],
                decoration: const InputDecoration(
                  labelText: 'Carbohydrates',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter carbohydrates';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: instructionsController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Instructions',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter instructions';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: ingredientsController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Ingredients',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Add Ingredients';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      editRecipe();
                    }
                  },
                  child: Text(
                    "Create Recipe",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: kPrimaryGreen,
                    padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 32.0), // Adjust the padding as needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
