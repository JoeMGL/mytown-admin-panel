import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Announcements")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addAnnouncement(context),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('announcements').orderBy('date', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          var announcements = snapshot.data!.docs;
          return ListView.builder(
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              var announcement = announcements[index];
              return Card(
                child: ListTile(
                  title: Text(announcement['title']),
                  subtitle: Text(announcement['subtitle']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editAnnouncement(context, announcement),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          announcement.reference.delete();
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

  void _addAnnouncement(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController subtitleController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Announcement"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: "Title")),
              TextField(controller: subtitleController, decoration: const InputDecoration(labelText: "Subtitle")),
              const SizedBox(height: 10),
              Text("Date: ${selectedDate.toLocal()}".split(' ')[0]),
              ElevatedButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    selectedDate = picked;
                  }
                },
                child: const Text("Pick Date"),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('announcements').add({
                  'title': titleController.text,
                  'subtitle': subtitleController.text,
                  'date': Timestamp.fromDate(selectedDate),
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

  void _editAnnouncement(BuildContext context, DocumentSnapshot announcement) {
    TextEditingController titleController = TextEditingController(text: announcement['title']);
    TextEditingController subtitleController = TextEditingController(text: announcement['subtitle']);
    DateTime selectedDate = (announcement['date'] as Timestamp).toDate();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Announcement"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: "Title")),
              TextField(controller: subtitleController, decoration: const InputDecoration(labelText: "Subtitle")),
              const SizedBox(height: 10),
              Text("Date: ${selectedDate.toLocal()}".split(' ')[0]),
              ElevatedButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    selectedDate = picked;
                  }
                },
                child: const Text("Pick Date"),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                announcement.reference.update({
                  'title': titleController.text,
                  'subtitle': subtitleController.text,
                  'date': Timestamp.fromDate(selectedDate),
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
}
