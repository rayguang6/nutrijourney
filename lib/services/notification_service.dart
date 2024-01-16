import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize() {
    tz.initializeTimeZones(); // Initialize timezone data
    final String timeZoneName = 'Asia/Kuala_Lumpur'; // Set default timezone
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> scheduleNotification(int id, String title, DateTime scheduledTime) async {

    var androidDetails = AndroidNotificationDetails(
      'meal_id_$id',
      'Meal Reminder',
      channelDescription: 'Channel for Meal Reminder Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      'It\'s time for your $title!',
      tz.TZDateTime.from(scheduledTime, tz.local), // Adjust this to avoid exact alarm
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }


  static void testNotification() async {
    var androidDetails = const AndroidNotificationDetails(
        'channelId',
        'channelName',
        channelDescription: 'description',
        importance: Importance.max
    );
    var generalNotificationDetails = NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(
      0,
      'Nutrijourney Time ',
      'Remember to Track your Meal!',
      generalNotificationDetails,
    );
  }

}
