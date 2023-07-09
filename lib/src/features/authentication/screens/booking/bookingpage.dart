import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../common_widgets/form/form_header_widget.dart';
import '../../../../constants/image_strings.dart';
import '../../../../constants/sizes.dart';
import '../profile/profile_screen.dart';

class BookingPageSpaceScreen extends StatefulWidget {
  final Map<String, dynamic> spaceData;

  const BookingPageSpaceScreen({Key? key, required this.spaceData})
      : super(key: key);

  @override
  _BookingPageSpaceScreenState createState() => _BookingPageSpaceScreenState();
}

class _BookingPageSpaceScreenState extends State<BookingPageSpaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _locationController = TextEditingController();
  final _rateController = TextEditingController();
  final capacityController = TextEditingController();
  final descriptionController = TextEditingController();
  final viewController = TextEditingController();
  final _timeController = TextEditingController();
  final _vehicleController = TextEditingController();

  late String uid;
  bool _isLoading = false;

  @override
  void dispose() {
    _typeController.dispose();
    _locationController.dispose();
    _rateController.dispose();
    capacityController.dispose();
    descriptionController.dispose();
    viewController.dispose();
    _timeController.dispose();
    _vehicleController.dispose();

    super.dispose();
  }

  void _showBookingPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to book this place?'),
              SizedBox(height: 20),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Time',
                  prefixIcon: Icon(Icons.timer),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the time';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _vehicleController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Number',
                  prefixIcon: Icon(Icons.directions_car),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your vehicle details';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  bookup();
                  Navigator.of(context).pop(); // Close the popup
                }
              },
              child: Text('Confirm'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void bookup() async {
    setState(() {
      _isLoading = true; // Show progress indicator
    });

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;
      String uid = user?.uid ?? '';

      // Generate a new document ID for each data entry
      DocumentReference spaceRef = firestore.collection('booking').doc(uid);

      // Prepare the form data
      Map<String, dynamic> formData = {
        'uid': uid,
        'capacity': capacityController.text,
        'description': descriptionController.text,
      };

      // Set the form data in the document
      await spaceRef.set(formData);

      // Data stored successfully
      print('Data stored in Firestore');

      // Clear the form fields

      capacityController.clear();
      descriptionController.clear();
      viewController.clear();

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(LineAwesomeIcons.angle_double_left),
          ),
          title: const Text('Book a Space'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 50),
                FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance.collection('space').get(),
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
                                _locationController.text =
                                    spaceData['location'];
                                _typeController.text = spaceData['type'];
                                _rateController.text =
                                    spaceData['rate'].toString();
                                capacityController.text =
                                    spaceData['capacity'].toString();
                                descriptionController.text =
                                    spaceData['description'];
                                viewController.text = spaceData['view'];

                                return Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      FormHeaderWidget(
                                        image: tRentYourSpaceImage,
                                        subTitle: 'Parking Space Detail',
                                      ),
                                      SizedBox(height: tFormHeight - 20),
                                      Text(
                                          'Location: ${spaceData['location']}'),
                                      SizedBox(height: tFormHeight - 20),
                                      Text('Type: ${spaceData['type']}'),
                                      SizedBox(height: tFormHeight - 20),
                                      Text('Rate: ${spaceData['rate']}'),
                                      SizedBox(height: tFormHeight - 20),
                                      Text(
                                          'Available Space: ${spaceData['availablespace']}'),
                                      SizedBox(height: tFormHeight - 20),
                                      Text(
                                          'Description: ${spaceData['description']}'),
                                      SizedBox(height: 20),
                                      SizedBox(height: 20),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _showBookingPopup();
                                          },
                                          child: const Text('Book A Place'),
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
