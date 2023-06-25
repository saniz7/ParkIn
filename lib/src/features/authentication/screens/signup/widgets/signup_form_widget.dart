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

  //textcontroller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phonenoController = TextEditingController();
  final RegExp _onlyAlphabetsRegExp = RegExp(r'[a-zA-Z]+');

  Future signUp() async {
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
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      addUserDetails(
        uid,
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        int.parse(_phonenoController.text.trim()),
      );
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
          // Add more cases for other error codes as needed
          // You can find the list of error codes in the FirebaseAuthException documentation
        }

        // Show error message to the user using a toast, snackbar, dialog, etc.
        // For example, using the fluttertoast package:
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
    }
  }

  Future addUserDetails(String uid, String username, String email,
      String password, int phoneno) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a reference to the user document using the UID as the document ID
      DocumentReference userRef = firestore.collection('users').doc(uid);

      // Store the user details in the document
      await userRef.set({
        'uid': uid,
        'username': username,
        'email': email,
        'password': password,
        'phoneno': phoneno,
      });
    } catch (e) {
      // Handle any errors that occurred during data storage
      print('Error storing user details: $e');
    }
  }

  @override
  void dispose() {
    // _emailController.removeListener(_validateEmailOnChange);

    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _emailController.addListener(_validateEmailOnChange);
  // }

  // void _validateEmailOnChange() {
  //   final email = _emailController.text.trim();

  //   if (email.isEmpty) {
  //     setState(() {
  //       _emailError = 'Please enter your email';
  //     });
  //   } else {
  //     final emailRegExp = RegExp(
  //       r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
  //     );

  //     if (!emailRegExp.hasMatch(email)) {
  //       setState(() {
  //         _emailError = 'Please enter a valid email address';
  //       });
  //     } else {
  //       setState(() {
  //         _emailError = null;
  //       });
  //     }
  //   }
  // }

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
                inputFormatters: [
                  FilteringTextInputFormatter.allow(_onlyAlphabetsRegExp),
                ],
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
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  final email = _emailController.text.trim();

                  final emailRegExp = RegExp(
                    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                  );
                  if (!emailRegExp.hasMatch(email)) {
                    return 'Please enter a valid email address';
                  }
                  return null; // Return null to indicate the input is valid
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
