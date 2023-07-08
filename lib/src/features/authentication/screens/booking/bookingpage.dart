import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn01/src/features/authentication/screens/manage_parking_space/widgets/Manage_your_Space_Widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../common_widgets/form/form_header_widget.dart';
import '../../../../constants/image_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../profile/profile_screen.dart';

class BookingPageSpaceScreen extends StatefulWidget {
  final Map<String, dynamic> spaceData;

  const BookingPageSpaceScreen({Key? key, required this.spaceData})
      : super(key: key);

  @override
  _BookingDetailSpaceScreenState createState() =>
      _BookingDetailSpaceScreenState();
}

class _BookingDetailSpaceScreenState extends State<BookingPageSpaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _locationController = TextEditingController();
  final _rateController = TextEditingController();
  final capacityController = TextEditingController();
  final descriptionController = TextEditingController();
  final viewController = TextEditingController();

  late String uid;

  @override
  void dispose() {
    _typeController.dispose();
    _locationController.dispose();
    _rateController.dispose();
    capacityController.dispose();
    descriptionController.dispose();
    viewController.dispose();

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
                                          'Available Space: ${spaceData['capacity']}'),
                                      SizedBox(height: tFormHeight - 20),
                                      Text(
                                          'Description: ${spaceData['description']}'),
                                      SizedBox(height: 20),
                                      SizedBox(height: 20),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {},
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
