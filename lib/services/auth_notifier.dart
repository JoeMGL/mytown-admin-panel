import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      notifyListeners(); // 🔹 Notify GoRouter when auth state changes
    });
  }
}
