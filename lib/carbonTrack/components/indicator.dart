import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class Indicator extends StatefulWidget {
  const Indicator({super.key});

  Future<double> fetchUserCarbonFootprint() async {
    try {
      // Assuming you have initialized Firebase elsewhere in your app
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Replace 'user_id' with the actual user ID or any logic to get the data for the current user
      DocumentSnapshot snapshot =
          await firestore.collection('Survey').doc('user_id').get();

      // Check if the document exists and contains the 'carbonFootprint' field
      if (snapshot.exists &&
          snapshot.data() != null &&
          snapshot.data()!.containsKey('carbonFootprint')) {
        // Explicitly cast the result to double
        double carbonFootprint =
            (snapshot.data()!['carbonFootprint'] as num).toDouble();
        return carbonFootprint;
      } else {
        // Handle the case where the field does not exist or is null
        print("Error: 'carbonFootprint' field not found or is null");
        return 0.0; // Return a default value or handle it accordingly
      }
    } catch (e) {
      // Handle other exceptions if necessary
      print("Error fetching user carbon footprint: $e");
      return 0.0; // Return a default value or handle it accordingly
    }
  }

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
            radius: 90.0,
            lineWidth: 20,
            percent: 0.5,
            center: new Text(
              "70%",
              style: TextStyle(fontSize: 40),
            ),
            footer: new Text(
              "This months carbon footprint ",
              style: TextStyle(fontSize: 20),
            ),
            animation: true,
            animationDuration: 1500,
            progressColor: Colors.pink,
            circularStrokeCap: CircularStrokeCap.round,
          ),
        ),
        const SizedBox(
          height: 370,
        ),
        Container(
          child: LinearPercentIndicator(
            width: 200.0,
            lineHeight: 10,
            percent: 0.5,
            leading: new Text(
              "yours :",
              style: TextStyle(fontSize: 20),
            ),
            animation: true,
            animationDuration: 1500,
            progressColor: Color.fromARGB(255, 27, 145, 112),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          child: LinearPercentIndicator(
            width: 200.0,
            lineHeight: 10,
            percent: 0.5,
            leading: new Text(
              "India : ",
              style: TextStyle(fontSize: 20),
            ),
            animation: true,
            animationDuration: 1500,
            progressColor: Color.fromARGB(255, 27, 145, 112),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          child: LinearPercentIndicator(
            width: 200.0,
            lineHeight: 10,
            percent: 0.5,
            leading: new Text(
              "World: ",
              style: TextStyle(fontSize: 20),
            ),
            animation: true,
            animationDuration: 1500,
            progressColor: Color.fromARGB(255, 27, 145, 112),
          ),
        )
      ],
    );
  }
}
