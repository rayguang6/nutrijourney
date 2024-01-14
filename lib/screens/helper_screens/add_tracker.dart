import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrijourney/services/tracker_service.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../utils/constants.dart';
import '../../utils/numeric_formatter.dart';
import '../../utils/utils.dart';

class AddTracker extends StatefulWidget {
  String dateSelected;
  String mealType;
  AddTracker({Key? key, required this.dateSelected, required this.mealType}) : super(key: key);

  @override
  State<AddTracker> createState() => _AddTrackerState();
}

class _AddTrackerState extends State<AddTracker> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mealNameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _carbohydratesController = TextEditingController();
  final TextEditingController _proteinsController = TextEditingController();
  final TextEditingController _fatsController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false; //used to show the loading indicator

  @override
  Widget build(BuildContext context) {

    void addToTracker() async {
      // first, set the isLoading to true. So that the UI will show loading
      setState(() {
        isLoading = true;
      });

      //get data from the text controller
      String mealName = _mealNameController.text;
      double calories = double.parse(_caloriesController.text);
      double carbohydrates = double.parse(_carbohydratesController.text);
      double proteins = double.parse(_proteinsController.text);
      double fats = double.parse(_fatsController.text);

      //get detail of current user
      final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
      String? uid = userProvider.getUser?.uid;
      String? createdBy = userProvider.getUser?.username;

      //create a default image if user dont select image
      String imgPath = 'assets/images/default-recipe.png';
      final ByteData bytes = await rootBundle.load(imgPath);
      final Uint8List defaultImage = bytes.buffer.asUint8List();

      //start showing loading
      setState(() {
        isLoading = true;
      });

      try {
        String res = await TrackerService().trackMeal(
          userProvider.getUser?.email,
          widget.mealType,
          widget.dateSelected,
          mealName,
          calories,
          carbohydrates,
          proteins,
          fats,
          _image ?? defaultImage,
        );

        if (res == "success") {
          setState(() {
            isLoading = false;
          });
          showSnackBar(context, 'Added $mealName to ${widget.mealType}');
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


    // function to open dialog to pick image
    _selectImage() async {
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

    @override
    void dispose() {
      super.dispose();
      _mealNameController.dispose();
      _caloriesController.dispose();
      _carbohydratesController.dispose();
      _proteinsController.dispose();
      _fatsController.dispose();
    }


    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: kBlack,
        ),
        title: Text(
          "Track Meal",
          style: TextStyle(color: kBlack),
        ),
        backgroundColor: (Colors.transparent),
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                addToTracker();
              }
            },
            child: const Text(
              "Track",
              style: TextStyle(
                  color: kPrimaryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32.0),
        child: isLoading
          ? const LinearProgressIndicator()
          : Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Track ${widget.mealType} for ${widget.dateSelected}",
                  style: TextStyle(color: kBlack, fontSize: 16),
                ),
                const SizedBox(height: 16,),
                Align(
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    onTap: _selectImage,
                    child: Stack(
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity, // Set width to full width
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
                              Text(
                                'Tap to upload image',
                                style: TextStyle(
                                  color: Colors.grey[300],
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
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _mealNameController,
                  decoration: const InputDecoration(
                    labelText: 'Meal Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Meal Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _caloriesController,
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _carbohydratesController,
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
                  controller: _proteinsController,
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fatsController,
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
                SizedBox(height: 16.0),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        addToTracker();
                      }
                    },
                    child: Text(
                      "Add to Tracker",
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


