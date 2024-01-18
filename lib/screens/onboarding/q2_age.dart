import 'package:flutter/material.dart';
import 'package:nutrijourney/screens/onboarding/q3_weight_height.dart';

import '../../services/onboarding_service.dart';
import '../../utils/constants.dart';
import '../../utils/numeric_formatter.dart';

class Q2_Age extends StatefulWidget {

  @override
  State<Q2_Age> createState() => _Q2_AgeState();
}

class _Q2_AgeState extends State<Q2_Age> {

  final TextEditingController ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    ageController.dispose();
    super.dispose();
  }


  void _saveData(num answer) async {
    final OnboardingService _onboardingService = OnboardingService();

    await _onboardingService.saveUserData({'age': answer});

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Q3_WeightHeight()), // Replace with the next onboarding screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Age"),
      backgroundColor: kPrimaryGreen,
        bottom: PreferredSize(
          preferredSize: Size(30, 30),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Step 2 of 6",
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Text("Your Age", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
            SizedBox(height: 32,),
            Container(
              width: 200,
              child: TextFormField(
                controller: ageController,
                inputFormatters: [NumericInputFormatter()],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter number';
                  }
                  return null;
                },
              ),
            ),

            SizedBox(height: 32,),


            Container(
              width: 200,
              child: InkWell(
                onTap: () {
                  _saveData(int.parse(ageController.text));
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
            ),

          ],
        ),
      ),
    );
  }
}
