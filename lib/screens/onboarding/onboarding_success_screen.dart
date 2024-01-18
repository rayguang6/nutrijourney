import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:nutrijourney/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../../services/onboarding_service.dart';
import '../responsive/mobile_screen.dart';
import '../responsive/responsive_wrapper.dart';
import '../responsive/web_screen.dart';

class OnboardingSuccessScreen extends StatefulWidget {
  const OnboardingSuccessScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingSuccessScreen> createState() => _OnboardingSuccessScreenState();
}

class _OnboardingSuccessScreenState extends State<OnboardingSuccessScreen> {
  ConfettiController _confettiController = ConfettiController();
  late ConfettiController _controllerCenter;

  @override
  void initState() {
     _confettiController = ConfettiController(duration: Duration(milliseconds: 800));
    // _confettiController = ConfettiController();
    // _controllerCenter =ConfettiController(duration: const Duration(seconds: 2));
    // _controllerCenter.play();
    _confettiController.play();

    super.initState();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    _confettiController.dispose();
    super.dispose();
  }

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
          builder: (context) => const ResponsiveWrapper(
            mobileScreen: MobileScreen(),
            webScreen: WebScreen(),
          ),
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
              Align(
                alignment: Alignment.center,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: -pi / 2,
                  emissionFrequency: 0.2,
                  numberOfParticles: 20,
                  blastDirectionality: BlastDirectionality.explosive,
                ),
              ),

              Text('👋 Hi $username', style: TextStyle(fontSize: 32, color: kPrimaryGreen, fontWeight: FontWeight.bold, ),textAlign: TextAlign.center,),
              Text('Welcome to NutriJourney!', style: TextStyle(fontSize: 24, color: kDarkGreen, fontWeight: FontWeight.bold, ),textAlign: TextAlign.center,),
              SizedBox(height: 16,),
              CircleAvatar(
                backgroundImage: NetworkImage(user!.profileImage),
                radius: 50,
              ),
              SizedBox(height: 16,),

              _buildStatisticCard('Your Height', '$height cm'),
              _buildStatisticCard('Your Weight', '$weight kg'),
              _buildStatisticCard('Your Age', '$age'),
              _buildStatisticCard('Your BMR(basal metabolic rate)', '${BMR.roundToDouble()}'),
              _buildStatisticCard('Suggested Daily Calories Intake', '${(suggestedCalories).roundToDouble()}'),
              _buildStatisticCard('Your BMI', '${BMI.toStringAsFixed(2)} + ($BMI_Message)'),

              // ElevatedButton(
              //     onPressed: _saveData,
              //     child: Text("🍽️Let's Start Your NutriJourney ➡️"),
              // ),

              InkWell(
                onTap: _saveData,
                child: Container(
                    width: 300,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: kPrimaryGreen,
                    ),
                    child: const Text(
                      "🍽️Let's Start Your NutriJourney ➡️",
                      style: TextStyle(color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
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

    width: 300,
    child: Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(color: Colors.grey[600])),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ),
  );
}