import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../booking/bookingpage.dart';

class ViewAllParkingSpaceScreen extends StatefulWidget {
  const ViewAllParkingSpaceScreen({Key? key}) : super(key: key);

  @override
  _ViewSpaceScreenState createState() => _ViewSpaceScreenState();
}

class _ViewSpaceScreenState extends State<ViewAllParkingSpaceScreen> {
  int parkingSpaceCount = 0;

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
          title: const Text('Available Space'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  'List of Available parking spaces',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(height: 40),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('space')
                      .where('view', isEqualTo: 'yes')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      QuerySnapshot<Map<String, dynamic>> querySnapshot =
                          snapshot.data!;
                      int capacity = 20; // Define the capacity value

                      parkingSpaceCount =
                          querySnapshot.size; // Calculate the count

                      if (parkingSpaceCount > 0) {
                        int availableSpaces = capacity -
                            parkingSpaceCount; // Calculate available spaces

                        return Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: parkingSpaceCount,
                              itemBuilder: (context, index) {
                                DocumentSnapshot<Map<String, dynamic>>
                                    documentSnapshot =
                                    querySnapshot.docs[index];
                                Map<String, dynamic>? spaceData =
                                    documentSnapshot.data();
                                if (spaceData != null) {
                                  return Card(
                                    child: ListTile(
                                      trailing: Icon(Icons.local_parking),
                                      tileColor:
                                          Color.fromARGB(255, 64, 161, 67),
                                      title: Text(spaceData['spacename'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 23)),
                                      subtitle: Text(spaceData['description'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                          )),
                                      onTap: () => navigateToManageScreen(
                                        context,
                                        documentSnapshot,
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                            // const SizedBox(height: 20),
                            // Text('Parking Space Count: $parkingSpaceCount'),
                            // Text('Available Spaces: $availableSpaces'),
                          ],
                        );
                      }
                    }

                    return const Text('No parking spaces found');
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
