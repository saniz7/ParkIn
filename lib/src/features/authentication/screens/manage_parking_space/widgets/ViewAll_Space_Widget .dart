import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
          title: const Text('Manage Space'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 50),
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

                      parkingSpaceCount =
                          querySnapshot.size; // Calculate the count

                      if (parkingSpaceCount > 0) {
                        // Calculate available spaces

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
                                  return ListTile(
                                    title: Text(spaceData['location']),
                                    subtitle: Text(spaceData['type']),
                                    onTap: () => navigateToManageScreen(
                                      context,
                                      documentSnapshot,
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                            const SizedBox(height: tFormHeight - 20),
                            Row(
                              children: [
                                Text('View Controller:'),
                                SizedBox(width: 10),
                                Switch(
                                  value: isViewControllerEnabled,
                                  onChanged: (value) {
                                    setState(() {
                                      isViewControllerEnabled = value;
                                      updateViewControllerStatus(value);
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text('Available Spaces: $availableSpaces'),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      availableSpaces += 1;
                                      updateAvailableSpaces(1);
                                    });
                                  },
                                  child: Icon(Icons.add),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    if (availableSpaces > 0) {
                                      setState(() {
                                        availableSpaces -= 1;
                                        updateAvailableSpaces(-1);
                                      });
                                    }
                                  },
                                  child: Icon(Icons.remove),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
