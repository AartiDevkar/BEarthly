import 'package:bearthly/connect_pages/data/ngos_data.dart';
import 'package:bearthly/connect_pages/data/ngos_model.dart';
import 'package:bearthly/connect_pages/pages/SettingsPages/settings.dart';
import 'package:bearthly/newsApi/newsPage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as customTabs;

class Connect extends StatefulWidget {
  const Connect({Key? key}) : super(key: key);

  @override
  State<Connect> createState() => _ConnectState();
}

class _ConnectState extends State<Connect> {
  int currentIndex = 3;
// Function to launch a URL
  _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    try {
      await customTabs.launchUrl(uri);
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const SettingsPage()), // Replace SettingsPage with your desired page
                );
              },
              icon: const Icon(Icons.settings))
          // IconButton(
          //   icon: const Icon(Icons.logout),
          //   onPressed: _signOut,
          // ),
        ],
      ),
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EnvironmentArticlesPage(),
              ),
            ),
            child: const Text('NEWS'),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: ngos.length,
            itemBuilder: (BuildContext context, int index) {
              return PostItem(
                ngo: ngos[index],
                onConnect: () {
                  showDialog(
                    context: context,
                    builder: (_) => NgoInfoDialog(
                      ngo: ngos[index],
                    ),
                  );
                },
                onKnowMore: () {
                  _launchURL(ngos[index].websiteUrl);
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
          // Navigate to the corresponding page when an icon is tapped
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/track');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/reduce');
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
  final NGO ngo;
  final VoidCallback onConnect;
  final VoidCallback onKnowMore;

  const PostItem({
    Key? key,
    required this.ngo,
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
                image: NetworkImage(ngo.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                ngo.ngoName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 135,
              ),
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

class NgoInfoDialog extends StatelessWidget {
  final NGO ngo;

  const NgoInfoDialog({Key? key, required this.ngo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('NGO Information'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NGO Name: ${ngo.ngoName}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Text('Contact Person: ${ngo.contactPerson}'),
          Row(children: [
            const Icon(
              Icons.email,
              size: 20.0,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(' ${ngo.email}'),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(
              Icons.phone,
              size: 20.0,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(' ${ngo.phoneNumber}'),
          ]),
          // Replace with actual phone number
          const SizedBox(height: 8),
          Row(children: [
            const Icon(
              Icons.location_on,
              size: 20.0,
            ),
            const SizedBox(
              width: 20,
            ),
            Text('${ngo.address}'),
          ]),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
