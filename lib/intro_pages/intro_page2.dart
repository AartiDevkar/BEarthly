import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {
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
                'assets/images/leafImg1.jpg',
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
                      const Color.fromARGB(255, 38, 74, 135).withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Join a global community for a sustainable tomorrow.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 247, 234, 117),
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Pacifico', // Using Pacifico font
                      fontSize: 35,
                      shadows: [
                        Shadow(
                          blurRadius: 5,
                          color: Colors.black,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ); //
        },
      ),
    );
  }
}
