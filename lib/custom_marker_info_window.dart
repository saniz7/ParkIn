import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  void initState() {
    super.initState();
    _customInfoWindowController = CustomInfoWindowController();
    fetchSpaceData();
  }

  Future<void> fetchSpaceData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await firestore.collection('space').get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in querySnapshot.docs) {
        double latitude = document['latitude']
            as double; // Replace 'latitude' with the actual field name
        double longitude = document['longitude']
            as double; // Replace 'longitude' with the actual field name

        _latLng.add(LatLng(latitude, longitude));

        _markers.add(
          Marker(
            markerId: MarkerId(
                document.id), // You can use the document ID as the marker ID
            icon: BitmapDescriptor.defaultMarker,
            position: LatLng(latitude, longitude),
            onTap: () {
              _customInfoWindowController.hideInfoWindow!();
              _customInfoWindowController.addInfoWindow!(
                Container(
                  height: 300, // Adjust this height as needed
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
                          'Custom Marker Info',
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Latitude: $latitude, Longitude: $longitude',
                        ),
                      ),
                    ],
                  ),
                ),
                LatLng(27.67141, 85.33913),
              );
            },
          ),
        );
      }
      setState(() {});
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Info Window'),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: [
          GoogleMap(
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
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 200,
            width: 300,
            offset: 35,
          )
        ],
      ),
    );
  }
}
