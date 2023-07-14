import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyHomePagee extends StatefulWidget {
  const MyHomePagee({super.key});
  @override
  State<MyHomePagee> createState() => MyHomePageeState();
}

class MyHomePageeState extends State<MyHomePagee> {
  //textcontroller
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[500],
      body: SafeArea(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Helllo${user.email!}'),
            MaterialButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              color: Colors.deepPurple,
              child: const Text('signout'),
            )
          ]),
        ),
      ),
    );
  }
}
