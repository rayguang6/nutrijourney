import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';

class PreferenceDetailScreen extends StatefulWidget {
  const PreferenceDetailScreen({super.key});

  @override
  State<PreferenceDetailScreen> createState() => PreferenceDetailScreenState();
}

class PreferenceDetailScreenState extends State<PreferenceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;



    return Scaffold(
      appBar: AppBar(
        title: const Text('Preference'),
        backgroundColor: kPrimaryGreen,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Text('Customize Preference'),
          Text(user!.preference.toString()),
        ]),
      ),
    );
  }
}
