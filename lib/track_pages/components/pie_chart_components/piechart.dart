import 'package:bearthly/track_pages/components/pie_chart_components/indicator_pie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Piechart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PiechartState();
}

class PiechartState extends State<Piechart> {
  int touchedIndex = -1;
  late double travel = 0.0;
  late double food = 0.0;
  late double energy = 0.0;
  late double other = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchFootprintsAndUpdateSharedPreferences();
  }

  Future<void> _fetchFootprintsAndUpdateSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User? currentUser = FirebaseAuth.instance.currentUser;

    try {
      if (currentUser != null &&
          currentUser.email != null &&
          currentUser.email!.isNotEmpty) {
        String userId = currentUser.email!;
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('FootprintsData')
            .doc(userId)
            .get();

        if (docSnapshot.exists) {
          Map<String, dynamic> data =
              docSnapshot.data() as Map<String, dynamic>;

          // Retrieve the carbon footprint values from Firestore document fields
          double totalCarbonFootprint = data['totalCarbonFootprint'] ?? 0.0;
          double travelFootprints = data['travelFootprints'] ?? 0.0;
          double flightsFootprints = data['flights'] ?? 0.0;
          double shoppingFootprints = data['shopping'] ?? 0.0;
          double houseHoldFootprints = data['houseHoldFootprints'] ?? 0.0;
          double foodFootprints = data['foodFootprints'] ?? 0.0;
          double recycleFootprints = data['recycleFootprints'] ?? 0.0;

          // Calculate percentages
          double total = totalCarbonFootprint != 0
              ? totalCarbonFootprint
              : 1.0; // Avoid division by zero
          double travelPercentage = (travelFootprints / total) * 100;
          double flightsPercentage = (flightsFootprints / total) * 100;
          double shoppingPercentage = (shoppingFootprints / total) * 100;
          double houseHoldPercentage = (houseHoldFootprints / total) * 100;
          double foodPercentage = (foodFootprints / total) * 100;
          double recyclePercentage = (recycleFootprints / total) * 100;

          // Store fetched footprints in shared preferences
          await prefs.setDouble('totalCarbonFootprint', totalCarbonFootprint);
          await prefs.setDouble('travelFootprints', travelPercentage);
          await prefs.setDouble('flightsFootprints', flightsPercentage);
          await prefs.setDouble('shoppingFootprints', shoppingPercentage);
          await prefs.setDouble('houseHoldFootprints', houseHoldPercentage);
          await prefs.setDouble('foodFootprints', foodPercentage);
          await prefs.setDouble('recycleFootprints', recyclePercentage);

          // Update state with fetched footprints
          setState(() {
            travel = travelPercentage;
            energy = houseHoldPercentage;
            food = foodPercentage;
            other = recyclePercentage + shoppingPercentage;
          });
        } else {
          print('Document does not exist for user: $userId');
        }
      }
    } catch (e) {
      print('Error fetching footprints: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          // Reset touched index
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 60,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Indicator_piechart(
                color: Color.fromRGBO(77, 209, 163, 1),
                text: 'Travel',
                isSquare: true,
              ),
              SizedBox(
                height: 4,
              ),
              Indicator_piechart(
                color: Color.fromARGB(255, 142, 225, 126),
                text: 'Food',
                isSquare: true,
              ),
              SizedBox(
                height: 4,
              ),
              Indicator_piechart(
                color: Color.fromARGB(255, 101, 155, 199),
                text: 'Energy',
                isSquare: true,
              ),
              SizedBox(
                height: 4,
              ),
              Indicator_piechart(
                color: Color.fromARGB(255, 150, 182, 231),
                text: 'Other',
                isSquare: true,
              ),
              SizedBox(
                height: 18,
              ),
            ],
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 70.0 : 60.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Color.fromRGBO(77, 209, 163, 1),
            value: travel,
            title: 'Travel',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 225, 249, 241),
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Color.fromARGB(255, 142, 225, 126),
            value: food,
            title: 'Food',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 225, 249, 241),
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Color.fromARGB(255, 101, 155, 199),
            value: energy,
            title: 'Energy',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 225, 249, 241),
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Color.fromARGB(255, 150, 182, 231),
            value: other,
            title: 'Other',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 225, 249, 241),
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
