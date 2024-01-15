import 'package:bearthly/carbonTrack/components/co2_calculator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Survey extends StatefulWidget {
  final void Function(double) onSurveyCompleted;

  const Survey({Key? key, required this.onSurveyCompleted}) : super(key: key);

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
      'question': 'How many times do you take flights per year?',
      'options': ['None', '1-2 times', '3-5 times', 'More than 5 times'],
    },
    {
      'question': 'What is your preferred mode of shopping for everyday items?',
      'options': [
        'In-store shopping',
        'Online shopping with fast shipping',
        'Online shopping with eco-friendly shipping options',
        'I rarely shop for everyday items'
      ],
    },
    {
      'question': 'What type of energy sources power your home?',
      'options': ['Solar', 'Wind', 'Other'],
    },
    {
      'question': 'Do you use LED bulbs in your home?',
      'options': ['Yes', 'No'],
    },
    {
      'question':
          'How often do you use energy-intensive appliances such as air conditioners, heaters, or large electronic devices?',
      'options': ['Frequently', 'Occasionally', 'Rarely', 'Never'],
    },
    {
      'question': 'What is your primary source of protein?',
      'options': [
        'Meat',
        'Fish/Seafood',
        'Plant based sources(tofu,beans,lentils)',
        'Dairy Products'
      ],
    },
    {
      'question': 'How many gallons of water do you use per day on average?',
      'options': [
        'Less than 50 gallons',
        '50-100 gallons',
        '100-150 gallons',
        'More than 150 gallons'
      ],
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
  CollectionReference surveyCollection =
      FirebaseFirestore.instance.collection('Survey');

  @override
  void initState() {
    super.initState();
    _carbonCalculator = CarbonCalculator(context as BuildContext);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: 800,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Carbon Tracker Survey'),
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
                  double totalCarbonFootprint =
                      _carbonCalculator.calculateFootprints(questionResponses);
                  await storeSurveyData(
                      questionResponses, totalCarbonFootprint);
                  double maxCarbonFootprint = 100.0;
                  double calculatedPercent =
                      totalCarbonFootprint / maxCarbonFootprint;
                  widget.onSurveyCompleted(calculatedPercent);

                  Navigator.of(context).pop();
                },
                child: Icon(Icons.check),
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
            SizedBox(height: 8.0),
            Text(
              questions[index]['question'] ?? '',
              style: TextStyle(fontSize: 16.0),
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

  Future<void> storeSurveyData(
      List<String?> questionResponses, double carbonFootprint) async {
    try {
      Map<String, dynamic> surveyData = {
        'transport': getOptionText(0, questionResponses),
        'flights_year': getOptionText(1, questionResponses),
        'shopping_mode': getOptionText(2, questionResponses),
        'energy_source_home': getOptionText(3, questionResponses),
        'LED_bulbs': getOptionText(4, questionResponses),
        'energy_intensive_appliances': getOptionText(5, questionResponses),
        'protein_source': getOptionText(6, questionResponses),
        'water_usage': getOptionText(7, questionResponses),
        'recycle_waste': getOptionText(8, questionResponses),
        'E-waste_recycle': getOptionText(9, questionResponses),
        'carbonFootprint': carbonFootprint,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await surveyCollection.add(surveyData);

      print('Survey data successfully stored in Firestore');
    } catch (e) {
      print('Error storing survey data: $e');
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
