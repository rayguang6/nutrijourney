import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';

DateTime scheduleTime = DateTime.now();

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({
    super.key,
  });

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user!.profileImage),
              radius: 60,
            ),
            SizedBox(height: 16.0),
            Text(
              user!.username,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              user.email,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
