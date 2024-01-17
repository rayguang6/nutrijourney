import 'package:flutter/material.dart';
import 'package:nutrijourney/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../../services/onboarding_service.dart';
import '../responsive/mobile_screen.dart';

class OnboardingSuccessScreen extends StatefulWidget {
  const OnboardingSuccessScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingSuccessScreen> createState() => _OnboardingSuccessScreenState();
}

class _OnboardingSuccessScreenState extends State<OnboardingSuccessScreen> {


  @override
  Widget build(BuildContext context) {

    final UserModel? user = Provider.of<UserProvider>(context).getUser;

    num? weight = user?.weight;
    num? height = user?.height;
    num? age = user?.age;
    String? username = user?.username;
    String? activeLevel = user?.activeLevel;
    String? goal = user?.goal;

    num BMR = 0;
    num BMI = (weight)!/((height!/100)*(height/100));
    String BMI_Message = "";
    num suggestedCalories = 0;

    if(BMI < 18.5 ){
      BMI_Message = "Underweight";
    }
    else if(BMI >= 18.5 && BMI <=24.9 ){
      BMI_Message = "Normal Weight";
    }
    else if(BMI >=25 && BMI <=29.9 ){
      BMI_Message = "Overweight";
    }
    else if(BMI >=30){
      BMI_Message = "Obesity";
    }

    if (user?.gender == 'Male') {
      BMR = 66.5 + (13.75 * weight!) + (5.003 * height!) - (6.75 * age!);
    } else if (user?.gender == 'Female') {
      BMR = 655.1 + (9.563 * weight!) + (1.850 * height!) - (4.676 * age!);
    }

    //based on active level
    if(activeLevel == "Sedentary"){
      suggestedCalories = BMR*1.2;
    }
    if(activeLevel == "Lightly Active"){
      suggestedCalories = BMR * 1.375;
    }
    if(activeLevel == "Moderately Active"){
      suggestedCalories = BMR*1.55;
    }
    if(activeLevel == "Very Active"){
      suggestedCalories = BMR*1.725;
    }
    if(activeLevel == "Extra Active"){
      suggestedCalories = BMR*1.9;
    }

    if(goal == "Lose Weight"){
      suggestedCalories -= 550;
    }

    if(goal == "Gain Weight"){
      suggestedCalories += 550;
    }

    //save into database
    void _saveData() async {
      final OnboardingService _onboardingService = OnboardingService();

      await _onboardingService.saveUserData({'suggestedCalories': suggestedCalories.roundToDouble()});
      await _onboardingService.saveUserData({'BMR': BMR.roundToDouble()});
      await Provider.of<UserProvider>(context, listen: false).setUser();

      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => const MobileScreen()
          // builder: (context) => const ResponsiveScreen(
          //   mobileScreen: MobileScreen(),
          //   webScreen: WebScreen(),
          // ),
        ),
            (route) => false,
      );
    }


    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('👋 Hi $username', style: TextStyle(fontSize: 32, color: kPrimaryGreen, fontWeight: FontWeight.bold, ),textAlign: TextAlign.center,),
              Text('Welcome to NutriJourney!', style: TextStyle(fontSize: 24, color: kBlack, fontWeight: FontWeight.bold, ),textAlign: TextAlign.center,),
              SizedBox(height: 16,),
              CircleAvatar(
                backgroundImage: NetworkImage(user!.profileImage),
                radius: 75,
              ),
              SizedBox(height: 16,),


              _buildStatisticCard('Your Height', '$height cm'),
              _buildStatisticCard('Your Weight', '$weight kg'),
              _buildStatisticCard('Your Age', '$age'),
              _buildStatisticCard('Your BMR(basal metabolic rate)', '${BMR.roundToDouble()}'),
              _buildStatisticCard('Suggested Daily Calories Intake', '${(suggestedCalories).roundToDouble()}'),
              _buildStatisticCard('Your BMI', '${BMI.toStringAsFixed(2)} + ($BMI_Message)'),

              ElevatedButton(
                  onPressed: _saveData,
                  child: Text("🍽️Let's Start Your NutriJourney ➡️"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildStatisticCard(String title, String value) {
  return Container(
    child: Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(title, style: TextStyle(color: Colors.grey[600])),
        ],
      )
    ),
  );
}