import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class Connect extends StatefulWidget {
  const Connect({Key? key}) : super(key: key);

  @override
  State<Connect> createState() => _ConnectState();
}

class _ConnectState extends State<Connect> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int currentIndex = 3;

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      // Navigate to the login or onboarding screen
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Function to launch a URL
  _launchURL(String url) async {
    try {
      Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  // Placeholder function for sharing achievements

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect'),
        backgroundColor: const Color.fromARGB(255, 191, 228, 228),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            PostItem(
              imageUrl:
                  'https://im.whatshot.in/img/2020/Jun/istock-1130655067-cropped-1591265020.jpg',
              onConnect: () {
                // Implement logic to display contact information on Connect click
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Contact Information'),
                    content: const Text('Contact information goes here.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              onKnowMore: () {
                // Launch the NGO's/org's website on Know More click
                _launchURL('https://www.greenyatra.org/');
              },
            ),
            PostItem(
              imageUrl:
                  'https://lifesup.com.vn/wp-content/uploads/2022/10/4-min.png',
              onConnect: () {
                // Implement logic to display contact information on Connect click
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Contact Information'),
                    content: const Text('Contact information goes here.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              onKnowMore: () {
                // Launch the NGO's/org's website on Know More click
                _launchURL('https://www.greenyatra.org/');
              },
            ),
            PostItem(
              imageUrl:
                  'https://climatefactchecks.org/wp-content/uploads/2023/06/image-4-300x169.png',
              onConnect: () {
                // Implement logic to display contact information on Connect click
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Contact Information'),
                    content: const Text('Contact information goes here.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              onKnowMore: () {
                // Launch the NGO's/org's website on Know More click
                _launchURL('https://www.greenyatra.org/');
              },
            ),
            PostItem(
              imageUrl: 'https://waidy.it/img/post/how-to-reduce-pollution.jpg',
              onConnect: () {
                // Implement logic to display contact information on Connect click
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Contact Information'),
                    content: const Text('Contact information goes here.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              onKnowMore: () {
                // Launch the NGO's/org's website on Know More click
                _launchURL('https://www.greenyatra.org/');
              },
            ),
            PostItem(
              imageUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSoubd5-3h4hmQdLukAtoTpia5ATxwnj4WULM_v41pJ9AUQ6jKygyW7mPqHWcT_ufyfSI&usqp=CAU',
              onConnect: () {
                // Implement logic to display contact information on Connect click
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Contact Information'),
                    content: const Text('Contact information goes here.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              onKnowMore: () {
                // Launch the NGO's/org's website on Know More click
                _launchURL('https://www.greenyatra.org/');
              },
            ),
            // Add more PostItem widgets with different image URLs as needed
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
          // Navigate to the corresponding page when an icon is tapped
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/');
              break;
            case 1:
              Navigator.pushNamed(context, '/track');
              break;
            case 2:
              Navigator.pushNamed(context, '/reduce');
              break;
            case 3:
              // Navigator.pushNamed(context, '/connect');
              break;
          }
        },
        selectedItemColor: const Color.fromARGB(255, 20, 137, 135),
        unselectedItemColor: const Color.fromARGB(255, 121, 154, 203),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_downward),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recycling),
            label: 'Reduce',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_rounded),
            label: 'Connect',
          ),
        ],
      ),
    );
  }
}

class PostItem extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onConnect;
  final VoidCallback onKnowMore;

  const PostItem({
    Key? key,
    required this.imageUrl,
    required this.onConnect,
    required this.onKnowMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 121, 203, 195),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
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
            ],
          ),
        ],
      ),
    );
  }
}
