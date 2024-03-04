import 'package:flutter/material.dart';

class PrivacySecurityPage extends StatefulWidget {
  const PrivacySecurityPage({Key? key}) : super(key: key);

  @override
  State<PrivacySecurityPage> createState() => _PrivacySecurityPageState();
}

class _PrivacySecurityPageState extends State<PrivacySecurityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy and Security'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy and Security',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              "Your privacy and security are important to us. This Privacy Policy explains how we collect, use, and disclose information about you when you use our mobile application .\n\n"
              "Information Collection and Use\n"
              "We collect information from you when you use the App, including personal information such as your name, email address, and device ID. We use this information to provide and improve the App, and to communicate with you.\n\n"
              "Data Security\n"
              "We take reasonable measures to protect your information from unauthorized access, alteration, or destruction. However, no method of transmission over the internet or electronic storage is 100% secure, so we cannot guarantee its absolute security.\n\n"
              "Data Sharing\n"
              "We may share your information with third-party service providers who assist us in operating the App, conducting our business, or serving you. We may also share aggregated or de-identified information that cannot reasonably be used to identify you.\n\n"
              "Changes to Privacy Policy\n"
              "We reserve the right to update or change our Privacy Policy at any time. Your continued use of the App after we post any modifications to the Privacy Policy will constitute your acknowledgment of the changes and your consent to abide and be bound by the modified Privacy Policy.\n\n"
              "Contact Us\n"
              "If you have any questions about our Privacy Policy, please contact us at info_bearthly@gmail.com.",
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
