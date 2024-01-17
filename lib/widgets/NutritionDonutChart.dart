import 'package:fl_chart/fl_chart.dart';

import '../screens/Dashboard2.dart';
import 'package:flutter/material.dart';

class NutrientDonutChart extends StatelessWidget {
  final DailyNutritionData nutritionData;

  NutrientDonutChart({Key? key, required this.nutritionData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, double> nutrientPercentages = calculateNutrientPercentages(nutritionData);

    return PieChart(
      swapAnimationDuration: const Duration (milliseconds: 750),
      swapAnimationCurve: Curves. easeInOutQuint,
      PieChartData(
        sectionsSpace: 0,
        centerSpaceRadius: 60,
        sections: buildSections(nutrientPercentages, nutritionData),
        pieTouchData: PieTouchData(
          // touchCallback: (pieTouchResponse) {
          //   // Implement your touch response behavior here
          // },
          enabled: true,
        ),
        startDegreeOffset: 270, // Adjust the start position
        // animationDuration: Duration(milliseconds: 800), // Animation duration
        borderData: FlBorderData(show: false),
      ),
    );
  }

  List<PieChartSectionData> buildSections(Map<String, double> percentages, DailyNutritionData data) {
    return [
      PieChartSectionData(
        color: Colors.redAccent,
        value: percentages['carbs'],
        title: '${percentages['carbs']?.toStringAsFixed(1)}%',
        showTitle: true,
        badgeWidget: _buildBadge('Carbs', Colors.redAccent, data.totalCarbs),
        badgePositionPercentageOffset: 2,
      ),
      PieChartSectionData(
        color: Colors.orangeAccent,
        value: percentages['proteins'],
        title: '${percentages['proteins']?.toStringAsFixed(1)}%',
        showTitle: true,
        badgeWidget: _buildBadge('Proteins', Colors.orangeAccent, data.totalProteins),
        badgePositionPercentageOffset: 2,
      ),
      PieChartSectionData(
          color: Colors.lightBlue,
          value: percentages['fats'],
          title: '${percentages['fats']?.toStringAsFixed(1)}%',
          showTitle: true,
          badgeWidget: _buildBadge('Fats', Colors.lightBlue, data.totalFats),
          badgePositionPercentageOffset: 1.5
      ),
    ];
  }

  Widget _buildBadge(String text, Color color, num value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color,
      ),
      child: Text(
        '$text ${value.toStringAsFixed(0)}g',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  Map<String, double> calculateNutrientPercentages(DailyNutritionData nutritionData) {
    num total = nutritionData.totalCarbs + nutritionData.totalProteins + nutritionData.totalFats;
    return {
      'carbs': total > 0 ? (nutritionData.totalCarbs / total) * 100 : 0,
      'proteins': total > 0 ? (nutritionData.totalProteins / total) * 100 : 0,
      'fats': total > 0 ? (nutritionData.totalFats / total) * 100 : 0,
    };
  }
}
