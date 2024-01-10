import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrijourney/screens/responsive/mobile_screen.dart';
import 'package:nutrijourney/screens/signin_screen.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import '../widgets/text_input.dart';
import 'dashboard_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // for loading indicator
  Uint8List? _image; //initialize the image, we will update it later using setstate

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  //function for calling utils to selectImage
  pickImage() async {
    Uint8List imageUploaded = await selectImage(ImageSource.gallery);

    //use setstate to update the uploaded image, then we can replace the default profile image
    setState(() {
      _image = imageUploaded;
    });
  }

  void signUpUser() async{
    setState(() {
      _isLoading = true;
    });

    //set default profile if the user dont want to upload iamge
    String imgPath = 'assets/images/default-profile.png';
    final ByteData bytes = await rootBundle.load(imgPath);
    final Uint8List defaultProfileImage = bytes.buffer.asUint8List();

    // Call the AuthService to sign up
    String? errorMessage = await AuthService().signUp(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      file: _image ?? defaultProfileImage,
    );

    if (errorMessage == null) {
      //set the user first
      await Provider.of<UserProvider>(context, listen: false).setUser();

      // Success, navigate to home or another appropriate screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MobileScreen()), // Replace with your home screen
      );
    } else {
      // If registration fails, show a Snackbar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }



    setState(() {
      _isLoading = false;
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image!),
                      backgroundColor: Colors.blueAccent,
                    )
                        : const CircleAvatar(
                      radius: 64,
                      backgroundImage:
                      AssetImage("assets/images/default-profile.png"),
                      backgroundColor: kPrimaryGreen,
                    ),
                    Positioned(
                      bottom: -10,
                      right: 80,
                      child: IconButton(
                        onPressed: pickImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextInputField(
                  hintText: 'Enter your username',
                  textInputType: TextInputType.text,
                  textEditingController: _usernameController,
                ),
                const SizedBox(height: 16),
                TextInputField(
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                        borderSide: Divider.createBorderSide(context)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: Divider.createBorderSide(context)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: Divider.createBorderSide(context)),
                    filled: true,
                    contentPadding: const EdgeInsets.all(8),
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: kPrimaryGreen,
                    ),
                    child: !_isLoading
                        ? const Text(
                      'Sign up',
                      style: TextStyle(color: Colors.white),
                    )
                        : const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 60, // Add a specific height to the container
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text('Already have an account?'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          ' Sign In',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
