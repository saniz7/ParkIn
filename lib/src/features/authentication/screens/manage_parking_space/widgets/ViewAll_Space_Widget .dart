import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learn01/src/features/authentication/screens/manage_parking_space/widgets/Manage_your_Space_Widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../../constants/sizes.dart';

class ViewSpaceScreen extends StatefulWidget {
  const ViewSpaceScreen({Key? key}) : super(key: key);

  @override
  _ViewSpaceScreenState createState() => _ViewSpaceScreenState();
}

class _ViewSpaceScreenState extends State<ViewSpaceScreen> {
  bool isViewControllerEnabled = false;
  int parkingSpaceCount = 0;
  int availableSpaces = 0;
  int capacity = 0;

  void navigateToManageScreen(BuildContext context,
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final spaceData = documentSnapshot.data();
    if (spaceData != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManageScreen(spaceData: spaceData),
        ),
      );
    }
  }

  Future<void> updateViewControllerStatus(bool status) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    if (uid != null) {
      final spaceRef = FirebaseFirestore.instance.collection('space').doc(uid);
      await spaceRef.update({'view': status ? 'yes' : 'no'});
    }
  }

  Future<void> fetchSpaceData() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    if (uid != null) {
      final spaceRef = FirebaseFirestore.instance.collection('space').doc(uid);
      final docSnapshot = await spaceRef.get();
      final data = docSnapshot.data();
      if (data != null) {
        setState(() {
          isViewControllerEnabled = data['view'] == 'yes';
          availableSpaces = int.parse(data['availablespace'].toString());
          capacity = int.parse(data['capacity'].toString());
        });
      }
    }
  }

  Future<void> updateAvailableSpaces(int increment) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    if (uid != null) {
      final spaceRef = FirebaseFirestore.instance.collection('space').doc(uid);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(spaceRef);
        final currentAvailableSpaces = snapshot['availablespace'] as int;
        final updatedAvailableSpaces = currentAvailableSpaces + increment;
        if (updatedAvailableSpaces >= 0) {
          transaction
              .update(spaceRef, {'availablespace': updatedAvailableSpaces});
        }
      });
    }
  }

  String formatDate(DateTime dateTime) {
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    fetchSpaceData();
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
          title: Text(
            'Manage Your Space',
            style: TextStyle(color: Colors.black // Title color is green
                ),
          ),
          // backgroundColor: Color.fromARGB(
          //     255, 130, 242, 154), // Background color is light green
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: tFormHeight - 20),
                Row(
                  children: [
                    Text(
                      'View Your Space To Public For Parking:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Switch(
                      value: isViewControllerEnabled,
                      onChanged: (value) {
                        setState(() {
                          isViewControllerEnabled = value;
                          updateViewControllerStatus(value);
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Add the home icon here next to "Dhumbarahi"

                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('space')
                      .where('uid',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      QuerySnapshot<Map<String, dynamic>> querySnapshot =
                          snapshot.data!;

                      parkingSpaceCount = querySnapshot.size;

                      if (parkingSpaceCount > 0) {
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
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.green, width: 2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(16),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.home,
                                            color: Colors.green,
                                            size: 24,
                                          ),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                spaceData['spacename'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight
                                                      .bold, // Make text bold
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                spaceData['type'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight
                                                        .bold, // Make text bold
                                                    color: Colors.black,
                                                    fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
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
                            const SizedBox(height: tFormHeight - 20),
                            // Row(
                            //   children: [
                            //     Text(
                            //       'View Controller:',
                            //       style: TextStyle(
                            //         fontSize: 16,
                            //         fontWeight: FontWeight.bold,
                            //       ),
                            //     ),
                            //     SizedBox(width: 10),
                            //     Switch(
                            //       value: isViewControllerEnabled,
                            //       onChanged: (value) {
                            //         setState(() {
                            //           isViewControllerEnabled = value;
                            //           updateViewControllerStatus(value);
                            //         });
                            //       },
                            //       activeColor: Colors.green,
                            //     ),
                            //   ],
                            // ),
                            // const SizedBox(height: 20),
                            Text(
                              'Available Spaces: $availableSpaces',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Capacity: $capacity',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color.fromARGB(
                                          255, 47, 145, 50), // Border color
                                      width: 2.0, // Border width
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: availableSpaces < capacity
                                        ? () {
                                            setState(() {
                                              availableSpaces += 1;
                                              updateAvailableSpaces(1);
                                            });
                                          }
                                        : null,
                                    icon: Icon(
                                      Icons.add,
                                      color: const Color.fromARGB(255, 47, 145,
                                          50), // Set the icon color to green
                                    ),
                                    iconSize: 48, // Adjust the size as needed
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color.fromARGB(
                                          255, 47, 145, 50), // Border color
                                      width: 2.0, // Border width
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      if (availableSpaces > 0) {
                                        setState(() {
                                          availableSpaces -= 1;
                                          updateAvailableSpaces(-1);
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      Icons.remove,
                                      color: Color.fromARGB(255, 47, 145,
                                          50), // Set the icon color to green
                                    ),
                                    iconSize: 48, // Adjust the size as needed
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    }

                    return const Text('No parking spaces found');
                  },
                ),
                const SizedBox(height: 50),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('booking')
                      .where('pid',
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .where('time', isGreaterThan: Timestamp.now())
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          documents = snapshot.data!.docs;
                      if (documents.isNotEmpty) {
                        return Column(
                          children: documents.map((document) {
                            Map<String, dynamic>? bookingData = document.data();
                            if (bookingData != null) {
                              final date = formatDate(
                                  (bookingData['time'] as Timestamp).toDate());
                              return Column(
                                children: [
                                  SizedBox(height: tFormHeight - 20),
                                  Text('Name: ${bookingData['name']}'),
                                  SizedBox(height: tFormHeight - 20),
                                  Text('Time: $date'),
                                  SizedBox(height: tFormHeight - 20),
                                  Text(
                                      'Description: ${bookingData['description']}'),
                                  SizedBox(height: tFormHeight - 20),
                                  Text(
                                      'Vehicle Number: ${bookingData['vehicleno']}'),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          }).toList(),
                        );
                      }
                    }

                    return const Text('No bookings found. Book a space Now!!',
                        style: TextStyle(
                          fontStyle: FontStyle.italic, // Make the text italic
                          decoration:
                              TextDecoration.underline, // Underline the text
                        ));
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
