import 'package:bearthly/notifications/local_notifications.dart';
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
    if (newValue = true) {
      LocalNotifications.showPeriodicNotifications(
          title: 'BEarthly',
          body: 'Review your carbon footprints',
          payload: 'data');
      print('Notification permission updated: $newValue');
    } else {
      LocalNotifications.close();
    }

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
