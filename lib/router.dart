import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages/business_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/login_page.dart';
import 'pages/users_page.dart';
import 'pages/events_page.dart';
import 'services/auth_notifier.dart';

final AuthNotifier authNotifier = AuthNotifier();

final GoRouter router = GoRouter(
  refreshListenable: authNotifier,
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return '/login';

    String currentRoute = state.uri.toString(); // ✅ Fix for GoRouter v14+

    if (currentRoute == '/users' && !authNotifier.isAdmin) {
      return '/'; // 🔒 Only admins can access user management
    }

    if (currentRoute == '/businesses' && !(authNotifier.isAdmin || authNotifier.isManager)) {
      return '/'; // 🔒 Only admins and managers can manage businesses
    }

    return null; // ✅ Allow navigation
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const DashboardPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/businesses', builder: (context, state) => const BusinessPage()),
    GoRoute(path: '/users', builder: (context, state) => const UsersPage()),
    GoRoute(path: '/events', builder: (context, state) => const EventsPage()),
  ],
);
