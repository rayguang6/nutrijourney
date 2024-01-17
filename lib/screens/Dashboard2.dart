import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrijourney/utils/constants.dart';
import 'package:nutrijourney/utils/utils.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../widgets/NutritionBarChart.dart';
import '../widgets/NutritionDonutChart.dart';
import '../widgets/WeightChart.dart';

class Dashboard2 extends StatefulWidget {
  const Dashboard2({Key? key}) : super(key: key);

  @override
  State<Dashboard2> createState() => _Dashboard2State();
}

class _Dashboard2State extends State<Dashboard2> {
  DateTime _currentDate = DateTime.now();

  Future<List<FlSpot>>? weightDataFuture;

  @override
  void initState() {
    super.initState();
    final UserModel? user = Provider.of<UserProvider>(context, listen: false).getUser;
    if (user != null) {
      weightDataFuture = getWeightData(user.email); // Initialize the future
    }
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  Future<void> _selectWeek(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (selected != null) {
      setState(() {
        _currentDate = findFirstDateOfTheWeek(selected);
      });
    }
  }

  void goToPreviousWeek() {
    setState(() {
      _currentDate = findFirstDateOfTheWeek(_currentDate).subtract(const Duration(days: 7));
    });
  }

  void goToNextWeek() {
    setState(() {
      _currentDate = findFirstDateOfTheWeek(_currentDate).add(const Duration(days: 7));
    });
  }



  String formatWeekRange(DateTime startDate) {
    final endDate = findLastDateOfTheWeek(startDate);
    return '${DateFormat('MMM dd').format(startDate)} - ${DateFormat('dd').format(endDate)}';
  }

  //Add a function to convert dates to weekdays:
  String dayOfWeek(DateTime date) {
    return DateFormat('EEE').format(date);  // EEE gives a three-letter abbreviation of the weekday
  }

  Future<List<FlSpot>> getWeightData(String userEmail) async {
    List<FlSpot> weightData = [];
    var collection = FirebaseFirestore.instance.collection('users')
        .doc(userEmail).collection('weight');

    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data() as Map<String, dynamic>;
      double weight = data['weight'];
      Timestamp timestamp = data['date']; // Assuming the date is stored as a Timestamp
      DateTime date = timestamp.toDate();

      // Convert date to a value (e.g., number of days since a start date)
      double xValue = date.difference(DateTime(2024, 1, 1)).inDays.toDouble();
      weightData.add(FlSpot(xValue, weight));
    }

    return weightData;
  }


  @override
  Widget build(BuildContext context) {

    final UserModel? user = Provider.of<UserProvider>(context).getUser;

    Future<Map<String, DailyNutritionData>> fetchWeeklyNutritionData(String userEmail, DateTime startDate) async {
      Map<String, DailyNutritionData> weeklyData = {};

      for (int i = 0; i < 7; i++) {
        DateTime currentDate = startDate.add(Duration(days: i));
        String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
        String day = DateFormat('dd').format(currentDate);

        var dailyDataSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .collection('tracker')
            .doc(formattedDate)
            .collection(formattedDate)
            .get();

        DailyNutritionData dailyData = DailyNutritionData();


        if (dailyDataSnapshot.docs.isNotEmpty) {
          // Loop through each document
          for (var doc in dailyDataSnapshot.docs) {
            // Access the data fields for each meal
            var mealData = doc.data() as Map<String, dynamic>;

            // Update the total calories for the corresponding meal type
            dailyData.totalCalories += (mealData['calories'] as num?)?.toDouble() ?? 0;
            dailyData.totalCarbs += (mealData['carbohydrates'] as num?)?.toDouble() ?? 0;
            dailyData.totalProteins += (mealData['proteins'] as num?)?.toDouble() ?? 0;
            dailyData.totalFats += (mealData['fats'] as num?)?.toDouble() ?? 0;

          }

        } else {
          // No meal records found for the selected date
          // print('No meal records found for $formattedDate');
        }
        // weeklyData[formattedDate] = dailyData;
        weeklyData[day] = dailyData;
        // print(weeklyData.keys);
      }

      return weeklyData;
    }

    Future<List<FlSpot>> fetchWeeklyWeightData(String userEmail, DateTime startDate) async {
      List<FlSpot> weightDataSpots = [];
      double lastKnownWeight = 0; // Initialize with a default weight or the most recent known weight

      for (int i = 0; i < 7; i++) {
        DateTime currentDate = startDate.add(Duration(days: i));
        String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

        var dailyDataSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .collection('weight')
            .doc(formattedDate)
            .get();

        if (dailyDataSnapshot.exists) {
          var data = dailyDataSnapshot.data() as Map<String, dynamic>;
          lastKnownWeight = data['weight'] ?? lastKnownWeight; // Update last known weight
        }

        // Use the last known weight for this day
        weightDataSpots.add(FlSpot(i.toDouble(), lastKnownWeight));
      }

      return weightDataSpots;
    }


    return Scaffold(
      appBar: AppBar(
        title: Text("${user?.username}'s Dashboard"),
        backgroundColor: kPrimaryGreen,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: goToPreviousWeek,
                  ),
                  GestureDetector(
                    onTap: () => _selectWeek(context),
                    child: Text(
                      formatWeekRange(_currentDate),
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: goToNextWeek,
                  ),
                ],
              ),
              // ... rest of your UI
              // Inside your Dashboard2 build method

              Text("Weekly Calories Intake"),
              FutureBuilder<Map<String, DailyNutritionData>>(
                future: fetchWeeklyNutritionData(user!.email, _currentDate),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  if (!snapshot.hasData) {
                    return Text("No data available.");
                  }

                  return SizedBox(
                    height: 300,
                    child: NutritionBarChart(weeklyData: snapshot.data!));
                },
              ),

