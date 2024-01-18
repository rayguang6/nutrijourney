import 'package:flutter/material.dart';
import 'package:nutrijourney/screens/onboarding/onboarding_success_screen.dart';
import 'package:nutrijourney/screens/onboarding/q3_weight_height.dart';
import 'package:nutrijourney/screens/onboarding/q6_active.dart';
import 'package:nutrijourney/screens/responsive/mobile_screen.dart';
import 'package:nutrijourney/utils/constants.dart';
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
      appBar: AppBar(title: Text("What is your Goal?"),
        backgroundColor: kPrimaryGreen,
        bottom: PreferredSize(
          preferredSize: Size(30, 30),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Step 5 of 6",
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



            Text(
              "🎯 What is your Goal?",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kDarkGreen
              ),
            ),

            SizedBox(height: 48,),


            _goalButton(context, "🍽️ Lose Weight", "Lose Weight"),
            _goalButton(context, "😊️ Maintain Weight", "Maintain Weight"),
            _goalButton(context, "🏋️‍♀️ Gain Weight", "Gain Weight"),

          ],
        ),
      ),
    );
  }

  Widget _goalButton(context, String text, String value){
    return Container(
      width: 300,
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade100,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        title: Text(text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: kDarkGreen,
            fontSize: 20
          ),
        ),
        onTap: () {
          setState(() {
            _saveData(context, value);
          });
        },
      ),
    );
  }
}
