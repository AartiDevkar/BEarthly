import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late TextEditingController _usernameController;
  late TextEditingController _emailController;

  late CollectionReference _userCollection;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();

    _userCollection = FirebaseFirestore.instance.collection('users');
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      // Get the current user ID from FirebaseAuth
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

      // Check if the user ID is not empty
      if (userId.isNotEmpty) {
        // Reference to the Firestore collection for user data
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('users')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          // Retrieve the username from the document

          // Update the state with the fetched username
          setState(() {
            _usernameController.text = userDoc.get('username') ?? 'Unknown';
            _emailController.text = userDoc.get('email') ?? 'Unknown';
          });
        } else {
          // Handle the case when the document does not exist
          setState(() {
            _usernameController.text = '';
            _emailController.text = '';
            // Load other user data like activity
          });
        }
      }
    } catch (e) {
      print('Error fetching username: $e');
    }
  }

  Future<void> _updateProfile() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(_usernameController.text);
        await _userCollection.doc(user.uid).set({
          'username': _usernameController.text,
          'email': _emailController.text,
          // Add other fields here like 'activity': _activityController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
          ),
        );
        // Close the EditProfilePage and navigate back to the SettingsPage
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          backgroundColor: const Color.fromARGB(255, 191, 228, 228),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your username',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _updateProfile,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ));
  }
}
