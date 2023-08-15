import 'package:flutter/material.dart';

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
      body: Stack(
        children: [
          Image.asset(
            'assets/images/bg1.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          const Positioned.fill(
              child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              'Welcome',
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
          ))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: Colors.black,
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
