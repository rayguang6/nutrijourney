import 'package:flutter/material.dart';
import 'package:nutrijourney/utils/constants.dart';

class CaloriesProgressBar extends StatelessWidget {
  final double consumedCalories;
  final double targetCalories;

  const CaloriesProgressBar({
    Key? key,
    required this.consumedCalories,
    required this.targetCalories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = (consumedCalories / targetCalories).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Calories: $consumedCalories / $targetCalories",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 20,
            backgroundColor: Colors.grey[300],
            // color: kPrimaryGreen,
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}
