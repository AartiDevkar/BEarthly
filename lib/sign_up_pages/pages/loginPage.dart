import 'dart:ui';

import 'package:bearthly/carbonTrack/home_page.dart';
import 'package:bearthly/sign_up_pages/components/my_button.dart';
import 'package:bearthly/sign_up_pages/components/my_textfield.dart';
import 'package:bearthly/sign_up_pages/components/square_tile.dart';
import 'package:bearthly/sign_up_pages/pages/signUp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  User? _user;

  final double _sigmaX = 5;
  // from 0-10
  final double _sigmaY = 4;
  // from 0-10
  final double _opacity = 0.2;

  final _formKey = GlobalKey<FormState>();

  // sign user in method
  void signUserIn() async {
    try {
      if (_formKey.currentState!.validate()) {
        final FirebaseAuth _auth = FirebaseAuth.instance;
        final UserCredential userCredential =
            await _auth.signInWithEmailAndPassword(
          email: usernameController.text,
          password: passwordController.text,
        );
        // Store the authenticated user in the _user variable
        _user = userCredential.user;

        if (_user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      // Show an error message using a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'An error occurred.'),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print("login error:$e");
      }
    }
  }

  Future<void> resetPassword() async {
    final email = usernameController.text;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent. Check your inbox.'),
        ),
      );
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset failed: $e'),
        ),
      );
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<void> _handleGoogleSignIn() async {
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/bg1.png',
                width: screenWidth,
                height: screenHeight,
                fit: BoxFit.cover,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.01),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.20),
                    child: const Text("BEarthly",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: screenHeight * 0.13),
                  SizedBox(height: screenHeight * 0.03),
                  Builder(builder: (context) {
                    return ClipRect(
                      child: BackdropFilter(
                        filter:
                            ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02),
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(0, 0, 0, 1)
                                  .withOpacity(_opacity),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30))),
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.63,
                          child: Form(
                            key: _formKey,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // username textfield
                                  MyTextField(
                                    controller: usernameController,
                                    hintText: 'Email',
                                    obscureText: false,
                                  ),

                                  const SizedBox(height: 5),

                                  // password textfield
                                  MyPasswordTextField(
                                    controller: passwordController,
                                    hintText: 'Password',
                                    obscureText: true,
                                  ),

                                  const SizedBox(height: 10),

                                  // login  button
                                  MyButton(
                                    onTap: () => signUserIn(),
                                  ),

                                  const SizedBox(height: 30),
                                  // Add this GestureDetector for "Forgot Password?"
                                  GestureDetector(
                                    onTap: () {
                                      resetPassword();
                                    },
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 71, 233, 133),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),

                                  // or continue with
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          thickness: 0.5,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(
                                          'Or',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          thickness: 0.5,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 5),

                                  // google
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // facebook button

                                        SizedBox(height: 5),

                                        // google button
                                        SquareTile(
                                          imagePath: 'assets/images/google.png',
                                          title: "Continue with Google",
                                          onPressed: _handleGoogleSignIn,
                                        ),

                                        SizedBox(height: 5),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  // not a member? register now
                                  GestureDetector(
                                    onTap: () {
                                      // Navigate to the sign-up page when "Sign Up" text is clicked
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Signup(),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Don\'t have an account?',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                'Sign Up',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 71, 233, 133),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: screenHeight * 0.01,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
