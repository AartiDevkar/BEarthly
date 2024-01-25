import 'package:bearthly/carbonTrack/components/survey.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'components/indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  double calculatedPercent = 0.0;

  String userName = '';

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
          String fetchedUserName = userDoc.get('username') ?? 'Unknown';

          // Update the state with the fetched username
          setState(() {
            userName = fetchedUserName;
          });
        } else {
          // Handle the case when the document does not exist
          setState(() {
            userName = 'Unknown';
          });
        }
      }
    } catch (e) {
      print('Error fetching username: $e');
    }
  }

  // Function to open the survey form dialog
  void _openSurveyForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Survey Form'),
          // Add your survey form widget here
          content: Survey(
            onSurveyCompleted: (percent) {
              // Update the state with the calculated percent
              setState(() {
                calculatedPercent = percent;
              });
            },
            userId: FirebaseAuth.instance.currentUser?.uid ?? '',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Function to check if the survey has been filled by the user
  Future<bool> _hasFilledSurvey() async {
    try {
      // Get the current user ID from FirebaseAuth
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

      // Check if the user ID is not empty
      if (userId.isNotEmpty) {
        // Reference to the Firestore collection for user surveys
        CollectionReference userSurveysCollection =
            FirebaseFirestore.instance.collection('Survey');

        // Query to check if a document with the current user ID exists
        QuerySnapshot querySnapshot = await userSurveysCollection
            .where('userId', isEqualTo: userId)
            .get();

        // If a document exists, the survey is considered filled
        return querySnapshot.docs.isNotEmpty;
      }
    } catch (e) {
      print('Error checking survey status: $e');
    }

    // Default to false in case of errors
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Color.fromARGB(255, 163, 234, 245), // Make app bar transparent
        elevation: 6, // Remove app bar shadow
        title: Text(
          "Hello " + userName,
          style: TextStyle(
            fontSize: 18,
            color: const Color.fromARGB(255, 23, 21, 21),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: screenHeight,
            width: 450,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.2, 0.5, 0.8],
                colors: [
                  Color.fromARGB(255, 20, 137, 135),
                  Color.fromARGB(255, 113, 189, 173),
                  Color.fromARGB(255, 105, 192, 178),
                ],
              ),
            ),
            child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                  top: 70, left: 60, right: 60), // Adjust padding
              child: Indicator(
                percent: calculatedPercent,
                co2eKg: 0,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: _openSurveyForm,
              child: Text('Open Survey'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 191, 228, 228),
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.all(20),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
          // Navigate to the corresponding page when an icon is tapped
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/');
              break;
            case 1:
              Navigator.pushNamed(context, '/reduce');
              break;
            case 2:
              Navigator.pushNamed(context, '/recycle');
              break;
            case 3:
              Navigator.pushNamed(context, '/connect');
              break;
          }
        },
        selectedItemColor: const Color.fromARGB(255, 20, 137, 135),
        unselectedItemColor: const Color.fromARGB(255, 121, 154, 203),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_downward),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recycling),
            label: 'Reduce',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_rounded),
            label: 'Connect',
          ),
        ],
      ),
    );
  }
}
