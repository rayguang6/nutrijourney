import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrijourney/utils/utils.dart';

import '../../services/onboarding_service.dart';
import '../../utils/numeric_formatter.dart';

class TrackWeightScreen extends StatefulWidget {
  const TrackWeightScreen({Key? key}) : super(key: key);

  @override
  State<TrackWeightScreen> createState() => _TrackWeightScreenState();
}

class _TrackWeightScreenState extends State<TrackWeightScreen> {
  double weight = 0;
  DateTime selectedDate = DateTime.now();  // Assuming you want to save the current date
  TextEditingController weightController = TextEditingController();

  void _saveData() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    double _weight = double.parse(weightController.text);
    User? user = _auth.currentUser;

    if (user != null) {
      String formattedDate = formatDate(selectedDate);
      DocumentReference docRef = _firestore.collection('users').doc(user.email)
          .collection("weight").doc(formattedDate);

      // Check if the document for the selected date exists
      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Update existing document
        await docRef.update({
          'weight': _weight,
          'date': selectedDate,
        });
      } else {
        // Create a new document
        await docRef.set({
          'weight': _weight,
          'date': selectedDate,
        }, SetOptions(merge: true));
      }

      final OnboardingService _onboardingService = OnboardingService();

      await _onboardingService.saveUserData({'weight': weight.round()});

      showSnackBar(context, "Successfully Saved $_weight kg at ${formatDate(selectedDate)}! \n ${selectedDate.toIso8601String()}");
    }
  }


  @override
  Widget build(BuildContext context) {



// Function to present a date picker and store the selected date

// A simple UI to enter weight

    return Scaffold(
      appBar: AppBar(
        title: Text("Track Weight"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            title: const Text('Date'),
            trailing: TextButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.utc(2020, 1, 1),
                  lastDate: DateTime(2100),

                );
                if (picked != null && picked != selectedDate) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Text(
                DateFormat('MMM d, yyyy').format(selectedDate),
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
          ListTile(
            title: const Text('Weight(kg)'),
            trailing: Container(
              width: 150,
              child: TextFormField(
                controller: weightController,
                inputFormatters: [NumericInputFormatter()],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a time';
                  }
                  return null;
                },
              ),
            ),
          ),
          ElevatedButton(onPressed: _saveData, child: Text("Save")),
        ],
      ),
    );
  }
}
