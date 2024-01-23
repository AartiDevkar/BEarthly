import 'package:bearthly/carbonTrack/home_page.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  // User? _user;
  // final _formKey = GlobalKey<FormState>();

  // Initialize the BuildContext variable
  late BuildContext context;

  // Pass the context to the controller
  LoginController(this.context);

  // void signUserIn() async {
  //   try {
  //     if (_formKey.currentState!.validate()) {
  //       final BuildContext currentContext = context; // Capture context locally

  //       final FirebaseAuth _auth = FirebaseAuth.instance;
  //       final UserCredential userCredential =
  //           await _auth.signInWithEmailAndPassword(
  //         email: usernameController.text,
  //         password: passwordController.text,
  //       );

  //       _user = userCredential.user;

  //       if (_user != null) {
  //         // Use the locally captured context
  //         Navigator.pushReplacement(
  //           currentContext,
  //           MaterialPageRoute(builder: (currentContext) => const HomePage()),
  //         );
  //       } else {
  //         print("User authentication failed. _user is null.");
  //         ScaffoldMessenger.of(currentContext).showSnackBar(
  //           SnackBar(
  //             content: Text('User authentication failed. Please try again.'),
  //           ),
  //         );
  //       }
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(e.message ?? 'An error occurred.'),
  //       ),
  //     );
  //   } catch (e, stackTrace) {
  //     if (kDebugMode) {
  //       print("Login error: $e");
  //       print("StackTrace: $stackTrace");
  //     }
  //   }
  // }

  // Future<void> resetPassword() async {
  //   final email = usernameController.text;
  //   try {
  //     await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  //     // Show a success message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Password reset email sent. Check your inbox.'),
  //       ),
  //     );
  //   } catch (e) {
  //     // Show an error message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Password reset failed: $e'),
  //       ),
  //     );
  //   }
  // }

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<void> handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);

        final User? user = authResult.user;

        if (user != null) {
          // User signed in with Google
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      }
    } catch (e) {
      print('Google Sign-In Error: $e');
      // Show an error message using a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Sign-In failed. Please try again.'),
          backgroundColor: Color.fromARGB(255, 231, 109, 100),
        ),
      );
    }
  }
}
