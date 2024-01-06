import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:nutrijourney/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DashboardScreen(),
      );
  }
}
