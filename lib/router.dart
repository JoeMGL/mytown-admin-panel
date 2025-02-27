import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pages/business_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/login_page.dart';
import 'pages/users_page.dart';
import 'pages/events_page.dart';
import 'services/auth_notifier.dart';

Future<bool> checkAdmin() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return false;

  DocumentSnapshot userDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();

  return userDoc.exists && userDoc['role'] == 'admin';
}

final GoRouter router = GoRouter(
  refreshListenable: AuthNotifier(),
  redirect: (context, state) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return '/login';
    }

    bool isAdmin = await checkAdmin();
    if (!isAdmin) {
      return '/login'; // 🔒 Redirect non-admin users
    }

    return null; // ✅ Allow admin access
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/businesses',
      builder: (context, state) => const BusinessPage(),
    ),
    GoRoute(
      path: '/users',
      builder: (context, state) => const UsersPage(),
    ),
    GoRoute(
      path: '/events',
      builder: (context, state) => const EventsPage(),
    ),
  ],
);
