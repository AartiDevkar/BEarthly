// ignore_for_file: unused_import

import 'package:bearthly/sign_up_pages/pages/signUp.dart';
import 'package:bearthly/sign_up_pages/pages/welcomePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.teal, canvasColor: Colors.teal),
      debugShowCheckedModeBanner: false,
      // ignore: prefer_const_constructors
      home: Signup(),
    );
  }
}
