import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learn01/src/features/authentication/screens/booking/bookingpage.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../common_widgets/form/form_header_widget.dart';
import '../../../../constants/image_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';

class ViewDetailSpaceScreen extends StatefulWidget {
  final Map<String, dynamic> spaceData;

  const ViewDetailSpaceScreen({Key? key, required this.spaceData})
      : super(key: key);

  @override
  _ViewDetailSpaceScreenState createState() => _ViewDetailSpaceScreenState();
}

class _ViewDetailSpaceScreenState extends State<ViewDetailSpaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _locationController = TextEditingController();
  final _rateController = TextEditingController();
  final capacityController = TextEditingController();
  final descriptionController = TextEditingController();
  final viewController = TextEditingController();

  late String uid;

  void navigateToManageScreen(BuildContext context,
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final spaceData = documentSnapshot.data();
    if (spaceData != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingPageSpaceScreen(spaceData: spaceData),
        ),
      );
    }
  }

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
          title: const Text('Manage Space'),
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
                                      TextFormField(
                                        controller: _locationController,
                                        decoration: InputDecoration(
                                          labelText: tLocation,
                                          prefixIcon: Icon(Icons.location_city),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a location';
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
                                      SizedBox(height: 20),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            navigateToManageScreen(
                                              context,
                                              documentSnapshot,
                                            );
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
