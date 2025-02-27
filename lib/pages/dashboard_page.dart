import 'package:flutter/material.dart';
import '../widgets/side_menu.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      drawer: const SideMenu(),
      body: const Center(child: Text('Welcome to Admin Dashboard')),
    );
  }
}
