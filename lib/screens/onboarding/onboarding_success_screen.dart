import 'package:flutter/material.dart';
import 'package:nutrijourney/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/user_provider.dart';
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

    num BMR = 0;

    if (user?.gender == 'Male') {
      BMR = 66.5 + (13.75 * weight!) + (5.003 * height!) - (6.75 * age!);
    } else if (user?.gender == 'Female') {
      BMR = 655.1 + (9.563 * weight!) + (1.850 * height!) - (4.676 * age!);
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
              _buildStatisticCard('Suggested Daily Calories Intake', '${(BMR * 1.55).roundToDouble()}'),

              ElevatedButton(onPressed: (){
                Navigator.pop(context);

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const MobileScreen()
                  ),
                      (route) => false,
                );
              }, child: Text("🍽️Let's Start Your NutriJourney ➡️"))

            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildStatisticCard(String title, String value) {
  return Card(
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    child: ListTile(
      title: Text(title, style: TextStyle(color: Colors.grey[600])),
      trailing: Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    ),
  );
}