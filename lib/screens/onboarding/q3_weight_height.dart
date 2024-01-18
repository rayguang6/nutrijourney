import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nutrijourney/screens/dashboard_screen.dart';
import 'package:nutrijourney/screens/onboarding/q4_allergic.dart';
import 'package:nutrijourney/screens/onboarding/q5_goal.dart';
import 'package:nutrijourney/screens/responsive/mobile_screen.dart';

import '../../services/onboarding_service.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../../widgets/progress_indicator.dart';

class Q3_WeightHeight extends StatefulWidget {

  @override
  State<Q3_WeightHeight> createState() => _Q3_WeightHeightState();
}

class _Q3_WeightHeightState extends State<Q3_WeightHeight> {
  double weight = 60;
  double height = 160;

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
      appBar: AppBar(title: Text("Your Weight and Height"),
        backgroundColor: kPrimaryGreen,
        bottom: PreferredSize(
          preferredSize: Size(30, 30),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Step 3 of 6",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        ),
        elevation: 0.1,
      ),
      body: Center(
        child: Container(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Select Your Weight(kg)",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kDarkGreen
                ),
              ),
              SizedBox(height: 24,),
              CupertinoPicker(
                itemExtent: 48,
                scrollController: FixedExtentScrollController(
                  initialItem: weight.toInt(),
                ),
                onSelectedItemChanged: (int index) {
                  setState(() {
                    weight = index.toDouble();
                  });
                },
                children: List.generate(201, (index) {
                  return Center(
                    child: Text(
                      '$index KG',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_downward,
                    size: 12,
                    color: Colors.grey,
                  ),
                  Text(
                    "Scroll to select",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 48,
              ),
              Text(
                "Select Your Height(cm)",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kDarkGreen
                ),
              ),
              SizedBox(
                height: 24,
              ),
              CupertinoPicker(
                itemExtent: 48,
                scrollController: FixedExtentScrollController(
                  initialItem: height.toInt(),
                ),
                onSelectedItemChanged: (int index) {
                  setState(() {
                    height = index.toDouble();
                  });
                },
                children: List.generate(301, (index) {
                  return Center(
                    child: Text(
                      '$index cm',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_downward,
                    size: 12,
                    color: Colors.grey,
                  ),
                  Text(
                    "Scroll to select",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 32,
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
                      'Next 👉️️',
                      style: TextStyle(color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
