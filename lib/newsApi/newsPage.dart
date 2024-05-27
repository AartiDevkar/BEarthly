import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as customTabs;

class EnvironmentArticlesPage extends StatefulWidget {
  @override
  _EnvironmentArticlesPageState createState() =>
      _EnvironmentArticlesPageState();
}

class _EnvironmentArticlesPageState extends State<EnvironmentArticlesPage> {
  List<dynamic> articles = [];
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchEnvironmentArticles();
  }

  Future<void> fetchEnvironmentArticles() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final String apiUrl =
        'https://content.guardianapis.com/search?q=environment&api-key=apikey';

    try {
      final http.Response response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          articles = data['response']['results'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to fetch environment articles: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching environment articles: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 191, 228, 228),
        title: Text('Environment Articles'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : articles.isEmpty
                  ? Center(child: Text('No articles found'))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Latest Environment News',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: articles.length,
                              itemBuilder: (context, index) {
                                final article = articles[index];
                                return GestureDetector(
                                  onTap: () {
                                    _launchURL(article['webUrl']);
                                  },
                                  child: Container(
                                    width: 250,
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 97, 188, 123),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        article['webTitle'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Recent Articles',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: articles.length,
                            itemBuilder: (context, index) {
                              final article = articles[index];
                              return GestureDetector(
                                onTap: () {
                                  _launchURL(article['webUrl']);
                                },
                                child: Card(
                                  elevation: 8,
                                  margin: EdgeInsets.all(16),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          article['webTitle'],
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          article['webPublicationDate'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
    );
  }

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    try {
      await customTabs.launchUrl(uri);
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}
