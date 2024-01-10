import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/post_service.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';

class EditPostScreen extends StatefulWidget {
  final post;
  const EditPostScreen({super.key, this.post});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  Uint8List? _image;
  late String _initialImageLink;
  bool isLoading = false; //used to show the loading indicator
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController.text = widget.post['title'];
    _contentController.text = widget.post['content'];
    _initialImageLink = widget.post['postUrl'];
  }

  //function to update post
  void editPost() async {
    setState(() {
      isLoading = true;
    });

    try {
      String response = await PostService().updatePost(widget.post['postId'],
          _titleController.text, _contentController.text);

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

    // try {
    //   String res = await PostService()
    //       .createPost(title, content, _image, uid, username, profileImage);

    //   if (res == "success") {
    //     setState(() {
    //       isLoading = false;
    //     });
    //     showSnackBar(context, 'Added Post $title');
    //     _removeImage();
    //     Navigator.pop(context);
    //   } else {
    //     showSnackBar(context, res);
    //     Navigator.pop(context);
    //   }
    // } catch (err) {
    //   setState(() {
    //     isLoading = false;
    //   });
    //   showSnackBar(context, err.toString());
    // }
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
    _titleController.dispose();
    _contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: kBlack,
        ),
        title: Text(
          "Edit Post",
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
                editPost();
              }
            },
            child: const Text(
              "Save",
              style: TextStyle(
                  color: kPrimaryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: isLoading
            ? const LinearProgressIndicator()
            : Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    _initialImageLink,
                    fit: BoxFit.cover,
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
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      editPost();
                    }
                  },
                  child: Text(
                    "Update",
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
