import 'package:flutter/material.dart';

// IntroPage3
class IntroPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // ignore: unused_local_variable
            final introSize = context.size;
            // Do something with introSize if needed
          });

          return Stack(
            children: [
              Image.asset(
                'assets/images/waterImg.webp',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color.fromARGB(255, 38, 74, 135).withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              const Center(
                child: Text(
                  "Make every choice count. Start your eco-journey today.",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
