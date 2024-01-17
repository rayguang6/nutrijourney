
import 'package:flutter/material.dart';
import 'package:nutrijourney/screens/helper_screens/goal_page.dart';
import 'package:nutrijourney/screens/helper_screens/track_weight.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import 'notification_settings.dart';
import 'preference_detail.dart';
import 'profile_detail.dart';
import 'signin_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: kPrimaryGreen,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ProfileCard(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Preferences',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            PreferenceList(),
          ],
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                user!.profileImage,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PreferenceList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        PreferenceItem(
          icon: Icons.account_circle,
          title: 'Profile Information',
          subtitle: 'Change your perfonal details',
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => ProfileDetailScreen(),
                ));
          },
        ),
        PreferenceItem(
          icon: Icons.restaurant,
          title: 'Preferences',
          subtitle: 'Change your preferences, allergies',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => PreferenceDetailScreen()),
            );
          },
        ),
        PreferenceItem(
          icon: Icons.accessibility_new_rounded,
          title: 'Goal',
          subtitle: 'Change your Goal',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => GoalPage()),
            );
          },
        ),
        PreferenceItem(
          icon: Icons.notifications,
          title: 'Notifications',
          subtitle: 'Customize notification settings',
          onTap: () {
            Navigator.push(
              context,
            MaterialPageRoute(builder: (c) => NotificationSettingsScreen()),
            );
            // Handle notifications preference tap
            // showSnackBar(context, ' "Notification" Well Be Developed Later');
          },
        ),
        PreferenceItem(
          icon: Icons.monitor_weight_outlined ,
          title: 'Weight Tracking',
          subtitle: 'Track and Monitor Your Weight',
          onTap: () {
            Navigator.push(
              context,
            MaterialPageRoute(builder: (c) => TrackWeightScreen()),
            );
            // Handle notifications preference tap
            // showSnackBar(context, ' "Notification" Well Be Developed Later');
          },
        ),
        PreferenceItem(
          icon: Icons.settings,
          title: 'Settings',
          subtitle: 'Configure your app settings',
          onTap: () {
            // Handle notifications preference tap
          },
        ),
        InkWell(
          onTap: () {
            AuthService().signOut().then((value) async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => SignInScreen()),
              );
            });
          },
          child: const ListTile(
            leading: Icon(
              Icons.login_outlined,
              color: Colors.red,
            ),
            title: Text(
              'Log Out',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ],
    );
  }
}

class PreferenceItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const PreferenceItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
