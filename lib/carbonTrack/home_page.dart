//import 'package:bearthly/carbonTrack/components/cloud_animation.dart';
import 'package:bearthly/carbonTrack/components/survey.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int currentIndex = 0;
  double calculatedPercent = 0.0;

  String userName = '';

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _loadCalculatedPercent();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    // Define the animation curve
    final CurvedAnimation curve =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    // Define the opacity animation
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(curve);

    // Start the animation
    _animationController.forward();
  }

  Future<void> _loadCalculatedPercent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? storedPercent = prefs.getDouble('calculatedPercent');
    if (storedPercent != null) {
      setState(() {
        calculatedPercent = storedPercent;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserName() async {
    try {
      // Get the current user from FirebaseAuth
      User? user = FirebaseAuth.instance.currentUser;

      // Check if the user is not null and signed in with Google
      if (user != null &&
          user.providerData
              .any((userInfo) => userInfo.providerId == 'google.com')) {
        // Extract email address
        String email = user.email ?? '';

        // Extract username from email, avoiding the ".gmail.com" part
        String fetchedUserName =
            email.split('@').first.replaceAll('.gmail', '');

        // Update the state with the fetched username
        setState(() {
          userName = fetchedUserName;
        });
      } else {
        // Get the current user ID from FirebaseAuth
        String userId = user?.uid ?? '';

        // Check if the user ID is not empty
        if (userId.isNotEmpty) {
          // Reference to the Firestore collection for user data
          DocumentSnapshot<Map<String, dynamic>> userDoc =
              await FirebaseFirestore.instance
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
      }
    } catch (e) {
      print('Error fetching username: $e');
    }
  }

  // Function to open the survey form dialog
  void _openSurveyForm() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Carbon footprint Tracker Survey',
            style: TextStyle(fontSize: 20),
          ),
          // Add your survey form widget here
          content: Survey(
            onSurveyCompleted: (percent) async {
              // Update the state with the calculated percent
              setState(() {
                calculatedPercent = percent;
              });

              // Store the calculated percentage in shared preferences
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setDouble('calculatedPercent', percent);
            },
            userId: FirebaseAuth.instance.currentUser?.uid ?? '',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove app bar shadow
        scrolledUnderElevation: screenHeight,
        title: Text(
          "Hello $userName",
          style: const TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 23, 21, 21),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: screenHeight,
            width: 650,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.2, 0.5, 0.8],
                colors: [
                  Color.fromARGB(255, 243, 244, 244),
                  Color.fromARGB(255, 228, 236, 237),
                  Color.fromARGB(255, 211, 227, 235),
                ],
              ),
            ),
            child: Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(
                  top: 90, left: 60, right: 60), // Adjust padding

              child: Indicator(
                percent: calculatedPercent,
                co2eKg: 0,
              ),
              // child: FitCircularWidget(heartPoints: 1800, steps: 80),
            ),
          ),

          // const Positioned.fill(
          //   child: CloudAnimation(),
          // ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _animation,
        child: FloatingActionButton.extended(
          onPressed: _openSurveyForm,
          label: const Text('Take Survey'),
          icon: const Icon(Icons.assignment),
          backgroundColor: Color.fromARGB(255, 141, 230, 174),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
          // Navigate to the corresponding page when an icon is tapped
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/track');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/reduce');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/connect');
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
