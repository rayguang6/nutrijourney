import 'package:flutter/material.dart';
import 'package:nutrijourney/screens/onboarding/onboarding_success_screen.dart';
import 'package:nutrijourney/screens/onboarding/q3_weight_height.dart';
import 'package:nutrijourney/screens/responsive/mobile_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../services/onboarding_service.dart';

class Q6_ActiveLevel extends StatefulWidget {

  @override
  State<Q6_ActiveLevel> createState() => _Q6_ActiveLevelState();
}

class _Q6_ActiveLevelState extends State<Q6_ActiveLevel> {
  void _saveData(BuildContext context, String answer) async {
    final OnboardingService _onboardingService = OnboardingService();

    await _onboardingService.saveUserData({'activeLevel': answer});
    await Provider.of<UserProvider>(context, listen: false).setUser();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OnboardingSuccessScreen()), // Replace with the next onboarding screen
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
              onPressed: () => _saveData(context, "Sedentary"),
              child: Text("Sedentary (no exercise)"),
            ),
            ElevatedButton(
              onPressed: () => _saveData(context, "Lightly Active"),
              child: Text("Lightly Active (Sports 1-3days per week)"),
            ),
            ElevatedButton(
              onPressed: () => _saveData(context, "Moderately Active"),
              child: Text("Moderately Active (Sports 3-5days per week)"),
            ),
            ElevatedButton(
              onPressed: () => _saveData(context, "Very Active"),
              child: Text("Very Active (Sports 6-7days per week)"),
            ),
            ElevatedButton(
              onPressed: () => _saveData(context, "Extra Active"),
              child: Text("Extra Active (Sports and physical job, or 2x training)"),
            ),

          ],
        ),
      ),
    );
  }
}
