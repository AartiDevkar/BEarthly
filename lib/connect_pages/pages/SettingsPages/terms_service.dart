import 'package:flutter/material.dart';

class TermsServicePage extends StatefulWidget {
  const TermsServicePage({Key? key}) : super(key: key);

  @override
  State<TermsServicePage> createState() => _TermsServicePageState();
}

class _TermsServicePageState extends State<TermsServicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              "These Terms of Service ('Terms') govern your use of the mobile application Barthly operated by Aarti Devkar.\n\n"
              "By accessing or using the App, you agree to be bound by these Terms. If you disagree with any part of the terms, then you may not access the App.\n\n"
              "Content\n"
              "The content provided in the App is for general information and awareness purposes only. We do not guarantee the accuracy, completeness, or suitability of the content. Your use of any information or materials in the App is at your own risk.\n\n"
              "Privacy\n"
              "Your privacy is important to us. Please review our Privacy Policy to understand how we collect, use, and disclose personal information.\n\n"
              "User Accounts\n"
              "To access certain features of the App, you may be required to create an account. You are responsible for maintaining the confidentiality of your account and password and for restricting access to your device. You agree to accept responsibility for all activities that occur under your account or password.\n\n"
              "Intellectual Property\n"
              "The App and its original content, features, and functionality are owned by Aarti Devkar and are protected by international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights laws.\n\n"
              "Prohibited Uses\n"
              "You may not use the App for any unlawful purpose or to violate any laws in your jurisdiction. You may not attempt to gain unauthorized access to any portion of the App, or to any systems or networks connected to the App.\n\n"
              "Changes to Terms\n"
              "We reserve the right to modify these Terms at any time. By continuing to access or use the App after we post any modifications to these Terms, you agree to be bound by the modified terms. If you do not agree to the new terms, please stop using the App.\n\n"
              "Contact Us\n"
              "If you have any questions about these Terms, please contact us at info_bearthly@gmail.com.",
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
