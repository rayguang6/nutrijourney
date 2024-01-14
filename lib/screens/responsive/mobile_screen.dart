import 'package:flutter/material.dart';
import 'package:nutrijourney/screens/tracker_screen.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../../utils/constants.dart';
import '../community_screen.dart';
import '../dashboard_screen.dart';
import '../planner_screen.dart';
import '../recipe_screen.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({Key? key}) : super(key: key);

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const DashboardScreen(),
    TrackerScreen(),
    // PlannerScreen(),
    RecipeScreen(),
    CommunityScreen(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;


    return Scaffold(

      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _page,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: kPrimaryGreen,
        unselectedItemColor: kGrey,
        iconSize: 24,
        onTap: updatePage,
        items: [
          _buildBottomNavigationBarItem(0, Icons.dashboard, 'Dashboard'),
          _buildBottomNavigationBarItem(1, Icons.calendar_today, 'Tracker'),
          _buildBottomNavigationBarItem(2, Icons.restaurant_menu, 'Recipe'),
          _buildBottomNavigationBarItem(3, Icons.people, 'Community'),
        ],
      ),
    );
  }

  // reusable widget for Bottom Navbar Item
  BottomNavigationBarItem _buildBottomNavigationBarItem(
      int pageNumber, IconData icon, String label) {
    return BottomNavigationBarItem(
        icon: SizedBox(width: bottomBarWidth, child: Icon(icon)), label: label);
  }
}