            //  DONUT CHART
              SizedBox(height:32),
              Text("Macronutrient Balance"),
              FutureBuilder<Map<String, DailyNutritionData>>(
                future: fetchWeeklyNutritionData(user!.email, _currentDate),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text("No data available.");
                  }

                  DailyNutritionData weeklyTotal = DailyNutritionData();
                  snapshot.data!.values.forEach((dailyData) {
                    weeklyTotal.totalCalories += dailyData.totalCalories;
                    weeklyTotal.totalCarbs += dailyData.totalCarbs;
                    weeklyTotal.totalProteins += dailyData.totalProteins;
                    weeklyTotal.totalFats += dailyData.totalFats;
                  });

                  return SizedBox(
                    height: 300,
                    child: NutrientDonutChart(nutritionData: weeklyTotal),
                  );
                },
              ),


              SizedBox(height: 50,),
              FutureBuilder<List<FlSpot>>(
                future: fetchWeeklyWeightData(user.email, _currentDate), // Correctly assign the future
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text("No weight data available.");
                  }

                  // Use the data to create the chart
                  return SizedBox(
                    height: 300,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                            show: true,

                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: SideTitles(
                            showTitles: true,
                            getTitles: (value) {
                              // Convert index to date string
                              DateTime date = _currentDate.add(Duration(days: value.toInt()));
                              return DateFormat('dd').format(date); // Example: Mon, Tue, etc.
                            },
                          ),
                          leftTitles: SideTitles(showTitles: true),
                        ),
                        borderData: FlBorderData(
                            show: true,
                          border: Border.all(
                            // color: kPrimaryGreen,
                            width: 1,
                          )
                        ),
                        minX: 0,
                        maxX: 6, // 7 days in a week
                        minY: snapshot.data!.map((spot) => spot.y).reduce(min)-1,
                        maxY: snapshot.data!.map((spot) => spot.y).reduce(max)+1, // Find the maximum weight value
                        lineBarsData: [
                          LineChartBarData(
                            spots: snapshot.data!,
                            isCurved: true,
                            colors: [kGradientFirstGreen, kGradientSecondGreen],
                            barWidth: 3,
                            // isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                                show: true,
                              colors: [
                                kGradientFirstGreen.withOpacity(0.3),
                                kGradientSecondGreen.withOpacity(0.3)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}


class DailyNutritionData {
  num totalCalories;
  num totalCarbs;
  num totalProteins;
  num totalFats;

  DailyNutritionData({
    this.totalCalories = 0,
    this.totalCarbs = 0,
    this.totalProteins = 0,
    this.totalFats = 0,
  });
}

class DailyWeightData {
  num totalweight;

  DailyWeightData({
    this.totalweight = 0,
  });
}