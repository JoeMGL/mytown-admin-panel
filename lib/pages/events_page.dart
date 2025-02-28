import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_notifier.dart';
import '../widgets/side_menu.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final TextEditingController _titleController = TextEditingController();

  void _addEvent() {
    FirebaseFirestore.instance.collection('events').add({
      'title': _titleController.text,
      'timestamp': DateTime.now(),
    });
    _titleController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = AuthNotifier(); // ✅ Instantiate AuthNotifier
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Events')),
      drawer: SideMenu(authNotifier: authNotifier), // ✅ Add the Sidebar Menu
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Event Title'),
            ),
          ),
          ElevatedButton(onPressed: _addEvent, child: const Text('Add Event')),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('events').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                var events = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    var event = events[index];
                    return ListTile(
                      title: Text(event['title']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => event.reference.delete(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
