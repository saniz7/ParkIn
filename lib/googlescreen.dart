import 'dart:async';

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // ignore: prefer_final_fields
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(27.700769, 85.300140),
    zoom: 14.4746,
  );

  List<Marker> _marker = [];
  final List<Marker> _list = const [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(27.700769, 85.300140),
        infoWindow: InfoWindow(title: 'My current location')),
    Marker(
        markerId: MarkerId('2'),
        position: LatLng(27.6712723667, 85.3390844333),
        infoWindow: InfoWindow(title: 'Ncit College'))
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _marker.addAll(_list);
  }

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
