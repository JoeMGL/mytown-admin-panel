import 'package:flutter/material.dart';
import '../widgets/side_menu.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Users')),
      drawer: const SideMenu(),
      body: Center(child: Text('User Management Page')),
    );
  }
}
