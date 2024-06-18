import 'dart:convert';

import 'package:http/http.dart' as http;

// Define base URL
const String baseUrl = 'https://content.guardianapis.com';

// Construct API request URL with query parameters
const String apiUrl =
    '$baseUrl/search?tag=environment/recycling|environment|plastic|nature|climatechange&api-key=your-api-key';

Future<void> fetchEnvironmentContent() async {
  try {
    // Make API request
    final http.Response response = await http.get(Uri.parse(apiUrl));

    // Check if request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse JSON response
      final Map<String, dynamic> data = jsonDecode(response.body);
      // Access and process the fetched data here
      print('Environment content: $data');
    } else {
      // Handle unsuccessful request
      print('Failed to fetch environment content: ${response.statusCode}');
    }
  } catch (e) {
    // Handle errors
    print('Error fetching environment content: $e');
  }
}
