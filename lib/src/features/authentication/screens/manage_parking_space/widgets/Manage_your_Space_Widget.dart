import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../../../googlescreen.dart';
import '../../../../../constants/sizes.dart';
import '../../../../../constants/text_strings.dart';
import '../../profile/profile_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ManageScreen extends StatefulWidget {
  final Map<String, dynamic> spaceData;

  const ManageScreen({Key? key, required this.spaceData}) : super(key: key);

  @override
  _ManageSpaceScreenState createState() => _ManageSpaceScreenState();
}

class _ManageSpaceScreenState extends State<ManageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _nameController = TextEditingController();
  final _rateController = TextEditingController();
  final capacityController = TextEditingController();
  final descriptionController = TextEditingController();
  final viewController = TextEditingController();

  late String uid;
  bool locationSelected = false;
  bool _isLoading = false;
  LatLng? selectedLatLng; // Define a variable to store the selected location

  @override
  void dispose() {
    _typeController.dispose();
    _nameController.dispose();
    _rateController.dispose();
    capacityController.dispose();
    descriptionController.dispose();
    viewController.dispose();

    super.dispose();
  }

  void setLocation(LatLng? location) {
    setState(() {
      selectedLatLng = location;
      locationSelected = selectedLatLng != null;
    });
  }

  void _showLocationSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Location'),
          contentPadding: EdgeInsets.zero, // Remove default content padding

          content: Container(
            height: 800,
            // width: 600, // Set an appropriate height for your dialog
            child: Home(
              selectedLocation: selectedLatLng,
              onLocationSelected: setLocation,
            ),
          ),
        );
      },
    );
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
          title: const Text('Manage Space'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection('space')
                      .where('uid',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      QuerySnapshot<Map<String, dynamic>> querySnapshot =
                          snapshot.data!;
                      if (querySnapshot.size > 0) {
                        // Display the selected parking space data
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: querySnapshot.size,
                          itemBuilder: (context, index) {
                            DocumentSnapshot<Map<String, dynamic>>
                                documentSnapshot = querySnapshot.docs[index];
                            Map<String, dynamic>? spaceData =
                                documentSnapshot.data();
                            if (spaceData != null) {
                              // Check if the selected parking space matches the spaceData
                              if (spaceData['location'] ==
                                      widget.spaceData['location'] &&
                                  spaceData['type'] ==
                                      widget.spaceData['type']) {
                                uid = spaceData['uid'];
                                _nameController.text = spaceData['spacename'];
                                _typeController.text = spaceData['type'];
                                _rateController.text =
                                    spaceData['rate'].toString();
                                capacityController.text =
                                    spaceData['capacity'].toString();
                                descriptionController.text =
                                    spaceData['description'];
                                viewController.text = spaceData['view'];
                                double latitude =
                                    spaceData['latitude'] as double;
                                double longitude =
                                    spaceData['longitude'] as double;
                                return Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      // Image.network(
                                      //   spaceData['imageUrl'],
                                      //   height: 300,
                                      //   width: 600,
                                      //   fit: BoxFit
                                      //       .cover, // Adjust the fit property as needed
                                      // ),

                                      TextFormField(
                                        controller: _nameController,
                                        decoration: InputDecoration(
                                          labelText: tFullName,
                                          prefixIcon: Icon(Icons.location_city),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a name';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: tFormHeight - 20),
                                      TextFormField(
                                        controller: _typeController,
                                        decoration: InputDecoration(
                                          labelText: tType,
                                          prefixIcon: Icon(Icons.public_sharp),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a type';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: tFormHeight - 20),
                                      TextFormField(
                                        controller: _rateController,
                                        decoration: InputDecoration(
                                          labelText: tRate,
                                          prefixIcon: Icon(
                                              Icons.currency_exchange_sharp),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a rate';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: tFormHeight - 20),
                                      TextFormField(
                                        controller: capacityController,
                                        decoration: InputDecoration(
                                          labelText: tCapacity,
                                          prefixIcon: Icon(Icons.numbers),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a capacity';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: tFormHeight - 20),
                                      TextFormField(
                                        controller: descriptionController,
                                        decoration: InputDecoration(
                                          labelText: tAddDescription,
                                          prefixIcon: Icon(Icons.description),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a description';
                                          }
                                          return null;
                                        },
                                      ),
                                      // Text(
                                      //     'Latitude: ${selectedLatLng?.latitude.toString() ?? 'Not selected'}'),
                                      // Text(
                                      //     'Longitude: ${selectedLatLng?.longitude.toString() ?? 'Not selected'}'),
                                      Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              _showLocationSelectionDialog(
                                                  context);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                              ),
                                              child: _isLoading
                                                  ? CircularProgressIndicator()
                                                  : Center(
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            14.0),
                                                        child: Text(
                                                          locationSelected
                                                              ? 'Location selected'
                                                              : 'Change location',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                          )),
                                      SizedBox(height: 20),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              FirebaseFirestore.instance
                                                  .collection('space')
                                                  .doc(documentSnapshot.id)
                                                  .update({
                                                'uid': uid,
                                                'spacename':
                                                    _nameController.text,
                                                'type': _typeController.text,
                                                'rate': int.parse(
                                                    _rateController.text),
                                                'capacity': int.parse(
                                                    capacityController.text),
                                                'description':
                                                    descriptionController.text,
                                                'view': viewController.text,
                                                'latitude': selectedLatLng
                                                    ?.latitude, // Store latitude
                                                'longitude':
                                                    selectedLatLng?.longitude
                                              }).then((_) {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ProfileScreen(),
                                                  ),
                                                );
                                                Navigator.pop(context);
                                              }).catchError((error) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                          const Text('Error'),
                                                      content: Text(
                                                        'Failed to update user data: $error',
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              const Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              });
                                            }
                                          },
                                          child: const Text('Update Profile'),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              FirebaseFirestore.instance
                                                  .collection('space')
                                                  .doc(documentSnapshot.id)
                                                  .delete()
                                                  .then((_) {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ProfileScreen(),
                                                  ),
                                                );
                                                Navigator.pop(context);
                                              }).catchError((error) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                          const Text('Error'),
                                                      content: Text(
                                                        'Failed to update user data: $error',
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              const Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              });
                                            }
                                          },
                                          child: const Text('Delete Space'),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                            return const SizedBox.shrink();
                          },
                        );
                      }
                    }
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
