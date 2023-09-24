import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learn01/src/common_widgets/form/form_header_widget.dart';
import 'package:learn01/src/constants/image_strings.dart';
import 'package:learn01/src/constants/sizes.dart';
import 'package:learn01/src/constants/text_strings.dart';

import '../login/login_screen.dart';
import 'widgets/signup_form_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Sign out user from both Google and Firebase
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();

      // Sign in with Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Sign in with Firebase using the credential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      String uid = userCredential.user!.uid;

      // Check if the email already exists
      if (user != null) {
        final userExists = await _checkIfUserExists(user.email ?? '');
        if (userExists) {
          // Email already exists, show an error or handle the case as needed
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Email already exists'),
                content:
                    const Text('The email you provided is already registered.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          // Email doesn't exist, store user data and redirect to the login page
          await _storeUserData(
            uid: uid,
            email: user.email ?? '',
            username: user.displayName ?? '',
            isGoogleSignIn: true, // Indicate that it's a Google sign-in
            googleId: user.uid,
// Store the Google ID
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      }
    } catch (error) {
      print('Sign in with Google failed: $error');
      // Show an error message or handle the error as needed
    }
  }

  Future<bool> _checkIfUserExists(String email) async {
    try {
      final userCollection = FirebaseFirestore.instance.collection('users');
      final QuerySnapshot snapshot =
          await userCollection.where('email', isEqualTo: email).limit(1).get();

      return snapshot.docs.isNotEmpty;
    } catch (error) {
      print('Error checking if user exists: $error');
      return false;
    }
  }

  Future<void> _storeUserData({
    required String uid,
    required String email,
    required String username,
    bool isGoogleSignIn = false,
    String? googleId,
  }) async {
    try {
      final userCollection = FirebaseFirestore.instance.collection('users');
      await userCollection.doc(uid).set({
        'uid': uid,
        'email': email,
        'username': username,
        'isGoogleSignIn': isGoogleSignIn,
        'googleId': googleId,
        'role': 'user',

        // Add more fields as needed
      });
    } catch (error) {
      print('Error storing user data: $error');
      // Show an error message or handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              children: [
                FormHeaderWidget(
                  image: tSignUpImage,
                  title: tSignUpTitle,
                  subTitle: tsignUpSubTitle,
                ),
                const SignUpFormWidget(),
                Column(
                  children: [
                    const Text('OR'),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          signInWithGoogle(context);
                        },
                        icon: const Image(
                          image: AssetImage(tGoogleLogoImage),
                          width: 20.0,
                        ),
                        label: const Text(tSignInWithGoogle),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: tAlreadyHaveAnAccount,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            TextSpan(
                              text: tLogin,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
