import 'package:flutter/material.dart';
import '../services/auth_notifier.dart';
import '../widgets/side_menu.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authNotifier = AuthNotifier(); // ✅ Instantiate AuthNotifier
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      drawer: SideMenu(authNotifier: authNotifier), // ✅ Add the Sidebar Menu
      body: const Center(child: Text('Welcome to Admin Dashboard')),
    );
  }
}
