import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
            child: Text(
              'My App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Option 1'),
            onTap: () {
              // Handle option 1
            },
          ),
          ListTile(
            title: Text('Option 2'),
            onTap: () {
              // Handle option 2
            },
          ),
          ListTile(
            title: Text('Option 3'),
            onTap: () {
              // Handle option 3
            },
          ),
          Divider(),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              // Handle logout
              Navigator.pop(context); // Close the drawer
              // Call your logout function or navigate to the logout screen
            },
          ),
        ],
      ),
    );
  }
}
