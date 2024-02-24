import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuestionResponses {
  late String transport;
  late String distanceTraveled;
  late String flightsYear;
  late String shoppingMode;
  late String energySourceHome;
  late String ledBulbs;
  late String energyIntensiveAppliances;
  late String proteinSource;
  late String recycleWaste;
  late String eWasteRecycle;

  QuestionResponses({
    required this.transport,
    required this.distanceTraveled,
    required this.flightsYear,
    required this.shoppingMode,
    required this.energySourceHome,
    required this.ledBulbs,
    required this.energyIntensiveAppliances,
    required this.proteinSource,
    required this.recycleWaste,
    required this.eWasteRecycle,
  });
}

class CarbonCalculator {
  late BuildContext context;

  List<QuestionResponses> questionResponses = [];

  double totalCarbonFootprint = 0.0;
  double travelFootprints = 0.0;
  double flightsFootprints = 0.0;
  double shoppingFootprints = 0.0;
  double houseHoldFootprints = 0.0;
  double foodFootprints = 0.0;
  double recycleFootprints = 0.0;

  CarbonCalculator(this.context);

  static final List<List<double>> emissions = [
    [0.05, 0.1, 0.02], // Transport type (example: kg CO2 per km traveled)
    [0, 50, 200, 350, 400], // Distance traveled
    [0, 0.2, 0.3, 0.4, 0.5], // Flights (example: kg CO2 per passenger-km)
    [0, 0.02, 0.03, 0.05], // Shopping (example: kg CO2 per dollar spent)
    [0, 0.1, 0.15, 0.2], // Energy sources (example: kg CO2 per kWh)
    [0, 0.01, 0.02], // LED bulbs (example: kg CO2 per hour of use)
    [0, 0.05, 0.1, 0.2, 0.0], // Appliances (example: kg CO2 per hour of use)
    [
      0,
      0.02,
      0.015,
      0.01,
      0.005
    ], // Protein sources (example: kg CO2 per gram of protein)
    [
      0,
      0.001,
      0.002,
      0.003,
      0.004
    ], // Recycle (example: kg CO2 per item recycled)
    [
      0,
      0.005,
      0.01,
      0.015,
      0.02
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
          distanceTraveled: doc['distance_traveled'] ?? '',
          shoppingMode: doc['shopping_mode'] ?? '',
          energySourceHome: doc['energy_source_home'] ?? '',
          ledBulbs: doc['LED_bulbs'] ?? '',
          energyIntensiveAppliances: doc['energy_intensive_appliances'] ?? '',
          proteinSource: doc['protein_source'] ?? '',
          // waterUsage: doc['water_usage'] ?? '',
          recycleWaste: doc['recycle_waste'] ?? '',
          eWasteRecycle: doc['E-waste_recycle'] ?? '',
        );

        questionResponses.add(questionResponse);
      }
    } catch (e) {
      print('Error retrieving answers: $e');
    }
  }

  List calculateFootprints(List<String?> questionResponses) {
    if (questionResponses.length != 10) {
      return [];
    }

    // Calculate travel footprints based on user's inputs for transportation method and distance traveled
    int transportIndex =
        int.tryParse(questionResponses[0]?.toString() ?? '0') ?? 0;
    print(transportIndex);

    if (transportIndex == 1) {
      // Public Transport
      travelFootprints = getEmissionValue('0', 0) *
          getEmissionValue(
              questionResponses[1]?.toString() ?? '1', 1); //distance

      print((getEmissionValue(questionResponses[1]?.toString() ?? '1', 1)));
    } else if (transportIndex == 2) {
      // Car/Bike
      travelFootprints = getEmissionValue('1', 0) *
          getEmissionValue(
              questionResponses[1]?.toString() ?? '1', 1); //distance
      print((getEmissionValue(questionResponses[1]?.toString() ?? '1', 1)));
    } else if (transportIndex == 3) {
      // Cycle/Walking
      travelFootprints = getEmissionValue('2', 0) *
          getEmissionValue(
              questionResponses[1]?.toString() ?? '1', 1); //distance
      print((getEmissionValue(questionResponses[1]?.toString() ?? '1', 1)));
    }
    // Calculate flights footprints based on user's input for the number of flights per year
    int flightsIndex =
        int.tryParse(questionResponses[2]?.toString() ?? '0') ?? 0;

    print(flightsIndex);

    if (flightsIndex == 0) {
      // None
      flightsFootprints = 0.0;
    } else if (flightsIndex == 1) {
      // 1-2 times
      flightsFootprints =
          getEmissionValue(questionResponses[2]?.toString() ?? '1', 2) *
              500; // Assuming average distance of 500 km per flight
      print(getEmissionValue(questionResponses[2]?.toString() ?? '1', 2));
    } else if (flightsIndex == 2) {
      // 3-5 times
      flightsFootprints = getEmissionValue('2', 2) *
          500; // Assuming average distance of 500 km per flight
      print(getEmissionValue('2', 2));
    } else if (flightsIndex == 3) {
      // More than 5 times
      flightsFootprints = getEmissionValue('3', 2) *
          500; // Assuming average distance of 500 km per flight
      print(getEmissionValue('3', 2));
    }

    int shoppingIndex =
        int.tryParse(questionResponses[3]?.toString() ?? '0') ?? 0;

    // Calculate shopping footprints based on user's input for shopping mode
    if (shoppingIndex == 1) {
      // Online shopping
      shoppingFootprints =
          (getEmissionValue(questionResponses[3]?.toString() ?? '1', 3) *
              50); // Assuming average spending of $50
    } else if (shoppingIndex == 2) {
      // Local stores
      shoppingFootprints =
          (getEmissionValue(questionResponses[3]?.toString() ?? '2', 3) *
              30); // Assuming average spending of $30
    } else if (shoppingIndex == 3) {
      // Thrift stores
      shoppingFootprints =
          (getEmissionValue(questionResponses[3]?.toString() ?? '3', 3) *
              20); // Assuming average spending of $20
    } else if (shoppingIndex == 4) {
      // No shopping
      shoppingFootprints = 0.0;
    }
    print("shopping: ,$shoppingFootprints");

    // Calculate energy footprints based on user's inputs for energy sources and appliances
    int energySourceIndex =
        int.tryParse(questionResponses[4]?.toString() ?? '0') ?? 0;
    int ledBulbsIndex =
        int.tryParse(questionResponses[5]?.toString() ?? '0') ?? 0;
    int appliancesIndex =
        int.tryParse(questionResponses[6]?.toString() ?? '0') ?? 0;

    print(energySourceIndex);
    print(ledBulbsIndex);
    print(appliancesIndex);
// Assuming average energy usage per day
    double energyUsage = 10; // kWh

// Assuming average LED bulbs usage per day
    double ledBulbsUsage = 4; // hours

// Assuming average appliances usage per day
    double appliancesUsage = 8; // hours

    double energy_sources = 0.0;
    double energy_led = 0.0;
    double energy_appliance = 0.0;

// Calculate energy footprints based on user's inputs for energy sources
    energy_sources +=
        getEmissionValue(questionResponses[4]?.toString() ?? '0', 4) *
            energyUsage;
    print("energy from sources,$energy_sources");
// Calculate energy footprints based on user's inputs for LED bulbs
    energy_led += getEmissionValue(questionResponses[5]?.toString() ?? '0', 5) *
        ledBulbsUsage;
    print("energy from led,$energy_led");
// Calculate energy footprints based on user's inputs for appliances
    energy_appliance +=
        getEmissionValue(questionResponses[6]?.toString() ?? '0', 6) *
            appliancesUsage;
    print("energy from appliance,$energy_appliance");
    houseHoldFootprints = energy_sources + energy_appliance + energy_led;
    print("household,$houseHoldFootprints");
    // double travelFootprints =
    //     (getEmissionValue(questionResponses[0]?.toString() ?? '1', 0)) +
    //         (getEmissionValue(questionResponses[1]?.toString() ?? '1', 1)) +
    //         getEmissionValue(questionResponses[2]?.toString() ?? '1', 2);

    // double energyFootprints =
    //     (getEmissionValue(questionResponses[4]?.toString() ?? '1', 4) +
    //         getEmissionValue(questionResponses[5]?.toString() ?? '1', 5) +
    //         getEmissionValue(questionResponses[6]?.toString() ?? '1', 6));

    //// Average protein intake per day (in grams) double proteinIntake = 50; // Assume 50 grams per day
    double foodFootprints =
        getEmissionValue(questionResponses[7]?.toString() ?? '1', 7) * 50;

    double recycleFootprints =
        (getEmissionValue(questionResponses[8]?.toString() ?? '1', 8)) +
            (getEmissionValue(questionResponses[9]?.toString() ?? '1', 9));

    double totalCarbon = travelFootprints +
        flightsFootprints +
        shoppingFootprints +
        houseHoldFootprints +
        foodFootprints +
        recycleFootprints;
    print("Total carbon footprint: $totalCarbon");
    print("Travel carbon footprint: $travelFootprints");
    print("flights carbon footprint: $flightsFootprints");
    print("Energy usage carbon footprint: $houseHoldFootprints");
    print("Food carbon footprint: $foodFootprints");
    print("shopping carbon footprint: $shoppingFootprints");
    print("Recycle carbon footprint: $recycleFootprints");

    return [
      totalCarbon,
      travelFootprints,
      flightsFootprints,
      houseHoldFootprints,
      foodFootprints,
      shoppingFootprints,
      recycleFootprints
    ];
  }

