import 'package:flutter/material.dart';
import 'package:nutrijourney/services/auth_service.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthService _authService = AuthService();

  UserModel? get getUser => _user;

  Future<void> setUser() async {
    try {
      UserModel user = await _authService.getUserDetails();
      _user = user;
      notifyListeners();
    } catch (e) {
      // Handle the error, possibly logging it or informing the user
      print('Error setting user: $e');
    }
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

}
