import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn01/src/features/authentication/screens/login/login_screen.dart';

// import '../pages/call_page.dart';
// ignore: unused_import
import '../MyHomePage.dart';
import '../src/features/authentication/screens/profile/profile_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const ProfileScreen();
            } else {
              return LoginScreen();
            }
          }),
    );
  }
}
