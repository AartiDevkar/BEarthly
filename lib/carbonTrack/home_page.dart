import 'package:flutter/material.dart';
import 'components/indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _nameState();
}

class _nameState extends State<HomePage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    int selectedIndex = 0;
    return Scaffold(
      body: Container(
        child: const Indicator(),
        height: 800,
        width: 450,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(100, 171, 225, 0.871),
              Color.fromARGB(255, 142, 197, 229),
              Color.fromARGB(255, 134, 173, 215)
            ],
          ),
        ),
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
              label: 'connect',
              tooltip: 'Connect'),
        ],
      ),
    );
  }
}
