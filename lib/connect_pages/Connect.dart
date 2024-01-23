// Import necessary packages
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

class Connect extends StatefulWidget {
  const Connect({Key? key}) : super(key: key);

  @override
  State<Connect> createState() => _ConnectState();
}

class _ConnectState extends State<Connect> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      // Navigate to the login or onboarding screen
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Function to launch a URL
  _launchURL(String url) async {
    if (await canLaunch("")) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Function to share achievements on social media
  _shareAchievement() {
    // Implement the logic to share achievements on social media here
    // You can use packages like share_plus to facilitate sharing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect'),
        backgroundColor: Color.fromARGB(255, 191, 228, 228),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Container(
        color: Color.fromRGBO(8, 128, 90, 0.833),
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            PostItem(
              imageUrl:
                  'https://images.yourstory.com/cs/2/628912e0d7f211eb8e8307e5b6451cf7/Carbonneutral-1659616776710.png',
              onConnect: () {
                // Implement logic to display contact information on Connect click
                print('Connect clicked - Display contact info');
              },
              onKnowMore: () {
                // Launch the NGO's/org's website on Know More click
                _launchURL('https://ngo-website.com');
              },
              onShare: () {
                // Share the achievement on social media
                _shareAchievement();
              },
            ),
            // Add more PostItem widgets with different image URLs as needed
          ],
        ),
      ),
    );
  }
}

class PostItem extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onConnect;
  final VoidCallback onKnowMore;
  final VoidCallback onShare;

  const PostItem({
    Key? key,
    required this.imageUrl,
    required this.onConnect,
    required this.onKnowMore,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton<String>(
                iconColor: Color.fromARGB(255, 191, 228, 228),
                color: Color.fromARGB(255, 191, 228, 228),
                itemBuilder: (BuildContext context) {
                  return ['Connect', 'Know More'].map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
                onSelected: (String choice) {
                  // Handle menu item selection
                  if (choice == 'Connect') {
                    onConnect();
                  } else if (choice == 'Know More') {
                    onKnowMore();
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: onShare,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
