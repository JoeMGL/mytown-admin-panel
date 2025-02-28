import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_notifier.dart';
import '../widgets/side_menu.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authNotifier = AuthNotifier();
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Users")),
      drawer: SideMenu(authNotifier: authNotifier),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          var users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return Card(
                child: ListTile(
                  title: Text(user['name']),
                  subtitle: Text(user['email']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _editUser(context, user);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteUser(user.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _editUser(BuildContext context, DocumentSnapshot user) {
  TextEditingController nameController = TextEditingController(text: user['name']);
  TextEditingController emailController = TextEditingController(text: user['email']);
  String selectedRole = user['role'] ?? 'user';

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Edit User"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            DropdownButtonFormField(
              value: selectedRole,
              items: ['admin', 'manager', 'user'].map((role) {
                return DropdownMenuItem(value: role, child: Text(role.toUpperCase()));
              }).toList(),
              onChanged: (value) {
                selectedRole = value as String;
              },
              decoration: const InputDecoration(labelText: "Role"),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              user.reference.update({
                'name': nameController.text,
                'email': emailController.text,
                'role': selectedRole,
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      );
    },
  );
}


  void _updateUser(String userId, String name, String role) {
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'name': name,
      'role': role,
    });
  }

  void _deleteUser(String userId) {
    FirebaseFirestore.instance.collection('users').doc(userId).delete();
  }
}
