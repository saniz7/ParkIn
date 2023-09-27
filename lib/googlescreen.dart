import 'dart:async';

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:learn01/src/features/authentication/screens/booking/Mybookings.dart';
import 'package:learn01/src/features/authentication/screens/rent_out_your_space/rent_out-your_space.dart';
import 'package:learn01/src/features/authentication/screens/rent_out_your_space/widgets/rent_out_your_space_widget.dart';

import 'custom_marker_info_window.dart';

class Home extends StatefulWidget {
  final LatLng? selectedLocation; // Accept the selected location as a parameter
  final void Function(LatLng) onLocationSelected; // Callback function

  const Home(
      {Key? key, this.selectedLocation, required this.onLocationSelected})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
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
  void initState() {
    super.initState();
    // Initialize the selectedLatLng with the provided selectedLocation
    selectedLatLng = widget.selectedLocation;
  }

  Widget build(BuildContext context) {
    LatLng initialLocation =
        widget.selectedLocation ?? LatLng(27.700769, 85.300140);

    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: initialLocation,
            zoom: 14.0,
          ),
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

                        // Call the callback function to send latitude and longitude
                        widget.onLocationSelected(latLng);
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
