import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learn01/src/constants/sizes.dart';
import 'package:learn01/src/constants/text_strings.dart';

import '../../login/login_screen.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({Key? key}) : super(key: key);

  @override
  State<SignUpFormWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phonenoController = TextEditingController();

  bool _isLoading = false;

  Future<void> signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      String uid = userCredential.user!.uid;

      Fluttertoast.showToast(
        msg: 'Signup successful',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color.fromARGB(255, 53, 199, 84),
        textColor: Colors.white,
      );
      Navigator.pushReplacement(
        // Use pushReplacement to remove the SignUpFormWidget from the stack
        context, // Use the context passed to the method
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      addUserDetails(
        uid,
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        int.parse(_phonenoController.text.trim()),
      );
      dismissProgressDialog(context);
    } catch (e) {
      if (e is FirebaseAuthException) {
        print('Error: ${e.code} - ${e.message}');

        String errorMessage = 'An error occurred';

        switch (e.code) {
          case 'email-already-in-use':
            errorMessage =
                'The email address is already in use by another account';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email address';
            break;
          case 'user-disabled':
            errorMessage = 'This user account has been disabled';
            break;
          case 'user-not-found':
            errorMessage = 'User not found';
            break;
          case 'wrong-password':
            errorMessage = 'Invalid password';
            break;
        }

        Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        print('Error: $e');
        // Handle other non-authentication related errors
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
      dismissProgressDialog(context);
    }
  }

  Future<void> addUserDetails(String uid, String username, String email,
      String password, int phoneno) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentReference userRef = firestore.collection('users').doc(uid);

      await userRef.set({
        'uid': uid,
        'username': username,
        'email': email,
        'password': password,
        'phoneno': phoneno,
        'role': 'user',
      });
    } catch (e) {
      print('Error storing user details: $e');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _phonenoController.dispose();
    super.dispose();
  }

  showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16.0),
                Text('Loading...'),
              ],
            ),
          ),
        );
      },
    );
  }

  dismissProgressDialog(BuildContext context) {
    Navigator.of(context).pop();
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
                labelText: tFullName,
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]+')),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your username';
                }

                if (value.trim() == value) {
                  return null; // No spaces found, valid username
                } else {
                  return 'Username cannot contain only spaces';
                }
              },
            ),
            SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }

                final email = value.trim();
                final emailRegExp = RegExp(
                  r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                );

                if (!emailRegExp.hasMatch(email)) {
                  return 'Please enter a valid email address';
                }

                return null;
              },
            ),
            SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _phonenoController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.numbers),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }

                if (value.length != 10) {
                  return 'Phone number must be exactly 10 digits';
                }

                return null;
              },
            ),
            SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.fingerprint),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }

                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }

                return null;
              },
              obscureText: true,
            ),
            SizedBox(height: tFormHeight - 10),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: GestureDetector(
                onTap: () {
                  if (_formKey.currentState?.validate() == true) {
                    showProgressDialog(context);
                    signUp();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 53, 199, 84),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Center(
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
