import 'package:bearthly/carbonTrack/home_page.dart';
import 'package:bearthly/connect_pages/Connect.dart';
import 'package:bearthly/intro_pages/onboarding_screens.dart';
import 'package:bearthly/track_pages/track.dart';
import 'package:bearthly/reduce_pages/reduce.dart';
import 'package:bearthly/sign_up_pages/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool onboardingShown = prefs.getBool('onboardingShown') ?? true;

  // Function to check if the user is logged in
  Future<bool> isLoggedIn() async {
    // Get the current user from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    // Return true if the user is not null (logged in), otherwise return false
    return user != null;
  }

  // Check if the user is already logged in
  bool isLoggedInValue = await isLoggedIn();

  // Determine which screen to show based on login and onboarding status
  Widget initialScreen;
  if (isLoggedInValue) {
    initialScreen = const HomePage();
  } else if (onboardingShown) {
    initialScreen = const OnBoardingScreen();
  } else {
    initialScreen = const LoginPage();
  }

  runApp(MyApp(
    initialScreen: initialScreen,
    onboardingShown: false,
  ));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  const MyApp(
      {Key? key, required this.initialScreen, required bool onboardingShown})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        canvasColor: const Color.fromARGB(255, 191, 228, 228),
      ),
      debugShowCheckedModeBanner: false,
      home: initialScreen,
      routes: {
        '/home': ((context) => const HomePage()),
        '/reduce': (context) => const Reduce(),
        '/track': (context) => const Track(),
        '/connect': (context) => const Connect(),
        '/login': ((context) => const LoginPage()),
      },
    );
  }
}
