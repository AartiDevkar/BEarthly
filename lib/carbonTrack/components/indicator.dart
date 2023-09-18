import 'package:percent_indicator/percent_indicator.dart';

import 'package:flutter/material.dart';

class Indicator extends StatefulWidget {
  const Indicator({super.key});

  @override
  State<Indicator> createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(),
          child: SizedBox(
            child: CircularPercentIndicator(
              radius: 130,
              lineWidth: 20,
              progressColor: Colors.teal,
              percent: 0.0,
            ),
          )),
    );
  }
}
