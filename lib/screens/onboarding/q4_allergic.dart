import 'package:flutter/material.dart';
import 'package:nutrijourney/screens/onboarding/q5_goal.dart';

import '../../services/onboarding_service.dart';

class Q4_AllergySelection extends StatefulWidget {
  @override
  _Q4_AllergySelectionState createState() => _Q4_AllergySelectionState();
}

class _Q4_AllergySelectionState extends State<Q4_AllergySelection> {
  final List<String> allergies = ['Peanuts', 'Shellfish', 'Dairy', 'Eggs', 'Wheat', 'Soy', 'Tree Nuts', 'Fish']; // Example allergies
  final Map<String, bool> selectedAllergies = {};

  @override
  void initState() {
    super.initState();
    // Initialize all allergies as not selected
    for (var allergy in allergies) {
      selectedAllergies[allergy] = false;
    }
  }

  void _saveSelectedAllergies() async {
    final OnboardingService _onboardingService = OnboardingService();

    // Extracting selected allergies into a List<String>
    List<String> selectedAllergyList = selectedAllergies.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    await _onboardingService.saveUserData({'allergies': selectedAllergyList});

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Q5_Goal()), // Navigate to the next screen
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Your Allergies")),
      body: ListView.builder(
        itemCount: allergies.length,
        itemBuilder: (BuildContext context, int index) {
          return CheckboxListTile(
            title: Text(allergies[index]),
            value: selectedAllergies[allergies[index]],
            onChanged: (bool? value) {
              setState(() {
                selectedAllergies[allergies[index]] = value!;
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveSelectedAllergies,
        child: Icon(Icons.save),
      ),
    );
  }
}
