import 'package:flutter/material.dart';
import 'package:learn01/src/constants/sizes.dart';
import 'package:learn01/src/constants/text_strings.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learn01/src/constants/sizes.dart';
import '../../login/login_screen.dart';
import '../../../../../constants/colors.dart';
import '../../profile/profile_screen.dart';

class RentSpaceWidget extends StatefulWidget {
  const RentSpaceWidget({Key? key}) : super(key: key);

  @override
  State<RentSpaceWidget> createState() => _RentSpaceState();
}

class _RentSpaceState extends State<RentSpaceWidget> {
  final _formKey = GlobalKey<FormState>();

  final locationController = TextEditingController();
  final typeController = TextEditingController();
  final rateController = TextEditingController();
  final capacityController = TextEditingController();
  final parkingPlaceImageController = TextEditingController();
  final descriptionController = TextEditingController();

  bool _isLoading = false;

  void _storeFormData() async {
    setState(() {
      _isLoading = true; // Show progress indicator
    });

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;
      String uid = user?.uid ?? '';

      // Generate a new document ID for each data entry
      DocumentReference spaceRef = firestore.collection('space').doc();

      // Prepare the form data
      Map<String, dynamic> formData = {
        'uid': uid,
        'location': locationController.text,
        'type': typeController.text,
        'rate': rateController.text,
        'capacity': capacityController.text,
        'parkingPlaceImage': parkingPlaceImageController.text,
        'description': descriptionController.text,
      };

      // Set the form data in the document
      await spaceRef.set(formData);

      // Data stored successfully
      print('Data stored in Firestore');

      // Clear the form fields
      locationController.clear();
      typeController.clear();
      rateController.clear();
      capacityController.clear();
      parkingPlaceImageController.clear();
      descriptionController.clear();
      dismissProgressDialog(context);
  Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
      // Display a success message
      Fluttertoast.showToast(
        msg: 'Data stored successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      print('Error storing data: $e');
      dismissProgressDialog(context);

      // Display an error message
      Fluttertoast.showToast(
        msg: 'Failed to store data',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide progress indicator
      });
    }
  }

  @override
  void dispose() {
    locationController.dispose();
    typeController.dispose();
    rateController.dispose();
    capacityController.dispose();
    parkingPlaceImageController.dispose();
    descriptionController.dispose();

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
        key: _formKey, // Added form key
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: tLocation, // Changed label to labelText
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
              controller: typeController,
              decoration: InputDecoration(
                labelText: tType, // Changed label to labelText
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
              controller: rateController,
              decoration: InputDecoration(
                labelText: tRate, // Changed label to labelText
                prefixIcon: Icon(Icons.currency_exchange_sharp),
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
                labelText: tCapacity, // Changed label to labelText
                prefixIcon: Icon(Icons.numbers),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a capacity';
                }
                return null;
              },
            ),
            // SizedBox(
            //   height: tFormHeight - 20,
            // ),
            // TextFormField(
            //   controller: parkingPlaceImageController,
            //   decoration: InputDecoration(
            //     labelText: tParkingPlaceImage, // Changed label to labelText
            //     prefixIcon: Icon(Icons.image),
            //   ),
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter a parking place image';
            //     }
            //     return null;
            //   },
            // ),
            SizedBox(
              height: tFormHeight - 20,
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: tAddDescription, // Changed label to labelText
                prefixIcon: Icon(Icons.description),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            SizedBox(
              height: tFormHeight - 10,
            ),
            SizedBox(height: tFormHeight - 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  if (_formKey.currentState?.validate() == true) {
                    showProgressDialog(context);
                    _storeFormData();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Center(
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              'Rent My Space',
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
