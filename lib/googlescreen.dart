import 'dart:async';

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> _marker = [];
  int id = 1;
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  LatLng? selectedLatLng; // Added to store the selected latitude and longitude

  var _kGooglePlex = CameraPosition(
    target: LatLng(27.700769, 85.300140), // Initial map center coordinates
    zoom: 14.0, // Initial zoom level
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          markers: Set<Marker>.of(_marker),
          mapType: MapType.normal,
          myLocationEnabled: false,
          compassEnabled: false,
          onTap: (LatLng latLng) {
            // Show a confirmation dialog when tapping on the map
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Confirm Location'),
                  content: Text('Do you want to add a marker here?'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                    TextButton(
                      child: Text('Yes'),
                      onPressed: () {
                        // Add the marker to the map
                        Marker newMarker = Marker(
                          markerId: MarkerId('gramercy'),
                          position: LatLng(latLng.latitude, latLng.longitude),
                          infoWindow: InfoWindow(title: 'New place'),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed,
                          ),
                        );
                        _marker.add(newMarker);
                        setState(() {});
                        Navigator.of(context).pop(); // Close the dialog
                        print('Our Latitude and Longitude is: $latLng');
                      },
                    ),
                  ],
                );
              },
            );
          },
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_disabled_outlined),
        onPressed: () async {
          GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(27.6712723667, 85.3390844333), zoom: 14)));
          setState(() {});
        },
      ),
    );
  }
}