// // Calculate daily footprints
// Map<String, double> calculateDailyFootprints() {
//   double dailyShoppingFootprints =
//       (getEmissionValue(questionResponses[3].toString(), 3));
//   double dailyEnergyFootprints =
//       getEmissionValue(questionResponses[4].toString(), 4) +
//           getEmissionValue(questionResponses[5].toString(), 5) +
//           getEmissionValue(questionResponses[6].toString(), 6);
//   double dailyFoodFootprints =
//       getEmissionValue(questionResponses[7].toString(), 7);
//   double dailyRecycleFootprints =
//       getEmissionValue(questionResponses[8].toString(), 8) +
//           getEmissionValue(questionResponses[9].toString(), 9);
//   double totaldailyCarbon = travelFootprints +
//       flightsFootprints +
//       dailyEnergyFootprints +
//       dailyFoodFootprints +
//       dailyRecycleFootprints +
//       dailyShoppingFootprints;
//   print(totaldailyCarbon);
//   return {
//     'Shopping': dailyShoppingFootprints,
//     'Energy': dailyEnergyFootprints,
//     'Food': dailyFoodFootprints,
//     'Recycle': dailyRecycleFootprints,
//   };
// }

// // Calculate weekly footprints
// Map<String, double> calculateWeeklyFootprints() {
//   Map<String, double> dailyFootprints = calculateDailyFootprints();
//   return dailyFootprints.map((key, value) => MapEntry(key, value * 7));
// }

// // Calculate monthly footprints
// Map<String, double> calculateMonthlyFootprints() {
//   Map<String, double> dailyFootprints = calculateDailyFootprints();
//   return dailyFootprints.map((key, value) => MapEntry(key, value * 30));
// }

// // Calculate yearly footprints
// Map<String, double> calculateYearlyFootprints() {
//   Map<String, double> dailyFootprints = calculateDailyFootprints();
//   return dailyFootprints.map((key, value) => MapEntry(key, value * 365));
// }

  double getEmissionValue(String responseIndex, int sectionIndex) {
    int parsedIndex = int.tryParse(responseIndex) ?? 0;
    if (parsedIndex >= 0 && parsedIndex < emissions[sectionIndex].length) {
      return emissions[sectionIndex][parsedIndex];
    }
    return 0.0;
  }
}
