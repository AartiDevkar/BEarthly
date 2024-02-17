import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Future<void> _submitFeedback() async {
    try {
      String feedbackText = _feedbackController.text.trim();
      String Name = _nameController.text;

      if (feedbackText.isNotEmpty) {
        await FirebaseFirestore.instance.collection('feedback').add({
          'name': Name,
          'text': feedbackText,
          'timestamp': FieldValue.serverTimestamp(),
        });
        // Clear the feedback text field after submission
        _feedbackController.clear();
        _nameController.clear();
        // Show a feedback message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Feedback submitted successfully'),
          ),
        );
      } else {
        // Show an error message if feedback is empty
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter your feedback'),
          ),
        );
      }
    } catch (error) {
      print('Error submitting feedback: $error');
      // Show an error message if submission fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit feedback. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
                "Thanks for downloading Bearthly app and for taking time to help us improve it"),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Enter your Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _feedbackController,
              decoration: InputDecoration(
                labelText: 'Enter your feedback',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitFeedback,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
