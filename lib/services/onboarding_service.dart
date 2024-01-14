import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OnboardingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users')
          .doc(user.email).set(userData, SetOptions(merge: true));
    }
  }
}
