import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/notification_service.dart';

class NotificationSettingsScreen extends StatefulWidget {

  @override
  _NotificationSettingsScreenState createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {


  bool breakfastNotification = false;
  bool lunchNotification = false;
  bool dinnerNotification = false;
  TimeOfDay breakfastTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay lunchTime = TimeOfDay(hour: 12, minute: 0);
  TimeOfDay dinnerTime = TimeOfDay(hour: 18, minute: 0);

  Future<void> _selectTime(BuildContext context, String meal) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: meal == 'breakfast' ? breakfastTime
          : meal == 'lunch' ? lunchTime
          : dinnerTime,
    );
    if (picked != null) {
      setState(() {
        if (meal == 'breakfast') breakfastTime = picked;
        else if (meal == 'lunch') lunchTime = picked;
        else if (meal == 'dinner') dinnerTime = picked;
      });
      await saveSettings();
      _scheduleMealNotifications();
    }
  }


  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('breakfastNotification', breakfastNotification);
    await prefs.setBool('lunchNotification', lunchNotification);
    await prefs.setBool('dinnerNotification', dinnerNotification);
    await prefs.setInt('breakfastTime', breakfastTime.hour * 60 + breakfastTime.minute);
    await prefs.setInt('lunchTime', lunchTime.hour * 60 + lunchTime.minute);
    await prefs.setInt('dinnerTime', dinnerTime.hour * 60 + dinnerTime.minute);
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    breakfastNotification = prefs.getBool('breakfastNotification') ?? false;
    lunchNotification = prefs.getBool('lunchNotification') ?? false;
    dinnerNotification = prefs.getBool('dinnerNotification') ?? false;
    int breakfastMinutes = prefs.getInt('breakfastTime') ?? 480;
    breakfastTime = TimeOfDay(hour: breakfastMinutes ~/ 60, minute: breakfastMinutes % 60);
    int lunchMinutes = prefs.getInt('lunchTime') ?? 720;
    lunchTime = TimeOfDay(hour: lunchMinutes ~/ 60, minute: lunchMinutes % 60);
    int dinnerMinutes = prefs.getInt('dinnerTime') ?? 1080;
    dinnerTime = TimeOfDay(hour: dinnerMinutes ~/ 60, minute: dinnerMinutes % 60);
    setState(() {});
  }

  void _scheduleMealNotifications() {
    if (breakfastNotification) {
      DateTime breakfastDateTime = _getNextDateTime(breakfastTime);
      NotificationService.scheduleNotification(1, 'Breakfast', breakfastDateTime);
    } else {
      NotificationService.cancelNotification(1);
    }

    if (lunchNotification) {
      DateTime lunchDateTime = _getNextDateTime(lunchTime);
      NotificationService.scheduleNotification(2, 'Lunch', lunchDateTime);
    } else {
      NotificationService.cancelNotification(2);
    }

    if (dinnerNotification) {
      DateTime dinnerDateTime = _getNextDateTime(dinnerTime);
      NotificationService.scheduleNotification(3, 'Dinner', dinnerDateTime);
    } else {
      NotificationService.cancelNotification(3);
    }

  }

  DateTime _getNextDateTime(TimeOfDay time) {
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      // If the time is in the past for today, schedule it for the next day
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }
    return scheduledDate;
  }


  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meal Notification Settings"),
      ),
      body: Column(
        children: <Widget>[
          SwitchListTile(
            title: Text('Breakfast Notifications'),
            value: breakfastNotification,
            onChanged: (bool value) async{
              setState(() {
                breakfastNotification = value;
              });
              await saveSettings();
              _scheduleMealNotifications();
            },
          ),
          if (breakfastNotification)
            ListTile(
              title: Text('Set Breakfast Time'),
              subtitle: Text('${breakfastTime.format(context)}'),
              onTap: () {
                _selectTime(context, 'breakfast');
              },
            ),
          // Repeat for Lunch and Dinner
          SwitchListTile(
            title: Text('Lunch Notifications'),
            value: lunchNotification,
            onChanged: (bool value) {
              setState(() {
                lunchNotification = value;
              });
            },
          ),
          if (lunchNotification)
            ListTile(
              title: Text('Set Lunch Time'),
              subtitle: Text('${lunchTime.format(context)}'),
              onTap: () {
                _selectTime(context, 'lunch');
              },
            ),
            SwitchListTile(
              title: Text('Dinner Notifications'),
              value: dinnerNotification,
              onChanged: (bool value) {
                setState(() {
                  dinnerNotification = value;
                });
              },
            ),
            if (dinnerNotification)
              ListTile(
                title: Text('Set Dinner Time'),
                subtitle: Text('${dinnerTime.format(context)}'),
                onTap: () {
                  _selectTime(context, 'dinner');
                },
              ),
          // ElevatedButton(
          //   onPressed: () {
          //     NotificationService.testNotification();
          //   },
          //   style: ElevatedButton.styleFrom(
          //     primary: Colors.white, // Set the background color to transparent
          //     // onPrimary: Colors.black, // Set the text color to black
          //     // elevation: 5, // Customize the elevation (shadow)
          //     // shadowColor: Colors.grey.withOpacity(0.2), // Subtle shadow color
          //   ),
          //   child: Text(""),
          // ),
          Container(
            width: 200, // Set the width to make it larger
            height: 100, // Set the height to make it taller
            child: InkWell(
              onTap: () {
                NotificationService.testNotification();
              },
              highlightColor: Colors.transparent, // Set the highlight color to transparent
              splashColor: Colors.transparent, // Set t
              child: const Center(
                child: Text(
                  "", // Add your text here
                  style: TextStyle(
                    fontSize: 20, // Customize the text size
                  ),
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}
