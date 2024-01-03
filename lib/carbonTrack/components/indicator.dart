import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';

class Indicator extends StatefulWidget {
  final double percent; // Add a field to store the percent

  const Indicator({Key? key, required this.percent, required double co2eKg})
      : super(key: key);

  @override
  State<Indicator> createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: CircularPercentIndicator(
            radius: 125.0,
            lineWidth: 20,
            backgroundColor: Color.fromARGB(148, 34, 74, 67),
            percent: widget.percent, // Use the widget's percent parameter
            center: new Text(
              "${(widget.percent * 100).toStringAsFixed(0)}%", // Format percent
              style: TextStyle(fontSize: 40),
            ),
            footer: new Padding(
              padding: const EdgeInsets.only(top: 10.0), // Add padding here
              child: new Text(
                "This month's carbon footprint ",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            animation: true,
            animationDuration: 1500,
            progressColor: Color.fromARGB(255, 67, 26, 96),
            circularStrokeCap: CircularStrokeCap.round,
          ),
        ),
        const SizedBox(
          height: 250,
        ),
        Container(
          child: LinearPercentIndicator(
            backgroundColor: Color.fromARGB(148, 34, 74, 67),
            width: 200.0,
            lineHeight: 8,
            percent: widget.percent, // Use the widget's percent parameter
            leading: new Text(
              "  you :  ",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            animation: true,
            animationDuration: 1500,
            progressColor: Color.fromARGB(255, 67, 26, 96),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          child: LinearPercentIndicator(
            backgroundColor: Color.fromARGB(148, 34, 74, 67),
            width: 200.0,
            lineHeight: 8,
            percent: widget.percent, // Use the widget's percent parameter
            leading: new Text(
              "India :  ",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            animation: true,
            animationDuration: 1500,
            progressColor: Color.fromARGB(255, 67, 26, 96),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          child: LinearPercentIndicator(
            backgroundColor: Color.fromARGB(148, 34, 74, 67),
            width: 200.0,
            lineHeight: 8,
            percent: widget.percent, // Use the widget's percent parameter
            leading: new Text(
              "World:  ",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            animation: true,
            animationDuration: 1500,
            progressColor: Color.fromARGB(255, 67, 26, 96),
          ),
        ),
      ],
    );
  }
}
