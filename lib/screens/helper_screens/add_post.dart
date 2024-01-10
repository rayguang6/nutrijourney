import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrijourney/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../services/post_service.dart';
import '../../utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  List<String> postType = [ "Sharing", "Questions", "Recipe", "Tips & Tricks", "Experience"];
  String selectedPostType = "Sharing";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setDefaultImage();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;

  //function to create post
  void addPost() async {
    String title = _titleController.text;
    String content = _contentController.text;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String uid = userProvider.getUser!.uid;
    String email = userProvider.getUser!.email;
    String username = userProvider.getUser!.username;
    String profileImage = userProvider.getUser!.profileImage;


    String imgPath = 'assets/images/default-post.png';
    final ByteData bytes = await rootBundle.load(imgPath);
    final Uint8List defaultPostImage = bytes.buffer.asUint8List();



    setState(() {
      isLoading = true;
    });

    try {
      String res = await PostService()
          .createPost(title, content, _image ?? defaultPostImage, uid, username, profileImage, selectedPostType);

      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, 'Added Post $title');
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kBlack),
        title: const Text("Create A Post",
          style: TextStyle(color: kBlack),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: (){
              if (_formKey.currentState!.validate()) {
                addPost();
              }
            },
            child: const Text(
              "Post",
              style: TextStyle(
                  color: kPrimaryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32.0),
        child: isLoading
            ? const LinearProgressIndicator()
            :Form(
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
              SizedBox(height: 16.0),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Your Amazing Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: kPrimaryGreen, width: 2.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _contentController,
                minLines: 5,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: "Your Content Here",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: kPrimaryGreen, width: 2.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ListTile(
                title: const Text('Post Type'),
                trailing: DropdownButton<String>(
                  value: selectedPostType,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedPostType = newValue;
                      });
                    }
                  },
                  items: postType.map((String mealType) {
                    return DropdownMenuItem<String>(
                      value: mealType,
                      child: Text(mealType),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      addPost();
                    }
                  },
                  child: Text(
                    "Post",
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


