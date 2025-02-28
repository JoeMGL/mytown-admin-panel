import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import '../services/auth_notifier.dart';
import '../widgets/side_menu.dart';

class BusinessPage extends StatefulWidget {
  const BusinessPage({super.key});

  @override
  _BusinessPageState createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool takeout = false;
  bool dineIn = false;
  List<String> imageUrls = [];

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      for (var file in pickedFiles) {
        await _uploadImage(File(file.path));
      }
    }
  }

  Future<void> _uploadImage(File file) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref().child("business_photos/$fileName.jpg");
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      imageUrls.add(downloadUrl);
    });
  }

  Future<void> _saveBusiness() async {
    await FirebaseFirestore.instance.collection('businesses').add({
      'name': _nameController.text,
      'category': _categoryController.text,
      'address': _addressController.text,
      'phone': _phoneController.text,
      'hours': _hoursController.text,
      'description': _descriptionController.text,
      'services': {
        'takeout': takeout,
        'dineIn': dineIn,
      },
      'photos': imageUrls,
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Business saved!')));
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = AuthNotifier();
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Business')),
      drawer: SideMenu(authNotifier: authNotifier),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Business Name")),
              TextField(controller: _categoryController, decoration: const InputDecoration(labelText: "Category")),
              TextField(controller: _addressController, decoration: const InputDecoration(labelText: "Address")),
              TextField(controller: _phoneController, decoration: const InputDecoration(labelText: "Phone Number")),
              TextField(controller: _hoursController, decoration: const InputDecoration(labelText: "Opening Hours")),
              TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: "Description")),
              
              const SizedBox(height: 16),
              const Text("Services"),
              CheckboxListTile(
                title: const Text("Takeout"),
                value: takeout,
                onChanged: (val) => setState(() => takeout = val!),
              ),
              CheckboxListTile(
                title: const Text("Dine-in"),
                value: dineIn,
                onChanged: (val) => setState(() => dineIn = val!),
              ),

              const SizedBox(height: 16),
              const Text("Photos"),
              Wrap(
                children: imageUrls.map((url) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.network(url, width: 100, height: 100),
                )).toList(),
              ),
              ElevatedButton(onPressed: _pickImages, child: const Text("Upload Photos")),

              const SizedBox(height: 16),
              ElevatedButton(onPressed: _saveBusiness, child: const Text("Save Business")),
            ],
          ),
        ),
      ),
    );
  }
}
