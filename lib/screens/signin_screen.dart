import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrijourney/screens/dashboard_screen.dart';
import 'package:nutrijourney/screens/signup_screen.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
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
      // await Provider.of<UserProvider>(context, listen: false).setUser();
      //
      // User? user = Provider.of<UserProvider>(context, listen: false).getUser;

      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context);

      // Delayed navigation after 10 seconds
      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const DashboardScreen()
          // builder: (context) => const ResponsiveScreen(
          //   mobileScreen: MobileScreen(),
          //   webScreen: WebScreen(),
          // ),
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
              children: [
                const SizedBox(height: 16),
                Image.asset(
                  'assets/images/vertical_logo.png',
                  height: 200,
                ),
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
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: kPrimaryGreen,
                    ),
                    child: !_isLoading
                        ? const Text(
                      'Sign in',
                      style: TextStyle(color: Colors.white),
                    )
                        : const CircularProgressIndicator(
                      color: kWhite,
                    ),
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
                        ' Signup.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
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
