// ignore_for_file: unused_import

import 'package:bearthly/carbonTrack/home_page.dart';
import 'package:bearthly/intro_pages/onboarding_screens.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bearthly/sign_up_pages/pages/signUp.dart';
import 'package:bearthly/sign_up_pages/pages/loginPage.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.teal,
          canvasColor: Color.fromARGB(255, 191, 228, 228)),
      debugShowCheckedModeBanner: false,
      // ignore: prefer_const_constructors
      home: OnBoardingScreen(),
    );
  }
}
