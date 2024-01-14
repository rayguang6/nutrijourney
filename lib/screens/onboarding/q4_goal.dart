import 'package:flutter/material.dart';
import 'package:nutrijourney/screens/onboarding/q3_weight_height.dart';
import 'package:nutrijourney/screens/responsive/mobile_screen.dart';

import '../../services/onboarding_service.dart';

class Q4_Goal extends StatefulWidget {

  @override
  State<Q4_Goal> createState() => _Q4_GoalState();
}

class _Q4_GoalState extends State<Q4_Goal> {
  void _saveData(BuildContext context, String answer) async {
    final OnboardingService _onboardingService = OnboardingService();

    await _onboardingService.saveUserData({'activeLevel': answer});

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MobileScreen()), // Replace with the next onboarding screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("How active is your lifestyle")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            ElevatedButton(
              onPressed: () => _saveData(context, "🥶Less Active"),
              child: Text("🥶Less Active"),
            ),
            ElevatedButton(
              onPressed: () => _saveData(context, "😶Moderately Active"),
              child: Text("😶Moderately Active"),
            ),
            ElevatedButton(
              onPressed: () => _saveData(context, "🔥Very Active"),
              child: Text("🔥Very Active"),
            ),

          ],
        ),
      ),
    );
  }
}
