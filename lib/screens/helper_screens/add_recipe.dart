import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../services/recipe_service.dart';
import '../../utils/constants.dart';
import '../../utils/numeric_formatter.dart';
import '../../utils/utils.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({Key? key}) : super(key: key);

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
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

// function to open dialog to pick image
  Future<void> _selectImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Upload Image"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    Uint8List? file = await selectImage(ImageSource.camera);
                    if (file != null) {
                      setState(() {
                        _image = file;
                      });
                    }
                  },
                  child: const Text("Take a photo"),
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    Uint8List? file = await selectImage(ImageSource.gallery);
                    if (file != null) {
                      setState(() {
                        _image = file;
                      });
                    }
                  },
                  child: const Text("Choose from Gallery"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _removeImage() {
    setState(() {
      _image = null;
    });
  }

  void addRecipe() async {
    // first, set the isLoading to true. So that the UI will show loading
    setState(() {
      isLoading = true;
    });

    //get data from the text controller
    String title = titleController.text;
    String description = descriptionController.text;
    int time = int.parse(timeController.text);
    double calories = double.parse(caloriesController.text);
    double fats = double.parse(fatsController.text);
    double proteins = double.parse(proteinsController.text);
    double carbohydrates = double.parse(carbohydratesController.text);
    String instructions = instructionsController.text;
    String ingredients = ingredientsController.text;
    List savedBy = [];

    //get detail of current user
    final UserProvider userProvider =
    Provider.of<UserProvider>(context, listen: false);
    String uid = userProvider.getUser!.uid;
    String createdBy = userProvider.getUser!.username;

    //create a default image if user dont select image
    String imgPath = 'assets/images/default-recipe.png';
    final ByteData bytes = await rootBundle.load(imgPath);
    final Uint8List defaultImage = bytes.buffer.asUint8List();

    //start showing loading
    setState(() {
      isLoading = true;
    });

    try {
      String res = await RecipeService().createRecipe(
        title,
        description,
        time,
        instructions,
        _image ?? defaultImage,
        calories,
        fats,
        proteins,
        carbohydrates,
        createdBy,
        uid,
        ingredients,
        savedBy,
      );

      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, 'Added Recipe $title');
        _removeImage();
        Navigator.pop(context);
      } else {
        showSnackBar(context, res);
        Navigator.pop(context);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, err.toString());
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
                addRecipe();
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
              Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: _selectImage,
                  child: Stack(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: _image != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.memory(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            const Text(
                              'Tap to upload image',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_image != null)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: _removeImage,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                    ],
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
                      inputFormatters: [NumericInputFormatter()],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Time (minutes)',
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
                      addRecipe();
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
