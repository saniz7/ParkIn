import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _formKey = GlobalKey<FormState>();
  String? _emailError;

  //textcontroller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phonenoController = TextEditingController();

  Future signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Fluttertoast.showToast(
        msg: 'Signup successful',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
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
    } catch (e) {
      // Handle signup errors
      if (e is FirebaseAuthException) {
        print('Error: ${e.code} - ${e.message}');
      } else {
        print('Error: $e');
      } // Show an error toast message
      Fluttertoast.showToast(
          msg: "Signup failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
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
    _emailController.removeListener(_validateEmailOnChange);

    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmailOnChange);
  }

  void _validateEmailOnChange() {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _emailError = 'Please enter your email';
      });
    } else {
      final emailRegExp = RegExp(
        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
      );

      if (!emailRegExp.hasMatch(email)) {
        setState(() {
          _emailError = 'Please enter a valid email address';
        });
      } else {
        setState(() {
          _emailError = null;
        });
      }
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    // Additional password validation logic can be implemented here
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  label: Text(tFullName),
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your username';
                  }

                  if (value.trim() == value) {
                    // No spaces found, valid username
                    return null;
                  } else {
                    return 'Username cannot contain only spaces';
                  }
                },
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
                validator: (value) {
                  if (_emailError != null) {
                    return _emailError;
                  }
                  return null;
                },

                // validator: _validateNull,
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length < 10 || value.length > 10) {
                    return 'Phone number must be exactly 10 digits';
                  }
                  return null; // Return null to indicate the input is valid
                },
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }

                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }

                  // Additional password validation logic can be implemented here

                  return null; // Return null to indicate the input is valid
                },
              ),
              SizedBox(
                height: tFormHeight - 10,
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState?.validate() == true) {
                      signUp();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Text('Sign Up',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
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
