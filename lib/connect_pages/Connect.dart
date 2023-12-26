import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        color: Color.fromRGBO(8, 128, 90, 0.833), // Dark theme background color
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            PostItem(
              imageUrl:
                  'https://images.yourstory.com/cs/2/628912e0d7f211eb8e8307e5b6451cf7/Carbonneutral-1659616776710.png', // Sample image URL
            ),
            PostItem(
              imageUrl:
                  'https://www.seattleu.edu/media/newsroom/images/ClimateAction-1130x552.png', // Sample image URL
            ),
            PostItem(
              imageUrl:
                  'https://content.unops.org/photos/News-and-Stories/News/_image1920x900/header_2795x1310_dark.png', // Sample image URL
            ),
            PostItem(
              imageUrl:
                  'https://content.unops.org/photos/News-and-Stories/News/_image1920x900/header_2795x1310_dark.png', // Sample image URL
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

  const PostItem({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900], // Dark color for post container
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post image
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(imageUrl), // Set image URL
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Popup menu button
              PopupMenuButton<String>(
                iconColor: Color.fromARGB(255, 191, 228, 228),
                color: Color.fromARGB(255, 191, 228, 228),
                itemBuilder: (BuildContext context) {
                  return ['Chat', 'Connect', 'Know More'].map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
                onSelected: (String choice) {
                  // Handle menu item selection
                  print(choice);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
