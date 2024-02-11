import 'package:bearthly/carbonTrack/components/co2_calculator.dart';
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
  double totalCarbonFootprint = 0.0;
  List<QuestionResponses> questionResponses = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    CarbonCalculator calculator = CarbonCalculator(context);
    await calculator.retrieveAnswers(); // Await the method
    questionResponses =
        calculator.questionResponses; // Store the survey responses
    _calculateTotalCarbonFootprint();
  }

  Future<void> _calculateTotalCarbonFootprint() async {
    CarbonCalculator calculator = CarbonCalculator(context);

    // Extract the relevant data from questionResponses
    List<String?> responses = questionResponses
        .map((response) => [
              response.transport,
              response.flightsYear,
              response.shoppingMode,
              response.energySourceHome,
              response.ledBulbs,
              response.energyIntensiveAppliances,
              response.proteinSource,
              response.waterUsage,
              response.recycleWaste,
              response.eWasteRecycle,
            ])
        .expand((element) => element)
        .toList();

    // Calculate total carbon footprint
    totalCarbonFootprint = calculator.calculateFootprints(responses);

    // Update the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: CircularPercentIndicator(
            radius: 125.0,
            lineWidth: 20,

            backgroundColor: const Color.fromARGB(148, 34, 74, 67),
            percent: widget.percent, // Use the widget's percent parameter
            center: new Text(
              "${(widget.percent * 100).toStringAsFixed(2)} kg CO2e", // Format percent
              style: const TextStyle(fontSize: 28),
            ),
            footer: const Padding(
              padding: EdgeInsets.only(top: 3.0), // Add padding here
              child: Text(
                "This month's carbon footprint ",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            animation: true,
            animationDuration: 1500,
            progressColor: const Color.fromARGB(255, 67, 26, 96),
            circularStrokeCap: CircularStrokeCap.round,
          ),
        ),
        const SizedBox(
          height: 100,
        ),
        const SizedBox(height: 10),
        Container(
          child: LinearPercentIndicator(
            backgroundColor: const Color.fromARGB(148, 34, 74, 67),
            barRadius: const Radius.circular(20),
            width: 200.0,
            lineHeight: 8,
            percent: widget.percent, // Use the widget's percent parameter
            leading: const Text(
              "  you :  ",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            animation: true,
            animationDuration: 1500,
            progressColor: const Color.fromARGB(255, 67, 26, 96),
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Container(
          child: LinearPercentIndicator(
            backgroundColor: const Color.fromARGB(148, 34, 74, 67),
            barRadius: const Radius.circular(20),
            width: 200.0,
            lineHeight: 8,
            percent: 0.5, // Use the widget's percent parameter
            leading: new Text(
              "India :  ",
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
            animation: true,
            animationDuration: 1500,
            progressColor: const Color.fromARGB(255, 67, 26, 96),
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Container(
          child: LinearPercentIndicator(
            backgroundColor: const Color.fromARGB(148, 34, 74, 67),
            barRadius: const Radius.circular(20),
            width: 200.0,
            lineHeight: 8,
            percent: 0.8, // Use the widget's percent parameter
            leading: new Text(
              "World:  ",
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
            animation: true,
            animationDuration: 1500,
            progressColor: const Color.fromARGB(255, 67, 26, 96),
          ),
        ),
      ],
    );
  }
}
