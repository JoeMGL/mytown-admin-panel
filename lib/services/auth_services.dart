import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 Get the currently logged-in user
  User? get user => _auth.currentUser;

  // 🔹 Sign in with email & password
  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 🔍 Check if user is an admin
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      bool isAdmin = userDoc.exists && userDoc['role'] == 'admin';

      if (!isAdmin) {
        await _auth.signOut();
        return "You are not an admin!";
      }

      return null; // ✅ Success
    } catch (e) {
      return e.toString(); // ❌ Error message
    }
  }

  // 🔹 Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
