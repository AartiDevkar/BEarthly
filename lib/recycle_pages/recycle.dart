import 'package:flutter/material.dart';
import 'package:bearthly/recycle_pages/components/bar_graph/bar_graph.dart';
import 'package:bearthly/recycle_pages/components/pie_chart_components/piechart.dart';

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
    );
  }
}
