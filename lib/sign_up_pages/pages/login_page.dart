import 'dart:ui';
import 'package:bearthly/carbonTrack/home_page.dart';
import 'package:bearthly/sign_up_pages/components/my_button.dart';
import 'package:bearthly/sign_up_pages/components/my_textfield.dart';
import 'package:bearthly/sign_up_pages/components/square_tile.dart';
import 'package:bearthly/sign_up_pages/login_controller.dart';
import 'package:bearthly/sign_up_pages/pages/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final double _sigmaX = 5;
  // from 0-10
  final double _sigmaY = 4;
  // from 0-10
  final double _opacity = 0.2;

  User? _user;
  final _formKey = GlobalKey<FormState>();
  // Create an instance of LoginController
  late final LoginController _loginController;

  // Initialize LoginController in initState
  @override
  void initState() {
    super.initState();
    _loginController = LoginController(context);
  }

  void signUserIn() async {
    try {
      if (_formKey.currentState!.validate()) {
        final BuildContext currentContext = context; // Capture context locally

        final FirebaseAuth _auth = FirebaseAuth.instance;
        final UserCredential userCredential =
            await _auth.signInWithEmailAndPassword(
          email: usernameController.text,
          password: passwordController.text,
        );

        _user = userCredential.user;

        if (_user != null) {
          // Use the locally captured context
          Navigator.pushReplacement(
            currentContext,
            MaterialPageRoute(builder: (currentContext) => const HomePage()),
          );
        } else {
          print("User authentication failed. _user is null.");
          ScaffoldMessenger.of(currentContext).showSnackBar(
            SnackBar(
              content: Text('User authentication failed. Please try again.'),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'An error occurred.'),
        ),
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Login error: $e");
        print("StackTrace: $stackTrace");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 850,
                width: 450,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        stops: [
                      0.2,
                      0.5,
                      0.8,
                    ],
                        colors: [
                      Color.fromARGB(255, 20, 137, 135),
                      Color.fromARGB(255, 113, 189, 173),
                      Color.fromARGB(255, 105, 192, 178),
                    ])),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 90),
                    child: const Text("BEarthly",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  ClipRect(
                    child: BackdropFilter(
                      filter:
                          ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(0, 0, 0, 1)
                                .withOpacity(_opacity),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30))),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.63,
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

                                // username textfield
                                MyPasswordTextField(
                                    controller: passwordController,
                                    hintText: 'Password',
                                    obscureText: false),

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
                                      color: Color.fromARGB(255, 71, 233, 133),
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
                                            color: Colors.white, fontSize: 16),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // facebook button

                                      SizedBox(height: 5),

                                      // google button
                                      SquareTile(
                                        imagePath: 'assets/images/google.png',
                                        title: "Continue with Google",
                                        onPressed:
                                            _loginController.handleGoogleSignIn,
                                      ),

                                      const SizedBox(height: 5),
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
                                        builder: (context) =>
                                            Signup(), // Replace SignUpPage with the actual name of your sign-up page class
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
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
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
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
