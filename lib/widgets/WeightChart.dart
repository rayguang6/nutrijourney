// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class WeightChart extends StatelessWidget {
//   final List<FlSpot> weightData;
//   final DateTime startDate; // Add startDate as a parameter to the constructor
//
//   WeightChart({Key? key, required this.weightData, required this.startDate}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // Function to format the date from a FlSpot
//     String getFormattedDate(double xValue) {
//       DateTime date = startDate.add(Duration(days: xValue.toInt()));
//       return DateFormat('MMM d').format(date);
//     }
//
//     return LineChart(
//       LineChartData(
//         // ... other chart settings ...
//         titlesData: FlTitlesData(
//           // Customize bottom titles (X-axis)
//           bottomTitles: SideTitles(
//             showTitles: true,
//             getTextStyles: (context, value) => const TextStyle(
//               color: Color(0xff68737d),
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//             getTitles: (value) {
//               // Use the function to get formatted date
//               return getFormattedDate(value);
//             },
//             margin: 12,
//           ),
//           // Customize left titles (Y-axis)
//           leftTitles: SideTitles(
//             showTitles: true,
//             getTextStyles: (context, value) => const TextStyle(
//               color: Color(0xff67727d),
//               fontWeight: FontWeight.bold,
//               fontSize: 15,
//             ),
//             getTitles: (value) {
//               return '${value.toInt()} kg';
//             },
//             reservedSize: 40,
//             margin: 8,
//           ),
//         ),
//         lineTouchData: LineTouchData(
//           touchTooltipData: LineTouchTooltipData(
//             tooltipBgColor: Colors.black,
//             getTooltipItems: (touchedSpots) {
//               return touchedSpots.map((touchedSpot) {
//                 return LineTooltipItem(
//                   '${getFormattedDate(touchedSpot.x)}\n${touchedSpot.y.toStringAsFixed(1)} kg',
//                   const TextStyle(color: Colors.white),
//                 );
//               }).toList();
//             },
//           ),
//           handleBuiltInTouches: true,
//         ),
//         // ... other chart settings ...
//       ),
//     );
//   }
// }
