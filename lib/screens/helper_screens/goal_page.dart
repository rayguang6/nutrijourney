import 'package:flutter/material.dart';
import 'package:nutrijourney/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../../services/onboarding_service.dart';

class GoalPage extends StatefulWidget {
  const GoalPage({Key? key}) : super(key: key);

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {

  String _currentSelected = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final UserModel? user = Provider.of<UserProvider>(context, listen: false).getUser;
    _currentSelected = user!.goal!;
  }

  @override
  Widget build(BuildContext context) {

    final UserModel? user = Provider.of<UserProvider>(context).getUser;

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Your Goal"),
            bottom: const TabBar(
                tabs: [
                  Tab(text: "General Goal",),
                  Tab(text: "Actual Goal",),
                ]
            ),
          ),
          body: TabBarView(children:
            [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Current Goal: ${user?.goal}', style: TextStyle(fontSize: 20)),
                    SizedBox(height: 20),
                    InkWell(
                      onTap:() {
                        setState(() {
                          _currentSelected = "Lose Weight";
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        alignment: Alignment.center,
                        width: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.5,
                              color: _currentSelected=="Lose Weight"
                                  ?  Colors.greenAccent
                                  : Colors.grey
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: Text("Lose Weight"),
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap:() {
                        setState(() {
                          _currentSelected = "Maintain Weight";
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        width: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.5,
                              color: _currentSelected=="Maintain Weight"
                                  ?  Colors.greenAccent
                                  : Colors.grey
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: Text("Maintain Weight"),
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap:() {
                        setState(() {
                          _currentSelected = "Gain Weight";
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        width: 200,
                        alignment: Alignment.center,

                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.5,
                              color: _currentSelected=="Gain Weight"
                                  ?  Colors.greenAccent
                                  : Colors.grey
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: Text("Gain Weight"),
                      ),
                    ),

                    ElevatedButton(
                        onPressed: (){
                          saveUserDetail();
                        },
                        child: Text("Save"))
                  ],
                ),
              ),

              Text("Page2"),
            ]
          ),
        )
        ,
      );
  }

  void saveUserDetail() async{
    final OnboardingService _onboardingService = OnboardingService();

    await _onboardingService.saveUserData({'goal': _currentSelected});
    await Provider.of<UserProvider>(context, listen: false).setUser();

    //recalculate the calories

  }
}
