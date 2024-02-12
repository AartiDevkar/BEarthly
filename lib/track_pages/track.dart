import 'package:flutter/material.dart';
import 'package:bearthly/track_pages/components/bar_graph/bar_graph.dart';
import 'package:bearthly/track_pages/components/pie_chart_components/piechart.dart';

class Track extends StatefulWidget {
  const Track({Key? key}) : super(key: key);

  @override
  State<Track> createState() => _TrackState();
}

class _TrackState extends State<Track> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track'),
        backgroundColor: Color.fromARGB(255, 191, 228, 228),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BarChartSample2(),
              SizedBox(height: 20), // Add some space between charts
              Piechart(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
          // Navigate to the corresponding page when an icon is tapped
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/');
              break;
            case 1:
              Navigator.pushNamed(context, '/track');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/reduce');
              break;
            case 3:
              Navigator.pushNamed(context, '/connect');
              break;
          }
        },
        selectedItemColor: const Color.fromARGB(255, 20, 137, 135),
        unselectedItemColor: const Color.fromARGB(255, 121, 154, 203),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_downward),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recycling),
            label: 'Reduce',
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
