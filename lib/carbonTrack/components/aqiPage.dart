import 'dart:convert';
import 'package:flutter/material.dart';
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
    const apiKey = '4208741947349e4b8565338e4d4427de74fa0c4b';
    const apiUrl = 'https://api.waqi.info/feed/here/?token=$apiKey';

    try {
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
    if (aqi <= 50) {
      return Colors.green;
    } else if (aqi <= 100) {
      return Colors.yellow;
    } else if (aqi <= 150) {
      return Color.fromARGB(255, 231, 163, 29);
    } else if (aqi <= 200) {
      return Colors.red;
    } else if (aqi <= 300) {
      return Colors.purple;
    } else {
      return Colors.brown;
    }
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
              height: 570,
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
                                height: 300,
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
                                        fontSize: 20,
                                        color: Colors.white,
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
                                  children: List.generate(6, (index) {
                                    return _buildAQILegendItem(index * 50);
                                  }),
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

  Widget _buildAQILegendItem(int aqi) {
    Color color = getAqiColor(aqi);
    String level;
    if (aqi == 0) {
      level = 'Good';
    } else if (aqi == 50) {
      level = 'Moderate';
    } else if (aqi == 100) {
      level = 'Unhealthy for Sensitive Groups';
    } else if (aqi == 150) {
      level = 'Unhealthy';
    } else if (aqi == 200) {
      level = 'Very Unhealthy';
    } else {
      level = 'Hazardous';
    }

    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          color: color,
        ),
        SizedBox(height: 5),
        Text(
          '$aqi - ${(aqi + 50).toString()}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          level,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
