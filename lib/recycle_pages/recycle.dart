import 'package:flutter/material.dart';

class Recycle extends StatefulWidget {
  const Recycle({super.key});

  @override
  State<Recycle> createState() => _RecycleState();
}

class _RecycleState extends State<Recycle> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recycle'),
        backgroundColor: Color.fromARGB(255, 191, 228, 228),
      ),
      backgroundColor: Color.fromRGBO(8, 128, 90, 0.833),
    );
  }
}
