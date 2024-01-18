
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../utils/constants.dart';

class ResponsiveWrapper extends StatefulWidget {
  final Widget mobileScreen;
  final Widget webScreen;
  const ResponsiveWrapper({
    Key? key,
    required this.mobileScreen,
    required this.webScreen,
  }) : super(key: key);

  @override
  State<ResponsiveWrapper> createState() => _ResponsiveWrapperState();
}

class _ResponsiveWrapperState extends State<ResponsiveWrapper> {
  @override
  void initState() {
    // setUserData();
    super.initState();

    setState(() {
      setUserData();
    });
  }

  setUserData() async {
    UserProvider _userProvider =
    Provider.of<UserProvider>(context, listen: false);
    await _userProvider.setUser();
    // Wait for the user data to be initialized
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > kWebScreenSize) {
        // 600 can be changed to 900 if you want to display tablet screen with mobile screen layout

        return widget.webScreen;
      }
      return widget.mobileScreen;
    });
  }
}
