import 'package:flutter/material.dart';

class CarbonTrackerSurvey extends StatefulWidget {
  @override
  _CarbonTrackerSurveyState createState() => _CarbonTrackerSurveyState();
}

class _CarbonTrackerSurveyState extends State<CarbonTrackerSurvey> {
  PageController _pageController = PageController();
  int _currentPageIndex = 0;

  // Define variables to store user responses
  List<double> questionResponses = List<double>.filled(
    8,
    0.0,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carbon Tracker Survey'),
        backgroundColor: Colors.teal,
      ),
      body: PageView.builder(
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
              onPressed: () {
                // Process and save user responses here
                // You can calculate the carbon footprint when the survey is completed
              },
              child: Icon(Icons.check),
            ),
    );
  }

  Widget _buildQuestionCard(int index) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${index + 1}',
              style: TextStyle(
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
            Slider(
              value: questionResponses[index],
              onChanged: (value) {
                setState(() {
                  questionResponses[index] = value;
                });
              },
              min: 0.0,
              max: 1.0,
              divisions: 5,
              label: _getSliderLabel(questionResponses[index]),
            ),
          ],
        ),
      ),
    );
  }

  String _getSliderLabel(double value) {
    // Customize the labels based on your question or scale
    if (value == 0.0) return 'Never';
    if (value == 1.0) return 'Always';
    if (value == 0.20) return 'Sometimes';
    return 'Value: ${value.toStringAsFixed(2)}'; // Custom label
  }
}
