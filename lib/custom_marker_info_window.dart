import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarkerInfoWindow extends StatefulWidget {
  const CustomMarkerInfoWindow({Key? key}) : super(key: key);

  @override
  _CustomMarkerInfoWindowState createState() => _CustomMarkerInfoWindowState();
}

class _CustomMarkerInfoWindowState extends State<CustomMarkerInfoWindow> {
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  final List<Marker> _markers = <Marker>[];
  final List<LatLng> _latLng = [
    LatLng(27.67141, 85.33913),
    LatLng(27.6721, 85.3398),
    LatLng(27.6770118, 85.3327667),
    LatLng(27.704127, 85.332151),
  ];

  @override
  void initState() {
    super.initState();
    _customInfoWindowController = CustomInfoWindowController();
    loadData();
  }

  loadData() {
    for (int i = 0; i < _latLng.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          icon: BitmapDescriptor.defaultMarker,
          position: _latLng[i],
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
                    Container(
                      width: 300,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://www.collegeinfonepal.com/wp-content/uploads/2023/07/Nepal-College-of-Information-Technology-NCIT-Photo-1.jpg',
                          ),
                          fit: BoxFit.fitWidth,
                          filterQuality: FilterQuality.high,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        color: Colors.red,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Ncit College Parking',
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '.3 mi.',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'You can park here from 11 am to 5 pm - Sunday to Friday',
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              _latLng[i],
            );
          },
        ),
      );
      setState(() {});
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
