import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _allowNotifications = false;

  void _updateNotificationPermission(bool newValue) {
    // Update the user's notification permission here
    // For demonstration purposes, just print the new value
    print('Notification permission updated: $newValue');
    setState(() {
      _allowNotifications = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Allow Notifications',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _allowNotifications
                        ? 'You are currently allowing notifications'
                        : 'You are currently not allowing notifications',
                  ),
                ),
                Switch(
                  activeColor: Colors.green,
                  value: _allowNotifications,
                  onChanged: _updateNotificationPermission,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
