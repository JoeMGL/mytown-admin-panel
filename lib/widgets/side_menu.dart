import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_notifier.dart';

class SideMenu extends StatelessWidget {
  final AuthNotifier authNotifier;

  const SideMenu({super.key, required this.authNotifier});

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
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => context.go('/'),
          ),
          if (authNotifier.isAdmin || authNotifier.isManager) ...[
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('Businesses'),
              onTap: () => context.go('/businesses'),
            ),
          ],
           if (authNotifier.isAdmin || authNotifier.isManager) ...[
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('Announcements'),
              onTap: () => context.go('/announcements'),
            ),
          ],
          if (authNotifier.isAdmin) ...[
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Users'),
              onTap: () => context.go('/users'),
            ),
          ],
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Events'),
            onTap: () => context.go('/events'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              authNotifier.signOut();
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}
