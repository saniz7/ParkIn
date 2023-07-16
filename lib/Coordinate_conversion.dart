import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class CoordinateConversion extends StatefulWidget {
  const CoordinateConversion({Key? key}) : super(key: key);

  @override
  State<CoordinateConversion> createState() => _CoordinateConversionState();
}

class _CoordinateConversionState extends State<CoordinateConversion> {
  String stAddress = '', stAdd = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google map'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(stAddress),
          Text(stAdd),
          GestureDetector(
            onTap: () async {
              List<Location> locations =
                  await locationFromAddress("Balkumari, Lalitpur");
              List<Placemark> placemarks =
                  await placemarkFromCoordinates(27.681663195, 85.31696853);

              //final coordinates = new Coordinates(27.7006, 85.3117);

              setState(() {
                stAddress = locations.last.latitude.toString() +
                    " " +
                    locations.last.longitude.toString();
                stAdd = placemarks.reversed.last.locality.toString() +
                    " " +
                    placemarks.reversed.last.country.toString();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(color: Colors.green),
                child: Center(
                  child: Text('Convert'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
