import 'package:flutter/material.dart';
import 'package:nutrijourney/utils/constants.dart';

class CaloriesProgressBar extends StatefulWidget {
  final double consumedCalories;
  final double targetCalories;

  const CaloriesProgressBar({
    Key? key,
    required this.consumedCalories,
    required this.targetCalories,
  }) : super(key: key);

  @override
  _CaloriesProgressBarState createState() => _CaloriesProgressBarState();
}

class _CaloriesProgressBarState extends State<CaloriesProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: Colors.green,
      end: Colors.red,
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _updateProgress();
  }

  void _updateProgress() {
    double progress = (widget.consumedCalories / widget.targetCalories).clamp(0.0, 1.0);
    _controller.value = progress;
  }

  @override
  void didUpdateWidget(covariant CaloriesProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateProgress();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Suggested Daily Calories: ${widget.consumedCalories} / ${widget.targetCalories}",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: _controller.value,
            minHeight: 20,
            backgroundColor: Colors.grey[300],
            valueColor: _colorAnimation,
          ),
        ),
      ],
    );
  }
}
