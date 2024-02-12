import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signOut() async {
    try {
      // Sign out from Firebase Authentication
      await _auth.signOut();

      // Sign out from Google Sign-In
      await _googleSignIn.signOut();
      // Navigate to the login or onboarding screen
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color.fromARGB(255, 191, 228, 228),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 191, 228, 228),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    // Placeholder for user profile picture
                    backgroundColor: Colors.grey[300],
                    child:
                        const Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Current User',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'user@example.com',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                // Action to view action history
              },
              child: const Row(
                children: [
                  Icon(Icons.history),
                  SizedBox(width: 8.0),
                  Text('Action History'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                // Action to edit profile
              },
              child: const Row(
                children: [
                  Icon(Icons.history),
                  SizedBox(width: 8.0),
                  Text('Edit Profile'),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            const Text(
              'General',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Action to manage notifications
              },
              child: const Row(
                children: [
                  Icon(Icons.history),
                  SizedBox(width: 8.0),
                  Text('Notifications'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                // Action to give feedback
              },
              child: const Row(
                children: [
                  Icon(Icons.feedback),
                  SizedBox(width: 8.0),
                  Text('Give Feedback'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                // Action to view privacy and security settings
              },
              child: const Row(
                children: [
                  Icon(Icons.lock_outline),
                  SizedBox(width: 8.0),
                  Text('Privacy and Security'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                // Action to view Terms of Service
              },
              child: const Row(
                children: [
                  Icon(Icons.library_books_outlined),
                  SizedBox(width: 8.0),
                  Text('Terms of service'),
                ],
              ),
            ),
            const SizedBox(height: 80),
            TextButton(
              onPressed: _signOut,
              child: const Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 8.0),
                  Text('Log Out'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
