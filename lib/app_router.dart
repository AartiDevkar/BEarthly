// app_router.dart

import 'package:bearthly/carbonTrack/home_page.dart';

import 'package:bearthly/intro_pages/onboarding_screens.dart';

import 'package:bearthly/sign_up_pages/pages/login_page.dart';

import 'package:bearthly/sign_up_pages/pages/sign_up.dart';

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
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());

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
