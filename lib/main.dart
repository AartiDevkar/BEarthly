import 'package:bearthly/carbonTrack/home_page.dart';
import 'package:bearthly/connect_pages/Connect.dart';
import 'package:bearthly/recycle_pages/recycle.dart';
import 'package:bearthly/reduce_pages/reduce.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool onboardingShown = prefs.getBool('onboardingShown') ?? true;

  runApp(MyApp(onboardingShown: onboardingShown));
}

class MyApp extends StatelessWidget {
  final bool onboardingShown;

  const MyApp({Key? key, required this.onboardingShown}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        canvasColor: Color.fromARGB(255, 191, 228, 228),
      ),
      debugShowCheckedModeBanner: false,
      // home: onboardingShown ? LoginPage() : const OnBoardingScreen(),
      // onGenerateRoute: AppRouter.generateRoute,
      home: HomePage(),
      routes: {
        '/reduce': (context) => const Reduce(),
        '/recycle': (context) => const Recycle(),
        '/connect': (context) => const Connect(),
      },
    );
  }
}
