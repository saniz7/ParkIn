import 'package:flutter/material.dart';
import 'package:learn01/src/constants/sizes.dart';
import 'package:learn01/src/constants/text_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learn01/src/features/authentication/screens/login/login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({
    super.key,
  });
  @override
  State<SignUpFormWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpFormWidget> {
  //textcontroller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phonenoController = TextEditingController();

  Future signUp() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    Fluttertoast.showToast(msg: 'Signup successful');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
    addUserDetails(
      _usernameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
      int.parse(_phonenoController.text.trim()),
    );
  }

  Future addUserDetails(
      String username, String email, String password, int phoneno) async {
    await FirebaseFirestore.instance.collection('users').add({
      'email': email,
      'password': password,
      'phoneno': phoneno,
      'username': username,
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
      child: Form(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              label: Text(tFullName),
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
          ),
          SizedBox(
            height: tFormHeight - 20,
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              label: Text(tEmail),
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          SizedBox(
            height: tFormHeight - 20,
          ),
          TextFormField(
            controller: _phonenoController,
            decoration: const InputDecoration(
              label: Text(tPhoneNo),
              prefixIcon: Icon(Icons.numbers),
            ),
          ),
          SizedBox(
            height: tFormHeight - 20,
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              label: Text(tPassword),
              prefixIcon: Icon(Icons.fingerprint),
            ),
          ),
          SizedBox(
            height: tFormHeight - 10,
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: GestureDetector(
              onTap: signUp,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Sign Up'),
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
