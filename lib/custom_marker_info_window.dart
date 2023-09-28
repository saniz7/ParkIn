import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:learn01/src/features/authentication/screens/booking/bookingpage.dart';
import 'package:learn01/src/features/authentication/screens/profile/profile_screen.dart';

class CustomMarkerInfoWindow extends StatefulWidget {
  const CustomMarkerInfoWindow({Key? key}) : super(key: key);

  @override
  _CustomMarkerInfoWindowState createState() => _CustomMarkerInfoWindowState();
}

class _CustomMarkerInfoWindowState extends State<CustomMarkerInfoWindow> {
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  final List<Marker> _markers = <Marker>[];
  final List<LatLng> _latLng = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  @override
  void initState() {
    super.initState();
    _customInfoWindowController = CustomInfoWindowController();
    fetchSpaceData();
  }

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

  void fetchSpaceData() {
    _subscription = FirebaseFirestore.instance
        .collection('space')
        .where('view', isEqualTo: 'yes')
        .snapshots()
        .listen((querySnapshot) {
      _markers.clear(); // Clear existing markers
      _latLng.clear(); // Clear existing LatLngs

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in querySnapshot.docs) {
        double latitude = document['latitude'] as double;
        double longitude = document['longitude'] as double;

        _latLng.add(LatLng(latitude, longitude));

        _markers.add(
          Marker(
            markerId: MarkerId(document.id),
            icon: BitmapDescriptor.defaultMarker,
            position: LatLng(latitude, longitude),
            onTap: () {
              _customInfoWindowController.hideInfoWindow!();
              _customInfoWindowController.addInfoWindow!(
                Container(
                  height: 300,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListView(
                    // Wrap the content in a ListView
                    children: [
                      // Customize the content here based on the selected Firestore document
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Place Info',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Name: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '${document['spacename']}',
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Description: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '${document['description']}',
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Available Space: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '${document['availablespace'].toString()}',
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Rate: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '${document['rate'].toString()}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                LatLng(latitude, longitude),
              );
            },
          ),
        );
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Find parking'),
          backgroundColor: Color.fromRGBO(29, 133, 51, 1),
        ),
        drawer: ProfileScreen(),
        body: Stack(
          children: [
            Positioned.fill(
              bottom: MediaQuery.of(context).size.height * 0.255,
              child: GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: LatLng(27.6714, 85.3387), zoom: 14),
                markers: Set<Marker>.of(_markers),
                onTap: (LatLng position) {
                  _customInfoWindowController.hideInfoWindow!();
                },
                onCameraMove: (position) {
                  _customInfoWindowController.onCameraMove!();
                },
                onMapCreated: (GoogleMapController controller) {
                  _customInfoWindowController.googleMapController = controller;
                },
              ),
            ),
            CustomInfoWindow(
              controller: _customInfoWindowController,
              height: 200,
              width: 300,
              offset: 35,
            ),
            Positioned.fill(
              child: DraggableScrollableSheet(
                maxChildSize: 0.7,
                minChildSize: 0.3,
                builder: (_, controller) {
                  return Material(
                    elevation: 10,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    color: Colors.white,
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('space')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasData) {
                          List<QueryDocumentSnapshot<Map<String, dynamic>>>
                              documents = snapshot.data!.docs;
                          if (documents.isNotEmpty) {
                            return ListView.builder(
                              controller: controller,
                              itemCount: documents.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic>? spaceData =
                                    documents[index].data();
                                if (spaceData != null) {
                                  return ListTile(
                                    title: Text(spaceData['spacename']),
                                    subtitle: Text(spaceData['description']),
                                    onTap: () => navigateToManageScreen(
                                      context,
                                      documents[index],
                                    ),
                                    // You can customize the list item as needed
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            );
                          }
                        }
                        return const Text('No parking spaces found');
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
