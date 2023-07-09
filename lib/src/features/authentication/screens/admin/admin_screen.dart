import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn01/src/features/authentication/screens/login/login_screen.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Screen'),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Data is still loading
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data?.exists == true) {
            // User data is available
            Map<String, dynamic>? userData = snapshot.data?.data();
            if (userData != null) {
              // Extract the user's email
              String email = userData['email'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    color: Colors.blue,
                    child: Text(
                      'Admin Screen',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Email: $email',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 32),
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 2,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Handle button press
                                  },
                                  child: Text('User'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Handle button press
                                  },
                                  child: Text('Places'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Handle button press
                                  },
                                  child: Text('Users (Manage)'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Handle button press
                                  },
                                  child: Text('Places (Manage)'),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            child: Text('Logout'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          }
          // User data not found
          return Center(child: Text('User data not found'));
        },
      ),
    );
  }
}
