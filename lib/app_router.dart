// app_router.dart

import 'package:bearthly/carbonTrack/home_page.dart';
import 'package:bearthly/connect_pages/Connect.dart';
import 'package:bearthly/intro_pages/onboarding_screens.dart';
import 'package:bearthly/recycle_pages/recycle.dart';
import 'package:bearthly/reduce_pages/reduce.dart';
import 'package:bearthly/sign_up_pages/pages/loginPage.dart';
import 'package:bearthly/sign_up_pages/pages/signUp.dart';

import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => Signup());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomePage());

      case '/reduce':
        return MaterialPageRoute(builder: (_) => Reduce());
      case '/recycle':
        return MaterialPageRoute(builder: (_) => Recycle());
      case '/connect':
        return MaterialPageRoute(builder: (_) => Connect());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
