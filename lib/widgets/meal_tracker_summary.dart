import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';

class MealTrackerSummary extends StatelessWidget {
  String selectedDate;

  MealTrackerSummary({Key? key, required this.selectedDate}) : super(key: key);
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final UserModel? user =
        Provider.of<UserProvider>(context, listen: false).getUser;

    return StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('users')
            .doc(user?.email)
            .collection('tracker')
            .doc(selectedDate)
            .collection(selectedDate)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          // if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          //   return Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Container(
          //       child: const Text("No Summary"),
          //     ),
          //   );
          // }


          //method to calculate
          num totalCalories = 0;
          num totalCarbs = 0;
          num totalProteins = 0;
          num totalFats = 0;

          //method to convert to double
          double safeDouble(dynamic value) {
            if (value is int) return value.toDouble();
            if (value is double) return value;
            return 0.0; // Default value in case the field is missing or not a number
          }

          for (var doc in snapshot.data!.docs) {
            var data = doc.data() as Map<String, dynamic>;
            totalCalories += (data['calories'] as num);
            if (data.containsKey('carbohydrates')) {
              totalCarbs += (data['carbohydrates'] as num);
            }
            if (data.containsKey('proteins')) {
              totalProteins += (data['proteins'] as num);
            }
            if (data.containsKey('fats')) {
              totalFats += (data['fats'] as num);
            }
          }

          return Column(
            children: [
              Text('Total Calories: $totalCalories'),
              Text('Total Carbs: $totalCarbs'),
              Text('Total Proteins: $totalProteins'),
              Text('Total Fats: $totalFats'),
            ],
          );

        });
  }
}

