import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthNotifier extends ChangeNotifier {
  bool _isAdmin = false;
  bool _isManager = false;

  bool get isAdmin => _isAdmin;
  bool get isManager => _isManager;

  AuthNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        _isAdmin = false;
        _isManager = false;
      } else {
        await _checkUserRole(user.uid);
      }
      notifyListeners();
    });
  }

  Future<void> _checkUserRole(String uid) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      _isAdmin = userDoc['role'] == 'admin';
      _isManager = userDoc['role'] == 'manager';
    }
  }

  void signOut() {
    // Add your sign-out logic here
  }
}


