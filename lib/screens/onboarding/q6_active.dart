import 'package:flutter/material.dart';
import 'package:nutrijourney/screens/onboarding/onboarding_success_screen.dart';
import 'package:nutrijourney/screens/onboarding/q3_weight_height.dart';
import 'package:nutrijourney/screens/responsive/mobile_screen.dart';
import 'package:nutrijourney/utils/constants.dart';
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
      appBar: AppBar(title: Text("How active is your lifestyle"),
        backgroundColor: kPrimaryGreen,
        bottom: PreferredSize(
          preferredSize: Size(30, 30),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Step 6 of 6",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        ),
        elevation: 0.1,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //
            // ElevatedButton(
            //   onPressed: () => _saveData(context, "Sedentary"),
            //   child: Text("Sedentary (no exercise)"),
            // ),
            // ElevatedButton(
            //   onPressed: () => _saveData(context, "Lightly Active"),
            //   child: Text("Lightly Active (Sports 1-3days per week)"),
            // ),
            // ElevatedButton(
            //   onPressed: () => _saveData(context, "Moderately Active"),
            //   child: Text("Moderately Active (Sports 3-5days per week)"),
            // ),
            // ElevatedButton(
            //   onPressed: () => _saveData(context, "Very Active"),
            //   child: Text("Very Active (Sports 6-7days per week)"),
            // ),
            // ElevatedButton(
            //   onPressed: () => _saveData(context, "Extra Active"),
            //   child: Text("Extra Active (Sports and physical job, or 2x training)"),
            // ),

            _goalButton(context, "🛋️ Sedentary", "(no exercise)","Sedentary"),
            _goalButton(context, "🚴‍♂️Lightly Active", "(Sports 1-3days per week)","Lightly Active"),
            _goalButton(context, "🏃‍♂️Moderately Active", "(Sports 3-5days per week)","Moderately Active"),
            _goalButton(context, "🏋️‍♀️Very Active", "(Sports 6-7days per week)","Very Active"),
            _goalButton(context, "👷‍♂️Extra Active", "(Sports and physical job, or 2x training)","Extra Active"),

          ],
        ),
      ),
    );
  }

  Widget _goalButton(BuildContext context, String text, String subtext, String value){
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        width: 330,
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade100,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          children: [
            Text(text,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: kDarkGreen,
                  fontSize: 20
              ),
            ),
            Text(subtext,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: kGrey,
                  fontSize: 10
              ),
            ),
          ],

        ),
      ),
      onTap: () {
        setState(() {
          _saveData(context, value);
        });
      },
    );
  }
}
