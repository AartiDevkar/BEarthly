import 'dart:ui';
import 'package:bearthly/carbonTrack/home_page.dart';
import 'package:bearthly/sign_up_pages/components/my_button.dart';
import 'package:bearthly/sign_up_pages/components/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // text editing controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final double _sigmaX = 5;
  // from 0-10
  final double _sigmaY = 5;
  // from 0-10
  final double _opacity = 0.2;

  User? _user;
  final _formKey = GlobalKey<FormState>();

  void signUpUser() async {
    if (_formKey.currentState!.validate()) {
      // Validation passed
      if (passwordController.text != confirmPasswordController.text) {
        // If passwords don't match, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Passwords do not match"),
          ),
        );
        return;
      }

      try {
        final FirebaseAuth auth = FirebaseAuth.instance;
        final UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Store the authenticated user in the _user variable
        _user = userCredential.user;

        if (_user != null) {
          // Now, you can store the user's name separately
          String username = nameController.text;

          // Perform any additional actions with the user's name here
          // Example code to create a user document in Firestore upon sign-up
          createUserDocument(_user!.uid, _user!.email!, username);

          // Navigate to the home page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } catch (e) {
        if (e is FirebaseAuthException) {
          // Handle specific Firebase Auth exceptions
          if (e.code == 'email-already-in-use') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    "The email address is already in use by another account."),
              ),
            );
            if (!_user!.emailVerified) {
              await _user!.sendEmailVerification();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "A verification email has been sent to ${_user!.email}. Please verify your email before signing in.")));
              Navigator.pop(context);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Sign Up error: ${e.message}"),
              ),
            );
          }
        } else {
          if (kDebugMode) {
            print("Sign Up error: $e");
          }
        }
      }
    }
  }

  // Function to create a user document in Firestore
  void createUserDocument(String uid, String email, String username) {
    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
      'username': username,
      // Add other user-related fields as needed
    });
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
              Image.asset(
                'assets/images/bg1.png',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.10),
                  const Text("Sign Up",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
                        height: MediaQuery.of(context).size.height * 0.70,
                        child: Form(
                          key: _formKey,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                    "Look like you don't have an account. Let's create a new account ",
                                    // ignore: prefer_const_constructors
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                    textAlign: TextAlign.start),
                                // ignore: prefer_const_constructors

                                const SizedBox(height: 10),

                                MyTextField(
                                  controller: nameController,
                                  hintText: 'Enter Your Full Name',
                                  obscureText: false,
                                ),
                                const SizedBox(height: 10),

                                MyTextField(
                                  controller: emailController,
                                  hintText: 'Email',
                                  obscureText: false,
                                ),
                                const SizedBox(height: 10),
                                MyPasswordTextField(
                                  controller: passwordController,
                                  hintText: ' Password',
                                  obscureText: true,
                                ),

                                const SizedBox(height: 10),
                                MyPasswordTextField(
                                  controller: confirmPasswordController,
                                  hintText: ' Confirm Password',
                                  obscureText: true,
                                ),
                                const SizedBox(height: 25),

                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    RichText(
                                      text: const TextSpan(
                                        text: '',
                                        children: <TextSpan>[],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    MyButtonAgree(
                                      text: "Sign Up",
                                      onTap: () => signUpUser(),
                                    ),
                                  ],
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
