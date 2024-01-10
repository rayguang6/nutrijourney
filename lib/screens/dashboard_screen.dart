import 'package:flutter/material.dart';
import 'package:nutrijourney/screens/signin_screen.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Home Screen of ${user?.username} "),
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                user?.profileImage ?? 'assets/images/default-profile.png',
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  // Sign out from Firebase Auth
                  await AuthService().signOut();

                  // Clear user data from UserProvider
                  Provider.of<UserProvider>(context, listen: false).clearUser();

                  // Navigate to the sign-in screen
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
                },
                child: Text('logout'))
          ],
        ),
      ),
    );
  }
}
