// import 'package:flutter/material.dart';
///import 'package:google_sign_in/google_sign_in.dart';
///import 'package:firebase_auth/firebase_auth.dart';

// import '../pages/call_page.dart';
// import '../pages/registerpage.dart';

// class Authpage extends StatefulWidget {
//   const Authpage({super.key});

//   @override
//   State<Authpage> createState() => _AuthpageState();
// }

// class _AuthpageState extends State<Authpage> {
//   bool showLoginPage = true;
//   void toggleScreens(){
//     setState(() {
//   showLoginPage=!showLoginPage;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
// if (showLoginPage){
//   return CallsScreen(showRegister:toggleScreens);
// }
// else{
//   return Registerpage(showLoginPage:toggleScreens);
// }}
// }

/// google signin first try (BS)

/// [GoogleAuthetication]
///Future<UserCredential?> signInWithGoogle() async {
  // Trigger the authentication flow
  ///final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  ///final GoogleSignInAuthentication? googleAuth =
      ///await googleUser?.authentication;

  // Create a new credential
  ///final credential = GoogleAuthProvider.credential(
    ///accessToken: googleAuth?.accessToken,
    ///idToken: googleAuth?.idToken,
  ///);

  // Once signed in, return the UserCredential
  ///return await FirebaseAuth.instance.signInWithCredential(credential);
///}
