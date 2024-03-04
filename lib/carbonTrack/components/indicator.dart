import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';

class Indicator extends StatefulWidget {
  final double percent; // Add a field to store the percent

  const Indicator({
    Key? key,
    required this.percent,
  }) : super(key: key);

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
            radius: 140.0,
            lineWidth: 20,
            backgroundColor: const Color.fromARGB(148, 34, 74, 67),
            percent: widget.percent, // Use the widget's percent parameter
            center: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  " CO₂", // Format percent
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text("${(widget.percent * 100).toStringAsFixed(2)} ",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  " So far this month ",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),

            animation: true,
            animationDuration: 1500,
            progressColor: Color.fromARGB(255, 68, 227, 158),
            circularStrokeCap: CircularStrokeCap.round,
          ),
        ),
        SizedBox(
          height: 100,
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                child: LinearPercentIndicator(
                  backgroundColor: Color.fromARGB(147, 94, 129, 123),
                  barRadius: const Radius.circular(20),
                  width: 200.0,
                  lineHeight: 10,
                  percent: widget.percent, // Use the widget's percent parameter
                  leading: const Text(
                    "you:   ",
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w500),
                  ),
                  animation: true,
                  animationDuration: 1500,
                  progressColor: const Color.fromARGB(255, 34, 121, 108),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Container(
                child: LinearPercentIndicator(
                  backgroundColor: Color.fromARGB(147, 94, 129, 123),
                  barRadius: const Radius.circular(20),
                  width: 200.0,
                  lineHeight: 10,
                  percent: 0.9, // Use the widget's percent parameter
                  leading: Text(
                    "India:\t",
                    style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 20, 20, 20),
                        fontWeight: FontWeight.w500),
                  ),
                  animation: true,
                  animationDuration: 1500,
                  progressColor: const Color.fromARGB(255, 34, 121, 108),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Container(
                child: LinearPercentIndicator(
                  backgroundColor: Color.fromARGB(147, 94, 129, 123),
                  barRadius: const Radius.circular(20),
                  width: 200.0,
                  lineHeight: 10,
                  percent: 1.0, // Use the widget's percent parameter
                  leading: Text(
                    "World:", //37.55 GtCO2
                    style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w500),
                  ),
                  animation: true,
                  animationDuration: 1500,
                  progressColor: const Color.fromARGB(255, 34, 121, 108),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
