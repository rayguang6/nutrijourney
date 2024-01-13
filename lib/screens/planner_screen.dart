import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({Key? key}) : super(key: key);

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
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
      appBar: AppBar(
        title: Text('Tracker Page'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Column(
          children: [
            //Row is widget for selecting the date
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
            const Text(
              'Meal Plan',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            const Expanded(child: SingleChildScrollView(
              child: Column(
                children: [
                //  summary insights for the day
                Text("Breakfast")
                //  build out the container for breakfast, lunch, dinner

                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
