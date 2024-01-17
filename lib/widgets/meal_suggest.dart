import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutrijourney/widgets/recipe_card.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';

class MealSuggest extends StatefulWidget {
  final mealType;
  final selectedDate;
  const MealSuggest({Key? key, required this.mealType, required this.selectedDate}) : super(key: key);

  @override
  State<MealSuggest> createState() => _MealSuggestState();
}

class _MealSuggestState extends State<MealSuggest> {

  Future<Map<String, num>> getTrackingDetail(String userEmail, mealType) async {
    final AuthService _authService = AuthService();
    UserModel user = await _authService.getUserDetails();

    //All User Details
    num? suggestedCalories = user?.suggestedCalories?.roundToDouble();
    num breakfastTargetCalories = suggestedCalories! * 0.25;
    num lunchTargetCalories = suggestedCalories! * 0.40;
    num dinnerTargetCalories = suggestedCalories! * 0.35;

    //initialize variables
    num BreakfastCal = 0;
    num LunchCal = 0;
    num DinnerCal = 0;

    num BreakfastCarbs = 0;
    num LunchCarbs = 0;
    num DinnerCarbs = 0;

    num BreakfastProteins = 0;
    num LunchProteins = 0;
    num DinnerProteins = 0;

    num BreakfastFats = 0;
    num LunchFats = 0;
    num DinnerFats = 0;

    print("suggestedCal: ${suggestedCalories.roundToDouble()}");
    print("breakfastTargetCalories: ${breakfastTargetCalories.roundToDouble()}");
    print("lunchTargetCalories: ${lunchTargetCalories.roundToDouble()}");
    print("dinnerTargetCalories: ${dinnerTargetCalories.roundToDouble()}");

    try {
      // Get all tracker records for the selectedDate
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail) // Replace with the user's document ID
          .collection('tracker')
          .doc(widget.selectedDate) // Use widget.selectedDate
          .collection(widget.selectedDate) // Use widget.selectedDate
          .get(); // Use .get() to fetch the documents



      // Check if any documents exist
      if (querySnapshot.docs.isNotEmpty) {
        // Loop through each document
        for (final doc in querySnapshot.docs) {
          // Access the data fields for each meal
          final mealData = doc.data() as Map<String, dynamic>;

          // Now you can access individual fields
          final String mealName = mealData['mealName'];
          final num calories = mealData['calories'];
          final num carbohydrates = mealData['carbohydrates'];
          final num fats = mealData['fats'];
          final num proteins = mealData['proteins'];
          final String imageUrl = mealData['imageUrl'];
          final String mealType=mealData['mealType'];

          // Update the total calories for the corresponding meal type
          if (mealType == 'Breakfast') {
            BreakfastCal += calories.toDouble();
            BreakfastCarbs += calories.toDouble();
            BreakfastProteins += proteins.toDouble();
            BreakfastFats += fats.toDouble();
          } else if (mealType == 'Lunch') {
            LunchCal += calories.toDouble();
            LunchCarbs += calories.toDouble();
            LunchProteins += proteins.toDouble();
            LunchFats += fats.toDouble();
          } else if (mealType == 'Dinner') {
            DinnerCal += calories.toDouble();
            DinnerCarbs += calories.toDouble();
            DinnerProteins += proteins.toDouble();
            DinnerFats += fats.toDouble();
          }
        }

        print("Breakfast Cal: $BreakfastCal");
        print("Lunch Cal: $LunchCal");
        print("Dinner Cal: $DinnerCal");

      } else {
        // No meal records found for the selected date
        print('No meal records found for ${widget.selectedDate}');
      }
    } catch (error) {
      print('Error fetching tracker records: $error');
    }

    num BreakfastAvailableCal = breakfastTargetCalories - BreakfastCal;
    num LunchAvailableCal = lunchTargetCalories - LunchCal;
    num DinnerAvailableCal = dinnerTargetCalories - DinnerCal;

    print("BreakfastAvailableCal: ${BreakfastAvailableCal.roundToDouble()}");
    print("LunchAvailableCal: ${LunchAvailableCal.roundToDouble()}");
    print("DinnerAvailableCal: ${DinnerAvailableCal.roundToDouble()}");

    return {
      "BreakfastAvailableCal" : BreakfastAvailableCal.roundToDouble(),
      "LunchAvailableCal": LunchAvailableCal.roundToDouble(),
      "DinnerAvailableCal": DinnerAvailableCal.roundToDouble(),
    };

  }//method ends



  @override
  Widget build(BuildContext context) {
    //user
    final UserModel? user = Provider
        .of<UserProvider>(context)
        .getUser;

    String? userEmail = user?.email;
    // Get the available calories map
    Future<Map<String, num>> availableCaloriesMap = getTrackingDetail(
        userEmail!, widget.mealType);

    // Use FutureBuilder to wait for availableCaloriesMap
    return FutureBuilder<Map<String, num>>(
        future: availableCaloriesMap,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data available"));
          }

          // Extract the available calories for the specific meal type
          num availableCalories = snapshot.data!['${widget
              .mealType}AvailableCal'] ??
              0;


          // Replace '${widget.mealType}AvailableCal' with the correct key

          return
            Column(
              children:[
                Text("You have $availableCalories for your ${widget.mealType}"),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection('recipes').where(
          'calories', isLessThan: availableCalories).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text("No recipes found within your calorie limit"));
                      }

                      var recipes = snapshot.data!.docs.map((doc) => doc.data()).toList();

                      // Calculate score and sort recipes
                      recipes.sort((a, b) {
                        double scoreA = (a['carbohydrates'] + a['proteins'] + a['fats']) / a['calories'];
                        double scoreB = (b['carbohydrates'] + b['proteins'] + b['fats']) / b['calories'];
                        return scoreA.compareTo(scoreB); // Sorting in descending order
                      });

                      return ListView.builder(
                        itemCount: recipes.length,
                        itemBuilder: (ctx, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: RecipeCard(
                            recipe: recipes[index],
                            onTap: () {
                              // Handle recipe tap here
                            },
                          ),
                        ),
                      );
                    },

                  ),
                ),
              ]
            );

  });

  }}