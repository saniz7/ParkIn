import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learn01/main.dart';
import 'package:learn01/src/features/authentication/screens/parkingspace/ViewParking_Space_Widget%20.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import '../../../../common_widgets/form/form_header_widget.dart';
import '../../../../constants/image_strings.dart';
import '../../../../constants/sizes.dart';
import '../Khalti/khalti-widget.dart';
import '../profile/profile_screen.dart';
import 'package:flutter/services.dart'; // Add this import

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
  final nameController = TextEditingController();

  final descriptionController = TextEditingController();
  final viewController = TextEditingController();
  final _vehicleController = TextEditingController();
  final pid = TextEditingController();

  late String uid;
  bool _isLoading = false;
  late DateTime _selectedTime = DateTime.now();

  @override
  void dispose() {
    _typeController.dispose();
    _locationController.dispose();
    _rateController.dispose();
    capacityController.dispose();
    descriptionController.dispose();
    nameController.dispose();
    viewController.dispose();
    _vehicleController.dispose();
    pid.dispose();

    super.dispose();
  }

  void _showBookingPopup() {
    final currentTime = DateTime.now();
    if (_selectedTime.isAfter(currentTime)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Booking'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Are you sure you want to book this place?'),
                  SizedBox(height: 20),
                  Container(
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Time',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        TimePickerSpinner(
                          is24HourMode: false,
                          normalTextStyle: TextStyle(fontSize: 16),
                          highlightedTextStyle: TextStyle(fontSize: 40),
                          spacing: 50,
                          itemHeight: 40,
                          isForce2Digits: true,
                          onTimeChange: (time) {
                            setState(() {
                              _selectedTime = time;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _vehicleController,
                    decoration: const InputDecoration(
                      labelText: 'Vehicle Number',
                      prefixIcon: Icon(Icons.directions_car),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(
                          r'^$|^\d{1,4}$')), // Allow up to 4 digits or an empty string
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your vehicle details';
                      }
                      return null;
                    },
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() == true &&
                      _selectedTime.isAfter(currentTime)) {
                    navigateToKhaltiPaymentPage();
                  } else {
                    // Show an error message for invalid booking time
                    Fluttertoast.showToast(
                      msg: 'Invalid booking time',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
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
    } else {
      // Show an error message for invalid booking time
      Fluttertoast.showToast(
        msg: 'Invalid booking time',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    uid = user?.uid ?? '';
  }

  void navigateToKhaltiPaymentPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KhaltiPaymentPage(
          time: _selectedTime,
          rate: int.parse(_rateController.text),
          description: descriptionController.text,
          name: nameController.text,
          uid: uid,
          pid: pid.text,
          vehicleno: int.parse(_vehicleController.text),

          // location: _locationController.text,
        ),
      ),
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

      // Generate a new document ID for each booking
      DocumentReference bookingRef = firestore.collection('booking').doc();

      // Prepare the booking data
      Map<String, dynamic> bookingData = {
        'uid': uid,
        'pid': pid.text,
        'capacity': capacityController.text,
        'description': descriptionController.text,
        'name': nameController.text,
        'time': Timestamp.fromDate(_selectedTime),
        'vehicleno': _vehicleController.text,
      };

      // Store the booking data in Firestore
      await bookingRef.set(bookingData);

      // Clear the form fields
      capacityController.clear();
      descriptionController.clear();
      viewController.clear();

      // Navigate to the profile screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );

      // Display a success message
      Fluttertoast.showToast(
        msg: 'Booking successful',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      print('Error storing data: $e');

      // Display an error message
      Fluttertoast.showToast(
        msg: 'Failed to book the space',
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
                                pid.text = spaceData['uid'];
                                nameController.text = spaceData['spacename'];
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
