import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../screens/Dashboard2.dart';

class NutritionBarChart extends StatelessWidget {
  final Map<String, DailyNutritionData> weeklyData;

  NutritionBarChart({Key? key, required this.weeklyData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> weekDays = weeklyData.keys.toList();
    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < weekDays.length; i++) {
      // Create bar groups here
      // Use 'i' as the index for BarChartGroupData
    }

    int index = 0;
    weeklyData.forEach((day, data) {
      weekDays.add(day); // Add date to weekDays list

      final group = BarChartGroupData(
        x: index++,
        barRods: [
          BarChartRodData(
            y: data.totalCalories.toDouble(),
            colors: [Colors.blue, Colors.lightBlueAccent.shade100],
            borderRadius: BorderRadius.all(Radius.circular(2)),
            width: 16, // Adjust the width as needed
            // Additional customization here
          ),
          // Optionally add more BarChartRodData for carbs, proteins, and fats
        ],
        // Additional group customization here
      );

      barGroups.add(group);
      // index++;
    });

    return BarChart(
      BarChartData(
        barGroups: barGroups,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            getTitles: (double value) {
              // print("Index being accessed: $value");
              return weekDays[(value.toInt())]; // Show date on X-axis
            },
            // Additional title customization here
          ),
          leftTitles: SideTitles(
            showTitles: true,
            interval: 100,
            margin: 30,
            reservedSize: 50
          ), // Y-axis title customization
          rightTitles: SideTitles(showTitles: false), // Y-axis title customization
          topTitles: SideTitles(showTitles: false)
        ),
        borderData: FlBorderData(show: false),
        
        // Additional chart customization here
      ),
    );
  }
}
