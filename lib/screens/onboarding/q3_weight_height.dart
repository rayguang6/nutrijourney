import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutrijourney/screens/dashboard_screen.dart';
import 'package:nutrijourney/screens/onboarding/q4_allergic.dart';
import 'package:nutrijourney/screens/onboarding/q5_goal.dart';
import 'package:nutrijourney/screens/responsive/mobile_screen.dart';

import '../../services/onboarding_service.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';

class Q3_WeightHeight extends StatefulWidget {

  @override
  State<Q3_WeightHeight> createState() => _Q3_WeightHeightState();
}

class _Q3_WeightHeightState extends State<Q3_WeightHeight> {
  double weight = 0;
  double height = 0;

  void saveWeightHeight() async {
    final OnboardingService _onboardingService = OnboardingService();

    await _onboardingService.saveUserData({'weight': weight.round()});
    await _onboardingService.saveUserData({'height': height.round()});

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Q4_AllergySelection()), // Replace with the next onboarding screen
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Your Weight and Height")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "${weight.round()} KG",
              style:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Slider(
              // thumbColor: kPrimaryGreen,
              inactiveColor: kDarkGreen,
              activeColor: kPrimaryGreen,
              min: 0,
              max: 200,
              value: weight,
              onChanged: (value) {
                setState(() {
                  weight = value;
                });
              },
            ),
            const Text('Enter your height:'),
            Text(
              height.round().toString() + " cm",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Slider(
              inactiveColor: kDarkGreen,
              activeColor: kPrimaryGreen,
              min: 0,
              max: 300,
              value: height,
              onChanged: (value) {
                setState(() {
                  height = value;
                });
              },
            ),
            const SizedBox(
              height: 16,
            ),

            InkWell(
              onTap: () {
                saveWeightHeight();
              },
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
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
