import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ManageSpaceScreen extends StatefulWidget {
  const ManageSpaceScreen({Key? key}) : super(key: key);

  @override
  _ManageSpaceScreenState createState() => _ManageSpaceScreenState();
}

class _ManageSpaceScreenState extends State<ManageSpaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phonenoController = TextEditingController();
  final RegExp _onlyAlphabetsRegExp = RegExp(r'[a-zA-Z]+');

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _phonenoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(LineAwesomeIcons.angle_double_left),
          ),
          title: const Text(
            'Manage Space',
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 50),
                FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection('space')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Data is still loading
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      // User data is available
                      Map<String, dynamic>? userData = snapshot.data!.data();
                      if (userData != null) {
                        _usernameController.text = userData['location'];
                        _emailController.text = userData['type'];
                        _phonenoController.text = userData['rate'].toString();
                        return Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: 'Full Name',
                                  prefixIcon: const Icon(LineAwesomeIcons.user),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    _onlyAlphabetsRegExp,
                                  ),
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
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon:
                                      const Icon(LineAwesomeIcons.envelope_1),
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
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _phonenoController,
                                decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  prefixIcon:
                                      const Icon(LineAwesomeIcons.phone),
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
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      // Form is valid, update user data
                                      FirebaseFirestore.instance
                                          .collection('space')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .update({
                                        'location': _usernameController.text,
                                        'type': _emailController.text,
                                        'rate':
                                            int.parse(_phonenoController.text),
                                      }).then((_) {
                                        // Successfully updated user data
                                        Navigator.pop(context);
                                      }).catchError((error) {
                                        // Error occurred while updating user data
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Error'),
                                              content: Text(
                                                'Failed to update user data: $error',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      });
                                    }
                                  },
                                  child: const Text(
                                    'Update Profile',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                    // User data not found
                    return const Text('User data not found');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
