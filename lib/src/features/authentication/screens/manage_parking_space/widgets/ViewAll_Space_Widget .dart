import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn01/src/features/authentication/screens/manage_parking_space/widgets/Manage_your_Space_Widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ViewSpaceScreen extends StatelessWidget {
  const ViewSpaceScreen({Key? key}) : super(key: key);

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
                      // Data is still loading
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      // User data is available
                      QuerySnapshot<Map<String, dynamic>> querySnapshot =
                          snapshot.data!;
                      if (querySnapshot.size > 0) {
                        // Display all the parking spaces
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: querySnapshot.size,
                          itemBuilder: (context, index) {
                            DocumentSnapshot<Map<String, dynamic>>
                                documentSnapshot = querySnapshot.docs[index];
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
                        );
                      }
                    }
                    // User data not found or no parking spaces
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
