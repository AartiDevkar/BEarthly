import 'package:bearthly/connect_pages/pages/SettingsPages/feedback.dart';
import 'package:bearthly/connect_pages/pages/SettingsPages/notifications_settings.dart';
import 'package:bearthly/connect_pages/pages/SettingsPages/privacy_security.dart';
import 'package:bearthly/connect_pages/pages/SettingsPages/terms_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:bearthly/connect_pages/pages/SettingsPages/edit_profile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();

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

        // Check if the document exists before accessing its fields
        if (userDoc.exists) {
          // Retrieve the username from the document
          String fetchedEmail = userDoc.get('email') ?? 'Unknown';
          String fetchedName = userDoc.get('username') ?? 'Unknown';
          // Update the state with the fetched username
          setState(() {
            userEmail = fetchedEmail;
            userName = fetchedName;
          });
        } else {
          // Handle the case when the document does not exist
          setState(() {
            userEmail = 'Unkown';
            userName = 'Unknown';
          });
        }
      }
    } catch (e) {
      print('Error fetching username: $e');
    }
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
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
                    backgroundColor: Colors.grey[300],
                    child:
                        const Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Display the updated email fetched from Firebase Authentication
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            // TextButton(
            //   onPressed: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => ActionHistory()));
            //   },
            //   child: const Row(
            //     children: [
            //       Icon(Icons.history),
            //       SizedBox(width: 8.0),
            //       Text('Action History'),
            //     ],
            //   ),
            // ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                ).then((_) {
                  // Refresh data on return from EditProfilePage
                  _fetchUserName();
                });
              },
              child: const Row(
                children: [
                  Icon(Icons.edit),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const NotificationSettingsPage()));
              },
              child: const Row(
                children: [
                  Icon(Icons.notifications_none),
                  SizedBox(width: 8.0),
                  Text('Notifications'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FeedbackPage()));
              },
              child: const Row(
                children: [
                  Icon(Icons.feedback_outlined),
                  SizedBox(width: 8.0),
                  Text('Give Feedback'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivacySecurityPage()));
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TermsServicePage()));
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
