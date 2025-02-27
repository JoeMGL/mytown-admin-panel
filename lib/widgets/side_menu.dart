import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Admin Panel', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            title: const Text('Dashboard'),
            onTap: () => context.go('/'),
          ),
          ListTile(
            title: const Text('Businesses'),
            onTap: () => context.go('/businesses'),
          ),
          ListTile(
            title: const Text('Users'),
            onTap: () => context.go('/users'),
          ),
          ListTile(
            title: const Text('Events'),
            onTap: () => context.go('/events'),
          ),
        ],
      ),
    );
  }
}
