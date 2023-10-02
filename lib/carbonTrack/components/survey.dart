import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class Survey extends StatefulWidget {
  @override
  _SurveyState createState() => _SurveyState();
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

  // Sample questions
  final List<String> questions = [
    'How do you primarily commute to work/school?',
    'What type of energy sources power your home?',
    'How often do you consume red meat?',
    'How often do you recycle paper, plastic, and glass?',
    'Do you use LED bulbs in your home?',
    'How many gallons of water do you use per day on average?',
    'How many times do you take flights per year?',
    'How often do you buy new vs. used items?',
  ];

  // Reference to the Firestore collection
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
                  // Calculate the carbon footprint
                  double carbonFootprint =
                      calculateCarbonFootprint(questionResponses);

                  // Store the survey data in Firebase Firestore
                  await storeSurveyData(questionResponses, carbonFootprint);
                  // ignore: unnecessary_null_comparison
                  if (questionResponses != null) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  }
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
              questions[index],
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            // Add radio buttons with options
            RadioListTile<int?>(
              title: Text('Option 1'),
              value: 1,
              groupValue: questionResponses[index],
              onChanged: (int? value) {
                setState(() {
                  questionResponses[index] = value;
                });
              },
            ),
            RadioListTile<int?>(
              title: Text('Option 2'),
              value: 2,
              groupValue: questionResponses[index],
              onChanged: (int? value) {
                setState(() {
                  questionResponses[index] = value;
                });
              },
            ),
            RadioListTile<int?>(
              title: Text('Option 3'),
              value: 3,
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

  // Function to calculate carbon footprint (you can define this)
  double calculateCarbonFootprint(List<int?> questionResponses) {
    // Implement your carbon footprint calculation logic here
    // You can use the values selected in questionResponses
    // and assign carbon emissions values to options.
    // Calculate and return the total carbon footprint.
    // Example:
    // double totalCarbonFootprint = ...;
    // return totalCarbonFootprint;
    return 0;
  }

  // Function to store survey data in Firestore
  Future<void> storeSurveyData(
      List<int?> questionResponses, double carbonFootprint) async {
    try {
      // Create a map representing the survey response
      Map<String, dynamic> surveyData = {
        'question1': questionResponses[0],
        'question2': questionResponses[1],
        'question3': questionResponses[2],
        'question4': questionResponses[3],
        'question5': questionResponses[4],
        'question6': questionResponses[5],
        'question7': questionResponses[6],
        'question8': questionResponses[7], // Add more questions here...
        'carbonFootprint': carbonFootprint,
        'timestamp': FieldValue.serverTimestamp(), // Add a timestamp
      };

      // Add the survey data to the Firestore collection
      await surveyCollection.add(surveyData);

      print('Survey data successfully stored in Firestore');
    } catch (e) {
      print('Error storing survey data: $e');
    }
  }
}
