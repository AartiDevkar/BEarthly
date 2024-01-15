import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuestionResponses {
  late String transport;
  late String flightsYear;
  late String shoppingMode;
  late String energySourceHome;
  late String ledBulbs;
  late String energyIntensiveAppliances;
  late String proteinSource;
  late String waterUsage;
  late String recycleWaste;
  late String eWasteRecycle;

  QuestionResponses({
    required this.transport,
    required this.flightsYear,
    required this.shoppingMode,
    required this.energySourceHome,
    required this.ledBulbs,
    required this.energyIntensiveAppliances,
    required this.proteinSource,
    required this.waterUsage,
    required this.recycleWaste,
    required this.eWasteRecycle,
  });
}

class CarbonCalculator {
  late BuildContext context;
  List<QuestionResponses> questionResponses = [];
  CarbonCalculator(this.context);

  static final List<List<double>> emissions = [
    [0.05, 0.12, 0.08], // Transport (example: kg CO2 per km traveled)
    [0.2, 0.1, 0.15, 0.18], // Flights (example: kg CO2 per passenger-km)
    [0.03, 0.05, 0.02, 0.01], // Shopping (example: kg CO2 per dollar spent)
    [0.1, 0.08, 0.06], // Energy sources (example: kg CO2 per kWh)
    [0.02, 0.01], // LED bulbs (example: kg CO2 per hour of use)
    [0.15, 0.12, 0.08, 0.05], // Appliances (example: kg CO2 per hour of use)
    [
      0.05,
      0.03,
      0.02,
      0.01
    ], // Protein sources (example: kg CO2 per gram of protein)
    [
      0.02,
      0.03,
      0.01,
      0.04
    ], // Water usage (example: kg CO2 per gallon of water)
    [0.03, 0.02, 0.01, 0.005], // Recycle (example: kg CO2 per item recycled)
    [
      0.02,
      0.015,
      0.01,
      0.005
    ], // E-waste recycle (example: kg CO2 per item recycled)
  ];

  CollectionReference surveyCollection =
      FirebaseFirestore.instance.collection('Survey');

  Future<void> retrieveAnswers() async {
    try {
      QuerySnapshot querySnapshot = await surveyCollection.get();
      List<QueryDocumentSnapshot> docs = querySnapshot.docs;

      for (var doc in docs) {
        QuestionResponses questionResponse = QuestionResponses(
          transport: doc['transport'] ?? '',
          flightsYear: doc['flights_year'] ?? '',
          shoppingMode: doc['shopping_mode'] ?? '',
          energySourceHome: doc['energy_source_home'] ?? '',
          ledBulbs: doc['LED_bulbs'] ?? '',
          energyIntensiveAppliances: doc['energy_intensive_appliances'] ?? '',
          proteinSource: doc['protein_source'] ?? '',
          waterUsage: doc['water_usage'] ?? '',
          recycleWaste: doc['recycle_waste'] ?? '',
          eWasteRecycle: doc['E-waste_recycle'] ?? '',
        );

        questionResponses.add(questionResponse);
      }
    } catch (e) {
      print('Error retrieving answers: $e');
    }
  }

  double calculateFootprints(List<String?> questionResponses) {
    if (questionResponses.length != 10) {
      return 0.0;
    }

    double travelFootprints =
        (getEmissionValue(questionResponses[0]?.toString() ?? '1', 0)) * 40 +
            (getEmissionValue(questionResponses[1]?.toString() ?? '1', 1)) *
                30 +
            getEmissionValue(questionResponses[2]?.toString() ?? '1', 2) * 20;
    double houseHoldFootprints =
        getEmissionValue(questionResponses[3]?.toString() ?? '1', 3) * 30 +
            getEmissionValue(questionResponses[4]?.toString() ?? '1', 4) * 20 +
            getEmissionValue(questionResponses[5]?.toString() ?? '1', 5) * 80;
    double foodFootprints =
        getEmissionValue(questionResponses[6]?.toString() ?? '1', 6) * 20;
    double recycleFootprints =
        (getEmissionValue(questionResponses[8]?.toString() ?? '1', 8)) * 10 +
            (getEmissionValue(questionResponses[9]?.toString() ?? '1', 9)) * 3;

    double totalCarbon = travelFootprints +
        houseHoldFootprints +
        foodFootprints +
        recycleFootprints;

    print("Total carbon footprint: $totalCarbon");
    return totalCarbon;
  }

  double getEmissionValue(String responseIndex, int sectionIndex) {
    int parsedIndex = int.tryParse(responseIndex) ?? 0;
    if (parsedIndex >= 0 && parsedIndex < emissions[sectionIndex].length) {
      return emissions[sectionIndex][parsedIndex];
    }
    return 0.0;
  }
}
