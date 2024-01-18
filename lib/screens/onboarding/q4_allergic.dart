import 'package:flutter/material.dart';
import 'package:nutrijourney/screens/onboarding/q5_goal.dart';
import 'package:nutrijourney/utils/constants.dart';

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
      appBar: AppBar(
        title: Text("Select Your Allergies 🚨"),
        backgroundColor: kPrimaryGreen,
        bottom: PreferredSize(
          preferredSize: Size(30, 30),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Step 4 of 6",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        ),
        elevation: 0.1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView.builder(
          itemCount: allergies.length,
          itemBuilder: (BuildContext context, int index) {
            bool isSelected = selectedAllergies[allergies[index]] ?? false;
            return Container(
              margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: isSelected ? Colors.red[50] : Colors.white,
                border: Border.all(
                color: isSelected ? Colors.redAccent : Colors.grey.shade100,
                width: 2,
                ),
              borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                title: Text(allergies[index]),
                trailing: isSelected ? Icon(Icons.close, color: Colors.red) : null,
                onTap: () {
                  setState(() {
                    selectedAllergies[allergies[index]] = !isSelected;
                  });
                },
              ),
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveSelectedAllergies,

        backgroundColor: kPrimaryGreen,
        label: Text("Next"),
        icon: Icon(Icons.navigate_next_outlined),
      ),
    );
  }
}
