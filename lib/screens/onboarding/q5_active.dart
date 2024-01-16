import 'package:flutter/material.dart';
import 'package:nutrijourney/screens/onboarding/onboarding_success_screen.dart';
import 'package:nutrijourney/screens/onboarding/q3_weight_height.dart';
import 'package:nutrijourney/screens/responsive/mobile_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../services/onboarding_service.dart';

class Q5_ActiveLevel extends StatefulWidget {

  @override
  State<Q5_ActiveLevel> createState() => _Q5_ActiveLevelState();
}

class _Q5_ActiveLevelState extends State<Q5_ActiveLevel> {
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
