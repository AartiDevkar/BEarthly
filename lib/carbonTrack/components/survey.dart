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
  // Define variables to store user responses
  List<int?> questionResponses = List<int?>.filled(
    8,
    null,
    growable: false,
  );

  // Sample questions with options
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'How do you primarily commute to work/school?',
      'options': ['Public Transport', 'Car/bike', 'Cycle/Walking'],
    },
    {
      'question': 'What type of energy sources power your home?',
      'options': ['Solar', 'Wind', 'Other'],
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
      'question': 'How often do you recycle paper, plastic, and glass?',
      'options': ['Always', 'Often', 'Rarely', 'Never'],
    },
    {
      'question': 'Do you use LED bulbs in your home?',
      'options': ['Yes', 'No'],
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
      'question': 'How many times do you take flights per year?',
      'options': ['None', '1-2 times', '3-5 times', 'More than 5 times'],
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
  Widget build(BuildContext context) {
    return Container(
      height: 500,
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
                      calculateCarbonFootprint(questionResponses);
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
              RadioListTile<int?>(
                title: Text(questions[index]['options']![i]),
                value: i + 1,
                groupValue: questionResponses[index],
                onChanged: (int? value) {
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

  double calculateCarbonFootprint(List<int?> questionResponses) {
    List<double> emissionFactors = [5.0, 3.0, 4.0, 2.0, 1.0, 6.0, 10.0, 8.0];
    double totalCarbonFootprint = 0.0;

    for (int i = 0; i < questionResponses.length; i++) {
      if (questionResponses[i] != null) {
        totalCarbonFootprint +=
            emissionFactors[i] * (questionResponses[i]! - 1);
      }
    }

    return totalCarbonFootprint;
  }

  Future<void> storeSurveyData(
      List<int?> questionResponses, double carbonFootprint) async {
    try {
      Map<String, dynamic> surveyData = {
        'question1': questionResponses[0],
        'question2': questionResponses[1],
        'question3': questionResponses[2],
        'question4': questionResponses[3],
        'question5': questionResponses[4],
        'question6': questionResponses[5],
        'question7': questionResponses[6],
        'question8': questionResponses[7],
        'carbonFootprint': carbonFootprint,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await surveyCollection.add(surveyData);

      print('Survey data successfully stored in Firestore');
    } catch (e) {
      print('Error storing survey data: $e');
    }
  }
}
