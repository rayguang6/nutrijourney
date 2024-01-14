import 'package:flutter/material.dart';
import 'package:nutrijourney/screens/dashboard_screen.dart';
import 'package:nutrijourney/screens/onboarding/q2_age.dart';
import 'package:nutrijourney/screens/onboarding/q3_weight_height.dart';

import '../../services/onboarding_service.dart';

class Q1_Gender extends StatefulWidget {

  @override
  State<Q1_Gender> createState() => _Q1_GenderState();
}

class _Q1_GenderState extends State<Q1_Gender> {
  void saveGenderAndNavigate(BuildContext context, String gender) async {
    final OnboardingService _onboardingService = OnboardingService();

    await _onboardingService.saveUserData({'gender': gender});

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Q2_Age()), // Replace with the next onboarding screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Gender")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => saveGenderAndNavigate(context, "Male"),
              child: Text("Male"),
            ),
            ElevatedButton(
              onPressed: () => saveGenderAndNavigate(context, "Female"),
              child: Text("Female"),
            ),
          ],
        ),
      ),
    );
  }
}
