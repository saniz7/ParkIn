import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(27.671333297258062, 85.33869273960579),
    zoom: 15,
  );

  List<Marker> _marker = [];
  List<Marker> _list = const [
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(27.671333297258062, 85.33869273960579),
      infoWindow: InfoWindow(title: "Current Location"),
    )
  ];

  @override
  void initState() {
    super.initState();
    _marker.addAll(_list);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GoogleMap(
          //marker show
          markers: Set<Marker>.of(_marker),
          initialCameraPosition: _kGooglePlex,
          mapType: MapType.normal,
          compassEnabled: false,
          // myLocationEnabled: true,
          // myLocationButtonEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
