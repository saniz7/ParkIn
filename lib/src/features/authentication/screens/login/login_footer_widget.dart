import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learn01/src/features/authentication/screens/signup/signup_screen.dart';

import '../../../../constants/image_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../profile/profile_screen.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    Key? key,
  }) : super(key: key);

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Configure Google sign-in
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Sign in with Google
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // Google sign-in canceled by the user
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Check if the account exists with the Gmail used for signing in
      final bool accountExists = await checkIfAccountExists(googleUser.email);
      if (accountExists) {
        // Redirect to the profile screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
      } else {
        // Account doesn't exist, show an error or handle the case as needed
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Account Not Found'),
              content: const Text(
                  'The account associated with this Gmail does not exist.'),
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
      }
      // Redirect or perform necessary actions after successful login
      // ...
    } catch (error) {
      print('Sign in with Google failed: $error');
      // Show an error message or handle the error as needed
    }
  }

  Future<bool> checkIfAccountExists(String email) async {
    // Implement your logic to check if the account exists with the given email/Gmail
    // Return true if the account exists, false otherwise
    // Example: You can query your user database or Firestore collection to check if the email exists
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signInSilently();

    if (googleUser != null) {
      // If the user is signed in silently, assume the account exists
      return true;
    }

    // The account doesn't exist
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("OR"),
        const SizedBox(
          height: tFormHeight - 20,
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: Image(
              image: AssetImage(tGoogleLogoImage),
              width: 25.0,
            ),
            onPressed: () {
              signInWithGoogle(context);
            },
            label: Text(tSignInWithGoogle),
          ),
        ),
        const SizedBox(
          height: tFormHeight - 20,
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text.rich(
            TextSpan(
              text: tDontHaveAnAccount,
              children: [
                TextSpan(
                  text: tSignUp,
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
