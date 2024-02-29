import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
        'https://content.guardianapis.com/search?q=environment&api-key=b126f04a-4f03-4739-ae31-d92fc5bbfcc0';

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
                                final thumbnailUrl = article['thumbnail'];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ArticleDetailsPage(
                                                article: article),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 250,
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    child: Stack(
                                      children: [
                                        if (thumbnailUrl != null &&
                                            thumbnailUrl.isNotEmpty)
                                          Image.network(
                                            thumbnailUrl,
                                            height: 200,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        if (thumbnailUrl == null ||
                                            thumbnailUrl.isEmpty)
                                          Container(
                                            color: Colors.grey,
                                            height: 200,
                                            width: double.infinity,
                                            child: Center(
                                              child: Icon(
                                                Icons.image,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            ),
                                          ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            color: Colors.black54,
                                            child: Text(
                                              article['webTitle'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
                              final thumbnailUrl = article['thumbnail'];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ArticleDetailsPage(article: article),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 8,
                                  margin: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      if (thumbnailUrl != null &&
                                          thumbnailUrl.isNotEmpty)
                                        Image.network(
                                          thumbnailUrl,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      if (thumbnailUrl == null ||
                                          thumbnailUrl.isEmpty)
                                        SizedBox(
                                          height: 200,
                                          child: Center(
                                            child: Icon(
                                              Icons.image,
                                              size: 40,
                                            ),
                                          ),
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          article['webTitle'],
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Text(
                                          article['webPublicationDate'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
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
}

class ArticleDetailsPage extends StatelessWidget {
  final dynamic article;

  const ArticleDetailsPage({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = article['thumbnail'];
    return Scaffold(
      appBar: AppBar(
        title: Text(article['webTitle']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (thumbnailUrl != null && thumbnailUrl.isNotEmpty)
                Image.network(
                  thumbnailUrl,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 16),
              Text(
                article['webPublicationDate'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 16),
              Text(
                article['webTitle'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              if (article['fields'] != null &&
                  article['fields']['body'] != null)
                Text(
                  article['fields']['body'],
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
              else
                Text(
                  'No article content available',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
