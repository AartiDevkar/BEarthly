import 'package:flutter/material.dart';
import 'components/Survey.dart';
// ignore: unused_import
import 'components/indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _nameState();
}

class _nameState extends State<HomePage> {
  int currentIndex = 0;

  // Function to open the survey form dialog
  void _openSurveyForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Survey Form'),
          // Add your survey form widget here
          content: Survey(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 800,
            width: 450,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(100, 171, 225, 0.871),
                  Color.fromARGB(255, 142, 197, 229),
                  Color.fromARGB(255, 134, 173, 215),
                ],
              ),
            ),
            child: const Align(
              alignment: Alignment(15, 15),
              child: Indicator(),
            ),
          ),

          // Add the round button above the indicator
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: _openSurveyForm,
              child: Text('Open Survey'),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(45), // Adjust padding as needed
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        selectedItemColor: const Color.fromARGB(255, 20, 137, 135),
        unselectedItemColor: const Color.fromARGB(255, 121, 154, 203),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_downward),
            label: 'Reduce',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recycling),
            label: 'Recycle',
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
