import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../common_widgets/form/form_header_widget.dart';
import '../../../../constants/image_strings.dart';
import '../../../../constants/sizes.dart';
import '../booking/bookingpage.dart';

class MyBookingPageSpaceScreen extends StatefulWidget {
  const MyBookingPageSpaceScreen({Key? key}) : super(key: key);

  @override
  _MyBookingPageScreenState createState() => _MyBookingPageScreenState();
}

class _MyBookingPageScreenState extends State<MyBookingPageSpaceScreen> {
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
                FormHeaderWidget(
                  image: tRentYourSpaceImage,
                  subTitle: 'Booking Detail',
                ),
                const SizedBox(height: 50),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('booking')
                      .where('uid',
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Data is still loading
                      return CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      // User data is available
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          documents = snapshot.data!.docs;
                      if (documents.isNotEmpty) {
                        return Column(
                          children: documents.map((document) {
                            Map<String, dynamic>? bookingData = document.data();
                            if (bookingData != null) {
                              // Convert the timestamp to a DateTime object
                              DateTime time = bookingData['time'].toDate();

                              // Format the DateTime object
                              String formattedTime =
                                  DateFormat('dd MMM yyyy, hh:mm a')
                                      .format(time);

                              return Column(
                                children: [
                                  SizedBox(height: tFormHeight - 20),
                                  Text('Name: ${bookingData['name']}'),
                                  SizedBox(height: tFormHeight - 20),
                                  Text('Time: $formattedTime'),
                                  SizedBox(height: tFormHeight - 20),
                                  Text(
                                      'Description: ${bookingData['description']}'),
                                  SizedBox(height: tFormHeight - 20),
                                  Text(
                                      'Vehicle Number: ${bookingData['vehicleno']}'),
                                  SizedBox(height: tFormHeight - 20),
                                  Text('Rate: ${bookingData['rate']}'),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          }).toList(),
                        );
                      }
                    }
                    return const Text('No bookings found. Book a space Now');
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
