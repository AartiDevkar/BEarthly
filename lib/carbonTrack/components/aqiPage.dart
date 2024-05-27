import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class AirQualityPage extends StatefulWidget {
  @override
  _AirQualityPageState createState() => _AirQualityPageState();
}

class _AirQualityPageState extends State<AirQualityPage> {
  int? aqi;
  String? city;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchAirQualityData();
  }

  Future<void> fetchAirQualityData() async {
    const apiKey = 'apikey';

    try {
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Fetch air quality data using current location
      String apiUrl =
          'https://api.waqi.info/feed/geo:${position.latitude};${position.longitude}/?token=$apiKey';

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body)['data'];
        setState(() {
          aqi = responseData['aqi'];
          city = responseData['city']['name'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to fetch air quality data: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching air quality data: $e';
        isLoading = false;
      });
    }
  }

  Color getAqiColor(int aqi) {
    if (aqi >= 0 && aqi <= 50) {
      return Colors.green;
    } else if (aqi >= 51 && aqi <= 100) {
      return Colors.yellow;
    } else if (aqi >= 101 && aqi <= 150) {
      return Color.fromARGB(255, 231, 123, 29);
    } else if (aqi >= 151 && aqi <= 200) {
      return Colors.red;
    } else if (aqi >= 201 && aqi <= 300) {
      return Color.fromARGB(255, 142, 22, 50);
    } else {
      return Color.fromARGB(255, 78, 4, 70);
    }
  }

  String getLevel(int aqi) {
    if (aqi >= 0 && aqi <= 50) {
      return 'Good';
    } else if (aqi >= 51 && aqi <= 100) {
      return 'Moderate';
    } else if (aqi >= 101 && aqi <= 150) {
      return 'Unhealthy for Sensitive Groups';
    } else if (aqi >= 151 && aqi <= 200) {
      return 'Unhealthy';
    } else if (aqi >= 201 && aqi <= 300) {
      return 'Very Unhealthy';
    } else {
      return 'Hazardous';
    }
  }

  Widget _buildAQILegendItem(int minAqi, int maxAqi) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          color: getAqiColor((minAqi + maxAqi) ~/ 2),
        ),
        SizedBox(height: 5),
        Text(
          '$minAqi - $maxAqi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          getLevel((minAqi + maxAqi) ~/ 2),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 176, 241, 222),
      appBar: AppBar(
        title: Text('AQI'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              height: 600,
              width: 350,
              child: Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : errorMessage != null
                        ? Center(child: Text(errorMessage!))
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(padding: EdgeInsets.all(5.0)),
                              Container(
                                height: 320,
                                width: 250,
                                padding: EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: getAqiColor(aqi!),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'AQI in $city: ${aqi.toString()}',
                                      style: TextStyle(
                                        fontSize: 30,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10),
                                    GestureDetector(
                                      child: Icon(
                                        Icons.refresh,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          isLoading = true;
                                          errorMessage = null;
                                        });
                                        fetchAirQualityData();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'AQI Legend:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Expanded(
                                child: GridView.count(
                                  crossAxisCount: 3,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    _buildAQILegendItem(0, 50), // Good
                                    _buildAQILegendItem(51, 100), // Moderate
                                    _buildAQILegendItem(101,
                                        150), // Unhealthy for Sensitive Groups
                                    _buildAQILegendItem(151, 200), // Unhealthy
                                    _buildAQILegendItem(
                                        201, 300), // Very Unhealthy
                                    _buildAQILegendItem(301, 500), // Hazardous
                                  ],
                                ),
                              ),
                            ],
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
