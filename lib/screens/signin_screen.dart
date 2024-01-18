import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nutrijourney/screens/dashboard_screen.dart';
import 'package:nutrijourney/screens/responsive/mobile_screen.dart';
import 'package:nutrijourney/screens/responsive/responsive_wrapper.dart';
import 'package:nutrijourney/screens/responsive/web_screen.dart';
import 'package:nutrijourney/screens/signup_screen.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import '../widgets/text_input.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => SignInState();
}

class SignInState extends State<SignInScreen> {
  //create text editing controller to get the inputfield from user
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // to control the state and show the loading indicator

  Future signInUser() async {
    setState(() {
      _isLoading = true;
    });

    String response = await AuthService().signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (response == "success") {
      await Provider.of<UserProvider>(context, listen: false).setUser();
      //
      // UserModel? user = Provider.of<UserProvider>(context, listen: false).getUser;

      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context);

      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          // builder: (context) => const MobileScreen()
          builder: (context) => const ResponsiveWrapper(
            mobileScreen: MobileScreen(),
            webScreen: WebScreen(),
          ),
        ),
            (route) => false,
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, response);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // const SizedBox(height: 16),
                Image.asset(
                  // 'assets/images/vertical_logo.png',
                  'assets/images/nutrijourney_logo.gif',
                  // "assets/images/NutriJourney Final Logo.png",
                  height: 350,
                ),

                Text("Lets Begin your Healthy Journey"),
                const SizedBox(height: 32),
                TextInputField(
                  hintText: 'Enter Your Email',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: "Enter Your Password",
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
                const SizedBox(height: 24),
                InkWell(
                  onTap: signInUser,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      color: kPrimaryGreen,
                    ),
                    child: !_isLoading
                        ? const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    )
                        : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Signing In",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,

                                )
                              ),
                              SizedBox(width: 10),
                              SpinKitDoubleBounce(
                                color: kWhite,
                                size: 16,
                              ),
                            ],
                          )

                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account yet?'),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        ' Signup',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: kDarkGreen
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
