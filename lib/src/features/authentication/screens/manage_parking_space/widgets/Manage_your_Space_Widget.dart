import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../../common_widgets/form/form_header_widget.dart';
import '../../../../../constants/image_strings.dart';
import '../../../../../constants/sizes.dart';
import '../../../../../constants/text_strings.dart';
import '../../profile/profile_screen.dart';

class ManageSpaceScreen extends StatefulWidget {
  const ManageSpaceScreen({Key? key}) : super(key: key);

  @override
  _ManageSpaceScreenState createState() => _ManageSpaceScreenState();
}

class _ManageSpaceScreenState extends State<ManageSpaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _locationController = TextEditingController();
  final _rateController = TextEditingController();
  final capacityController = TextEditingController();
  final descriptionController = TextEditingController();
  // final parkingPlaceImageController = TextEditingController();
  late String uid;

  @override
  void dispose() {
    _typeController.dispose();
    _locationController.dispose();
    _rateController.dispose();
    // parkingPlaceImageController.clear();
    capacityController.dispose();
    descriptionController.dispose();
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
                FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection('space')
                      .where('uid',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Data is still loading
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      // User data is available
                      QuerySnapshot<Map<String, dynamic>> querySnapshot =
                          snapshot.data!;
                      if (querySnapshot.size > 0) {
                        // Retrieve the first document from the query result
                        DocumentSnapshot<Map<String, dynamic>>
                            documentSnapshot = querySnapshot.docs[0];
                        Map<String, dynamic>? userData =
                            documentSnapshot.data();
                        if (userData != null) {
                          uid = userData['uid'];
                          _locationController.text = userData['location'];
                          _typeController.text = userData['type'];
                          _rateController.text = userData['rate'].toString();
                          capacityController.text =
                              userData['capacity'].toString();
                          descriptionController.text = userData['description'];
                          // parkingPlaceImageController.text =
                          // userData['parkingPlaceImage'];
                          return Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                FormHeaderWidget(
                                  image: tRentYourSpaceImage,
                                  // title: tAdditionalDetailsTitle,
                                  subTitle: 'Edit your parking space',
                                ),
                                TextFormField(
                                  controller: _locationController,
                                  decoration: InputDecoration(
                                    labelText:
                                        tLocation, // Changed label to labelText
                                    prefixIcon: Icon(Icons.location_city),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a location';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: tFormHeight - 20,
                                ),
                                TextFormField(
                                  controller: _typeController,
                                  decoration: InputDecoration(
                                    labelText:
                                        tType, // Changed label to labelText
                                    prefixIcon: Icon(Icons.public_sharp),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a type';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: tFormHeight - 20,
                                ),
                                TextFormField(
                                  controller: _rateController,
                                  decoration: InputDecoration(
                                    labelText:
                                        tRate, // Changed label to labelText
                                    prefixIcon:
                                        Icon(Icons.currency_exchange_sharp),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a rate';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: tFormHeight - 20,
                                ),
                                TextFormField(
                                  controller: capacityController,
                                  decoration: InputDecoration(
                                    labelText:
                                        tCapacity, // Changed label to labelText
                                    prefixIcon: Icon(Icons.numbers),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a capacity';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: tFormHeight - 20,
                                ),
                                TextFormField(
                                  controller: descriptionController,
                                  decoration: InputDecoration(
                                    labelText:
                                        tAddDescription, // Changed label to labelText
                                    prefixIcon: Icon(Icons.description),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a description';
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
                                            .doc(documentSnapshot.id)
                                            .update({
                                          'uid': uid,

                                          'location': _locationController.text,
                                          'type': _typeController.text,
                                          'rate':
                                              int.parse(_rateController.text),
                                          'capacity': int.parse(
                                              capacityController.text),
                                          'description':
                                              descriptionController.text,
                                          // 'parkingPlaceImage':
                                          // parkingPlaceImageController.text,
                                        }).then((_) {
                                          // Successfully updated user data
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ProfileScreen(),
                                            ),
                                          );
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
                                                      Navigator.of(context)
                                                          .pop();
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
