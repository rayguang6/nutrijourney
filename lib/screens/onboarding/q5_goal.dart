import 'package:flutter/material.dart';
import 'package:nutrijourney/screens/onboarding/onboarding_success_screen.dart';
import 'package:nutrijourney/screens/onboarding/q3_weight_height.dart';
import 'package:nutrijourney/screens/onboarding/q6_active.dart';
import 'package:nutrijourney/screens/responsive/mobile_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../services/onboarding_service.dart';

class Q5_Goal extends StatefulWidget {

  @override
  State<Q5_Goal> createState() => _Q5_GoalState();
}

class _Q5_GoalState extends State<Q5_Goal> {

  void _saveData(BuildContext context, String answer) async {
    final OnboardingService _onboardingService = OnboardingService();

    await _onboardingService.saveUserData({'goal': answer});
    await Provider.of<UserProvider>(context, listen: false).setUser();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Q6_ActiveLevel()), // Replace with the next onboarding screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("What is your goal?")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            ElevatedButton(
              onPressed: () => _saveData(context, "Lose Weight"),
              child: Text("Lose Weight"),
            ),
            ElevatedButton(
              onPressed: () => _saveData(context, "Maintain Weight"),
              child: Text("Mantain Weight"),
            ),
            ElevatedButton(
              onPressed: () => _saveData(context, "Gain Weight"),
              child: Text("Gain Weight"),
            ),

          ],
        ),
      ),
    );
  }
}
