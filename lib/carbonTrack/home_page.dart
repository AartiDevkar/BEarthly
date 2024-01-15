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
    return Scaffold(
      //drawer: MyDrawer(),
      body: Stack(
        children: [
          Container(
            height: 850,
            width: 450,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [
                  0.2,
                  0.5,
                  0.8,
                ],
                    colors: [
                  Color.fromARGB(255, 20, 137, 135),
                  Color.fromARGB(255, 113, 189, 173),
                  Color.fromARGB(255, 105, 192, 178),
                ])),
            child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(60),
              child: Indicator(
                percent: calculatedPercent,
                co2eKg: 0,
              ),
            ),
          ),

          // Add the round button above the indicator
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: _openSurveyForm,
              child: Text('Open Survey'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 191, 228, 228),

                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),

                padding: EdgeInsets.all(20), // Adjust padding as needed
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
