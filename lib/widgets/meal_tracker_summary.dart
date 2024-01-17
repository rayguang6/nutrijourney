import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import 'calories_progress_bar.dart';

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

        //method to calculate
        num totalCalories = 0;
        num totalCarbs = 0;
        num totalProteins = 0;
        num totalFats = 0;

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

        //
        //default calories if none
        double targetCalories = 2000;

        // Calculate percentages
        num totalMacros = totalCarbs + totalProteins + totalFats;
        num carbPercentage =
            totalMacros != 0 ? (totalCarbs / totalMacros) * 100 : 0;
        num proteinPercentage =
            totalMacros != 0 ? (totalProteins / totalMacros) * 100 : 0;
        num fatPercentage =
            totalMacros != 0 ? (totalFats / totalMacros) * 100 : 0;

        return Column(
          children: [
            CaloriesProgressBar(consumedCalories: totalCalories.toDouble(), targetCalories: 2000),
            SizedBox(height: 16,),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      color: Colors.lightBlueAccent,
                      value: carbPercentage.toDouble(),
                      title: '${carbPercentage.toStringAsFixed(1)}% (${totalCarbs.toStringAsFixed(0)}g)',
                      radius: 50,
                      titleStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                      badgeWidget: _buildBadge('Carbs', Colors.blue),
                      badgePositionPercentageOffset: 1.2,  // Adjust this value as needed
                    ),
                    PieChartSectionData(
                      color: Colors.greenAccent,
                      value: proteinPercentage.toDouble(),
                      title: '${proteinPercentage.toStringAsFixed(1)}% (${totalProteins.toStringAsFixed(0)}g)',
                      radius: 50,
                      titleStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                      badgeWidget: _buildBadge('Proteins', Colors.green),
                      badgePositionPercentageOffset: 1.2,  // Adjust this value as needed
                    ),
                    PieChartSectionData(
                      color: Colors.redAccent,
                      value: fatPercentage.toDouble(),
                      title: '${fatPercentage.toStringAsFixed(1)}% (${totalFats.toStringAsFixed(0)}g)',
                      radius: 50,
                      titleStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                      badgeWidget: _buildBadge('Fats', Colors.red),
                      badgePositionPercentageOffset: 1.2,  // Adjust this value as needed
                    ),

                  ],
                ),
              ),
            ),

          ],
        );
      },
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ));
  }
}
