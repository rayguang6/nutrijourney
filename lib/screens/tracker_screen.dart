import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrijourney/utils/utils.dart';

import '../widgets/DraggableFloatingChatIcon.dart';
import '../widgets/meal_tracker_container.dart';
import '../widgets/meal_tracker_summary.dart';
import 'ai_chat.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({Key? key}) : super(key: key);

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {

  DateTime _currentDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (selected != null && selected != _currentDate) {
      setState(() {
        _currentDate = selected;
      });
    }
  }

  void goToPreviousDay() {
    setState(() {
      _currentDate = _currentDate.subtract(const Duration(days: 1));
    });
  }

  void goToNextDay() {
    setState(() {
      _currentDate = _currentDate.add(const Duration(days: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Column(
              children: [
                //row is for the select date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: goToPreviousDay,
                    ),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(_currentDate),
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: goToNextDay,
                    ),
                  ],
                ),
                // const Text(
                //   'Meal Plan',
                //   style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                // ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //summary container
                        MealTrackerSummary(selectedDate: formatDate(_currentDate)),
                        const SizedBox(height: 16.0),
                        //container for each meal
                        MealTrackerContainer(mealType: 'Breakfast',selectedDate: formatDate(_currentDate),),
                        MealTrackerContainer(mealType: 'Lunch',selectedDate: formatDate(_currentDate),),
                        MealTrackerContainer(mealType: 'Dinner',selectedDate: formatDate(_currentDate),),


                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
          Positioned(
            right: 20,
            bottom: 20,
            child: DraggableFloatingChatIcon(
              // onTap: _showChatBotOverlay,
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AIChatBot()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}
