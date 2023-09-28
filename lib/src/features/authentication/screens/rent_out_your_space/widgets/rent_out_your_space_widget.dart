import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn01/src/constants/sizes.dart';
import 'package:learn01/src/constants/text_strings.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../../../custom_marker_info_window.dart';
import '../../../../../../googlescreen.dart';
import '../../profile/profile_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RentSpaceWidget extends StatefulWidget {
  const RentSpaceWidget({Key? key}) : super(key: key);

  @override
  State<RentSpaceWidget> createState() => _RentSpaceState();
}

class _RentSpaceState extends State<RentSpaceWidget> {
  final _formKey = GlobalKey<FormState>();
  LatLng? selectedLatLng;

  final locationController = TextEditingController(); // Add this controller
  final typeController = TextEditingController();
  final rateController = TextEditingController();
  final capacityController = TextEditingController();
  final descriptionController = TextEditingController();
  final viewController = TextEditingController();
  final nameController = TextEditingController();

  String imageUrl = '';

  bool _isLoading = false;
  bool _isRegistered = false;
  bool locationSelected = false;

  @override
  void initState() {
    super.initState();
    checkRegistrationStatus();
  }

  void checkRegistrationStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('space')
        .doc(user!.uid)
        .get();

    if (snapshot.exists) {
      setState(() {
        _isRegistered = true;
      });
    }
  }

  void _storeFormData() async {
    setState(() {
      _isLoading = true; // Show progress indicator
    });

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;
      String uid = user?.uid ?? '';

      // Generate a new document ID for each data entry
      DocumentReference spaceRef = firestore.collection('space').doc(uid);

      // Prepare the form data
      Map<String, dynamic> formData = {
        'uid': uid,
        'spacename': nameController.text,
        'location': locationController.text,
        'type': typeController.text,
        'rate': rateController.text,
        'capacity': int.parse(capacityController.text.trim()),
        'imageUrl': imageUrl,
        'description': descriptionController.text,
        'view': viewController.text,
        'availablespace': int.parse(capacityController.text.trim()),
        'latitude': selectedLatLng?.latitude, // Store latitude
        'longitude': selectedLatLng?.longitude, // Store longitude
      };

      // Set the form data in the document
      await spaceRef.set(formData);

      // Data stored successfully
      print('Data stored in Firestore');

      // Clear the form fields
      locationController.clear();
      nameController.clear();
      typeController.clear();
      rateController.clear();
      capacityController.clear();
      descriptionController.clear();
      viewController.clear();

      dismissProgressDialog(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CustomMarkerInfoWindow()),
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = await pickedFile.readAsBytes();
      final imageName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference storageRef =
          FirebaseStorage.instance.ref().child('images/$imageName.jpg');
      final UploadTask uploadTask = storageRef.putData(file);

      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        imageUrl = downloadUrl;
      });
    } else {
      // User canceled the image picking
      print('No image picked');
    }
  }

  @override
  void dispose() {
    locationController.dispose();
    typeController.dispose();
    rateController.dispose();
    capacityController.dispose();
    descriptionController.dispose();
    viewController.dispose();
    nameController.dispose();

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

  // Callback function to receive the selected location
  void setLocation(LatLng latLng) {
    // Store the selected location in your state or variables
    setState(() {
      selectedLatLng = latLng;
      locationSelected = true; // Location is selected

      // locationController.text =
      //     'Latitude: ${latLng.latitude}, Longitude: ${latLng.longitude}';
    });
    print('Our Latitude and is: ${latLng.latitude}');
    print(selectedLatLng?.latitude);
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
    if (_isRegistered) {
      return Text('You have already registered a space');
    } else {
      return Material(
          // Wrap with Material widget
          child: Container(
        padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
        child: Form(
          key: _formKey, // Added form key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Space Name', // Changed label to labelText
                  prefixIcon: Icon(Icons.location_city),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: GestureDetector(
                    onTap: () {
                      _showLocationSelectionDialog(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Center(
                              child: Padding(
                                padding: EdgeInsets.all(14.0),
                                child: Text(
                                  locationSelected
                                      ? 'Location selected'
                                      : 'Choose a location',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  )),
              // TextFormField(
              //   controller: locationController, // Use the controller here
              //   decoration: InputDecoration(
              //     labelText: 'Location',
              //     prefixIcon: Icon(Icons.location_city),
              //   ),
              //   readOnly: true, // Make the text field read-only
              //   validator: (value) {
              //     // You can add validation here if needed
              //     return null;
              //   },
              // ),
              // TextFormField(
              //   controller: locationController,
              //   decoration: InputDecoration(
              //     labelText: tLocation, // Changed label to labelText
              //     prefixIcon: Icon(Icons.location_city),
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter a location';
              //     }
              //     return null;
              //   },
              // ),
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
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
                height: tFormHeight - 20,
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              SizedBox(
                height: tFormHeight - 10,
              ),
              SizedBox(height: tFormHeight - 10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState?.validate() == true &&
                        selectedLatLng != null) {
                      showProgressDialog(context);
                      _storeFormData();
                    }
                    if (selectedLatLng == null) {
                      // Location is not selected, show an error message
                      Fluttertoast.showToast(
                        msg: 'Location is required',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
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
      ));
    }
  }
}
