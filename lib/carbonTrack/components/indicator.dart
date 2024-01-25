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
    _calculateTotalCarbonFootprint();
  }

  Future<void> _calculateTotalCarbonFootprint() async {
    CarbonCalculator calculator = CarbonCalculator(context);
    totalCarbonFootprint = calculator.calculateFootprints(questionResponses
        .map((response) =>
            response.transport +
            response.flightsYear +
            response.shoppingMode +
            response.energySourceHome +
            response.ledBulbs +
            response.energyIntensiveAppliances +
            response.proteinSource +
            response.waterUsage +
            response.recycleWaste +
            response.eWasteRecycle)
        .toList());

    // Assuming that the total carbon footprint is in the range [0, 1]

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double transportPercent = totalCarbonFootprint / 1.0;
    double energyPercent =
        totalCarbonFootprint / 1.0; // Change this based on your calculation
    double foodPercent =
        totalCarbonFootprint / 1.0; // Change this based on your calculation

    return Column(
      children: [
        Container(
          child: CircularPercentIndicator(
            radius: 125.0,
            lineWidth: 20,

            backgroundColor: Color.fromARGB(148, 34, 74, 67),
            percent: widget.percent, // Use the widget's percent parameter
            center: Text(
              "${(totalCarbonFootprint.toStringAsFixed(2))} kg CO2e", // Format percent
              style: TextStyle(fontSize: 28),
            ),
            footer: const Padding(
              padding: EdgeInsets.only(top: 7.0), // Add padding here
              child: Text(
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
          height: 100,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 130,
                width: 100,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border:
                      Border.all(color: const Color.fromARGB(255, 77, 65, 65)),
                  borderRadius: BorderRadius.circular(16),
                  color: Color.fromARGB(148, 34, 74, 67),
                ),
                child: Container(
                  child: Column(
                    children: [
                      Icon(
                        Icons.emoji_transportation,
                        size: 40,
                      ),
                      Text(
                        'Transport',
                        style: TextStyle(fontSize: 13),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      LinearPercentIndicator(
                        progressColor: Color.fromARGB(255, 216, 79, 237),
                        barRadius: Radius.circular(15),
                        percent: transportPercent,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                height: 130,
                width: 100,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border:
                      Border.all(color: const Color.fromARGB(255, 77, 65, 65)),
                  borderRadius: BorderRadius.circular(16),
                  color: Color.fromARGB(148, 34, 74, 67),
                ),
                child: Container(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.energy_savings_leaf,
                        size: 40,
                      ),
                      const Text(
                        'Energy',
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      LinearPercentIndicator(
                        progressColor: Color.fromARGB(255, 216, 79, 237),
                        barRadius: Radius.circular(15),
                        percent: energyPercent,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                height: 130,
                width: 100,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border:
                      Border.all(color: const Color.fromARGB(255, 77, 65, 65)),
                  borderRadius: BorderRadius.circular(16),
                  color: Color.fromARGB(148, 34, 74, 67),
                ),
                child: Container(
                  child: Column(
                    children: [
                      Icon(
                        Icons.food_bank,
                        size: 40,
                      ),
                      Text(
                        'Food',
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      LinearPercentIndicator(
                        progressColor: Color.fromARGB(255, 216, 79, 237),
                        barRadius: Radius.circular(15),
                        percent: foodPercent,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          child: LinearPercentIndicator(
            backgroundColor: Color.fromARGB(148, 34, 74, 67),
            barRadius: Radius.circular(20),
            width: 200.0,
            lineHeight: 8,
            percent: widget.percent, // Use the widget's percent parameter
            leading: const Text(
              "  you :  ",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            animation: true,
            animationDuration: 1500,
            progressColor: Color.fromARGB(255, 67, 26, 96),
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Container(
          child: LinearPercentIndicator(
            backgroundColor: Color.fromARGB(148, 34, 74, 67),
            barRadius: Radius.circular(20),
            width: 200.0,
            lineHeight: 8,
            percent: 0.5, // Use the widget's percent parameter
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
          height: 2,
        ),
        Container(
          child: LinearPercentIndicator(
            backgroundColor: Color.fromARGB(148, 34, 74, 67),
            barRadius: Radius.circular(20),
            width: 200.0,
            lineHeight: 8,
            percent: 0.8, // Use the widget's percent parameter
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
