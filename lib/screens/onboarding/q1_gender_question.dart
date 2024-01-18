import 'package:flutter/material.dart';
import 'package:nutrijourney/screens/dashboard_screen.dart';
import 'package:nutrijourney/screens/onboarding/q2_age.dart';
import 'package:nutrijourney/screens/onboarding/q3_weight_height.dart';
import 'package:nutrijourney/utils/constants.dart';

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
      appBar: AppBar(title: Text("Select Your Gender"),
      backgroundColor: kPrimaryGreen,
        bottom: PreferredSize(
          preferredSize: Size(30, 30),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Step 1 of 6",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        ),
        elevation: 0.1,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          Text("Your Gender", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
          SizedBox(height: 32),
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            InkWell(
              onTap: ()=> saveGenderAndNavigate(context, "Male"),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.lightBlueAccent.shade100.withOpacity(0.2),
                    borderRadius: BorderRadius.all(Radius.circular(12))
                ),
                child: Center(
                  child: Text("Male\n 🙋‍♂️",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 24,),
            InkWell(
              onTap: ()=> saveGenderAndNavigate(context, "Female"),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.pinkAccent.shade100.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(12))
                ),
                child: Center(
                  child: Text("Female\n 🙋‍♀",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),

          ],
          ),
        ],
      ),
    );
  }
}
