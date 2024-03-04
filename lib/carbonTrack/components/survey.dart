import 'dart:math';

import 'package:bearthly/carbonTrack/components/co2_calculator.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Survey extends StatefulWidget {
  final void Function(double, double) onSurveyCompleted;

  const Survey(
      {Key? key, required this.onSurveyCompleted, required String userId})
      : super(key: key);

  @override
  State<Survey> createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  PageController _pageController = PageController();
  int _currentPageIndex = 0;
  List<String?> questionResponses = List<String?>.filled(
    10,
    null,
    growable: false,
  );
  late final CarbonCalculator _carbonCalculator;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'How do you primarily commute to work/school?',
      'options': ['Public Transport', 'Car/bike', 'Cycle/Walking'],
    },
    {
      'question': 'How much distance you travel everyday?',
      'options': [
        ' less than 50km',
        '50-100 km',
        '100-150km',
        'More than 150 km'
      ],
    },
    {
      'question': 'How many times do you take flights per year?',
      'options': ['None', '1-2 times', '3-5 times', 'More than 5 times'],
    },
    {
      'question': 'What is your preferred mode of shopping for everyday items?',
      'options': [
        'In-store shopping',
        'Online shopping with fast shipping',
        'I rarely shop for everyday items'
      ],
    },
    {
      'question': 'Do you use LED bulbs in your home?',
      'options': ['Yes', 'No'],
    },
    {
      'question': 'What type of energy sources power your home?',
      'options': [
        'Solar',
        'Electricity from the grid (Utility company)',
        'Other'
      ],
    },
    {
      'question':
          'How often do you use energy-intensive appliances such as air conditioners, heaters, or large electronic devices?',
      'options': ['Frequently', 'Occasionally', 'Rarely', 'Never'],
    },
    {
      'question': 'What is your primary source of protein?',
      'options': ['Heavy meat eater', 'Low meat eater', 'Vegetarian', 'Vegan'],
    },
    {
      'question': 'How often do you recycle paper, plastic, and glass?',
      'options': ['Always', 'Often', 'Rarely', 'Never'],
    },
    {
      'question': 'How do you dispose of electronic waste (e-waste)?',
      'options': [
        'Recycle through designated facilities',
        'Donate or sell',
        'Discard in regular trash',
        'Not sure'
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _carbonCalculator = CarbonCalculator(context as BuildContext);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Container(
        height: 600,
        width: 980,
        child: Scaffold(
          appBar: AppBar(
            title: Text(''),
            backgroundColor: Colors.teal,
          ),
          body: Container(
            child: PageView.builder(
              controller: _pageController,
              itemCount: questions.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildQuestionCard(index);
              },
            ),
          ),
          floatingActionButton: _currentPageIndex < questions.length - 1
              ? FloatingActionButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Icon(Icons.arrow_forward),
                )
              : FloatingActionButton(
                  onPressed: () async {
                    List carbonFootprintData = _carbonCalculator
                        .calculateFootprints(questionResponses);
                    double totalCarbonFootprint = carbonFootprintData[0];

                    double travelFootprints = carbonFootprintData[1];
                    double flightsFootprints = carbonFootprintData[2];
                    double houseHoldFootprints = carbonFootprintData[3];
                    double foodFootprints = carbonFootprintData[4];
                    double shoppingFootprints = carbonFootprintData[5];
                    double recycleFootprints = carbonFootprintData[6];

                    await storeSurveyData(
                        questionResponses, totalCarbonFootprint);

                    await storeFootprintsData(
                        questionResponses,
                        totalCarbonFootprint,
                        travelFootprints,
                        flightsFootprints,
                        shoppingFootprints,
                        foodFootprints,
                        houseHoldFootprints,
                        recycleFootprints);

                    // Update the pie chart with the new footprints
                    setState(() {});

                    double clampedValue =
                        max(0, min(100, totalCarbonFootprint));
                    double normalizedValue = clampedValue / 100;

                    double calculatedPercent = normalizedValue;
                    widget.onSurveyCompleted(
                        calculatedPercent, totalCarbonFootprint);

                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.check),
                ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(int index) {
    return Card(
      elevation: 6.0,
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${index + 1}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              questions[index]['question'] ?? '',
              style: const TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            for (int i = 0; i < questions[index]['options']!.length; i++)
              RadioListTile<String?>(
                title: Text(questions[index]['options']![i]),
                value: (i + 1).toString(),
                groupValue: questionResponses[index],
                onChanged: (String? value) {
                  setState(() {
                    questionResponses[index] = value;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  CollectionReference surveyCollection =
      FirebaseFirestore.instance.collection('Survey');

  Future<void> storeSurveyData(
    List<String?> questionResponses,
    double totalCarbonFootprint,
  ) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null &&
          currentUser.email != null &&
          currentUser.email!.isNotEmpty) {
        String userId = currentUser.email!;
        Map<String, dynamic> currentSurveyData = {
          'transport': getOptionText(0, questionResponses),
          'distance_traveled': getOptionText(1, questionResponses),
          'flights_year': getOptionText(2, questionResponses),
          'shopping_mode': getOptionText(3, questionResponses),
          'led_use': getOptionText(4, questionResponses),
          'energy_source_home': getOptionText(5, questionResponses),
          'energy_intensive_appliances': getOptionText(6, questionResponses),
          'protein_source': getOptionText(7, questionResponses),
          'waste_recycle': getOptionText(8, questionResponses),
          'E-waste_recycle': getOptionText(9, questionResponses),
          'carbonFootprint': totalCarbonFootprint,
          'timestamp': FieldValue.serverTimestamp(),
        };
        await FirebaseFirestore.instance
            .collection('Survey')
            .doc(userId)
            .set(currentSurveyData);
      }
    } catch (e) {
// ignore: avoid_print
      print('Error storing survey data: $e');
    }
  }

  Future<void> storeFootprintsData(
      List<String?> footprintsData,
      double totalCarbonFootprint,
      double travelFootprints,
      double flightsFootprints,
      double shoppingFootprints,
      double houseHoldFootprints,
      double foodFootprints,
      double recycleFootprints) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null &&
          currentUser.email != null &&
          currentUser.email!.isNotEmpty) {
        String userId = currentUser.email!;
        Map<String, dynamic> FootprintsData = {
          'travelFootprints': travelFootprints,
          'flights': flightsFootprints,
          'shopping': shoppingFootprints,
          'houseHoldFootprints': houseHoldFootprints,
          'foodFootprints': foodFootprints,
          'recycleFootprints': recycleFootprints,
          'totalCarbonFootprint': totalCarbonFootprint,
        };
        await FirebaseFirestore.instance
            .collection('FootprintsData')
            .doc(userId)
            .set(FootprintsData);
        print("Footprints  data stored successfully");
      }
    } catch (e) {
      print('Error storing Footprints  data: $e');
    }
  }

  Future<void> storeHistoricalData(
      List<String?> historicalData,
      double totalCarbonFootprint,
      double travelFootprints,
      double flightsFootprints,
      double shoppingFootprints,
      double houseHoldFootprints,
      double foodFootprints,
      double recycleFootprints) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null &&
          currentUser.email != null &&
          currentUser.email!.isNotEmpty) {
        String userId = currentUser.email!;
        DateTime now = DateTime.now();
        String date = "${now.year}-${now.month}-${now.day}";
        Map<String, dynamic> historicalSurveyData = {
          'date': date,
          'totalCarbonFootprint': totalCarbonFootprint,
          'travelFootprints': travelFootprints,
          'flights': flightsFootprints,
          'shopping': shoppingFootprints,
          'houseHoldFootprints': houseHoldFootprints,
          'foodFootprints': foodFootprints,
          'recycleFootprints': recycleFootprints
        };

        //Store historical survey data in the 'historical_data' collectio
        await FirebaseFirestore.instance
            .collection('historical_data')
            .doc(userId)
            .set(historicalSurveyData);
        print("Historical data stored successfully");
        // Use .add() to append a new document to the collection
      }
    } catch (e) {
// ignore: avoid_print
      print('Error storing Footprints and historical  data: $e');
    }
  }

  String? getOptionText(int questionIndex, List<String?> questionResponses) {
    String? responseIndex = questionResponses[questionIndex];
    if (responseIndex != null && responseIndex.isNotEmpty) {
      return questions[questionIndex]['options']![int.parse(responseIndex) - 1];
    }
    return null;
  }
}
