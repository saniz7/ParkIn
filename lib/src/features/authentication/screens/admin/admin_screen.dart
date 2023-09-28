// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:learn01/src/features/authentication/screens/login/login_screen.dart';
// import '../admin/parking_data.dart';
// import '../admin/parking_manage.dart';
// import '../admin/user_data.dart';
// import '../admin/user_manage.dart';

// class AdminScreen extends StatefulWidget {
//   @override
//   _AdminScreenState createState() => _AdminScreenState();
// }

// class _AdminScreenState extends State<AdminScreen> {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final TextEditingController _notificationController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _setupFirebaseMessaging();
//   }

//   void _setupFirebaseMessaging() {
//     _firebaseMessaging.requestPermission();
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Got a message whilst in the foreground!');
//       print('Message data: ${message.data}');
//       if (message.notification != null) {
//         print('Message also contained a notification: ${message.notification}');
//         // Show a notification in the foreground when receiving a message with a notification payload (optional)
//         _showForegroundNotification(message.notification);
//       }
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       // Handle when the user taps on a notification while the app is in the background or terminated
//       print('Message opened app: ${message.messageId}');
//     });
//   }

//   void _showForegroundNotification(RemoteNotification? notification) {
//     // Show the notification content in a dialog (you can customize the UI as needed)
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('New Notification'),
//           content: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               if (notification?.title != null) Text(notification!.title!),
//               if (notification?.body != null) Text(notification!.body!),
//             ],
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _sendNotification(BuildContext context, String message) {
//     // Here you can implement the logic to send the notification to all users
//     // For simplicity, let's just show a snackbar message with the notification content
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Notification: $message')),
//     );
//     // Clear the text field after sending the notification
//     _notificationController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // The rest of your AdminScreen build method remains unchanged...
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Screen'),
//       ),
//       body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//         future: FirebaseFirestore.instance
//             .collection('users')
//             .doc(FirebaseAuth.instance.currentUser?.uid)
//             .get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             // Data is still loading
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasData && snapshot.data?.exists == true) {
//             // User data is available
//             Map<String, dynamic>? userData = snapshot.data?.data();
//             if (userData != null) {
//               // Extract the user's email
//               String email = userData['email'];
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(16.0),
//                     color: Colors.blue,
//                     child: Text(
//                       'Admin Screen',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Email: $email',
//                             style: TextStyle(fontSize: 18),
//                           ),
//                           SizedBox(height: 32),
//                           Expanded(
//                             child: GridView.count(
//                               crossAxisCount: 2,
//                               children: [
//                                 StreamBuilder<
//                                     QuerySnapshot<Map<String, dynamic>>>(
//                                   stream: FirebaseFirestore.instance
//                                       .collection('users')
//                                       .snapshots(),
//                                   builder: (context, snapshot) {
//                                     if (snapshot.hasError) {
//                                       return Text('Error: ${snapshot.error}');
//                                     }

//                                     if (snapshot.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return Center(
//                                           child: CircularProgressIndicator());
//                                     }

//                                     int userCount = snapshot.data!.docs.length;

//                                     return ElevatedButton(
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 UserDataScreen(),
//                                           ),
//                                         );
//                                       },
//                                       child: Column(
//                                         children: [
//                                           Text('User'),
//                                           Text('Total: $userCount'),
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             ParkingDataScreen(),
//                                       ),
//                                     );
//                                   },
//                                   child: Text('Places'),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             UserManageScreen(),
//                                       ),
//                                     );
//                                   },
//                                   child: Text('Users (Manage)'),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             ParkingManageScreen(),
//                                       ),
//                                     );
//                                   },
//                                   child: Text('Places (Manage)'),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 16),
//                           ElevatedButton(
//                             onPressed: () {
//                               FirebaseAuth.instance.signOut();
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => LoginScreen(),
//                                 ),
//                               );
//                             },
//                             child: Text('Logout'),
//                           ),
//                           SizedBox(height: 16), // Add some spacing

//                           // New Box with Text Field and Send Button
//                           Container(
//                             padding: EdgeInsets.all(16.0),
//                             color: Colors.white,
//                             child: Column(
//                               children: [
//                                 TextField(
//                                   controller: _notificationController,
//                                   decoration: InputDecoration(
//                                     labelText: 'Type your notification here',
//                                     border: OutlineInputBorder(),
//                                   ),
//                                 ),
//                                 SizedBox(height: 16),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     String message =
//                                         _notificationController.text.trim();
//                                     if (message.isNotEmpty) {
//                                       _sendNotification(context, message);
//                                     } else {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(
//                                         SnackBar(
//                                             content:
//                                                 Text('Please enter a message')),
//                                       );
//                                     }
//                                   },
//                                   child: Text('Send Notification'),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             }
//           }
//           // User data not found
//           return Center(child: Text('User data not found'));
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:learn01/src/features/authentication/screens/login/login_screen.dart';

import '../admin/parking_data.dart';
import '../admin/parking_manage.dart';
import '../admin/user_data.dart';
import '../admin/user_manage.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final TextEditingController _notificationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
  }

  void _setupFirebaseMessaging() {
    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        // Show a notification in the foreground when receiving a message with a notification payload (optional)
        _showForegroundNotification(message.notification);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle when the user taps on a notification while the app is in the background or terminated
      print('Message opened app: ${message.messageId}');
    });
  }

  void _showForegroundNotification(RemoteNotification? notification) {
    // Show the notification content in a dialog (you can customize the UI as needed)
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New Notification'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (notification?.title != null) Text(notification!.title!),
              if (notification?.body != null) Text(notification!.body!),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _sendNotification(BuildContext context, String message) {
    // Here you can implement the logic to send the notification to all users
    // For simplicity, let's just show a snackbar message with the notification content
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification: $message')),
    );
    // Clear the text field after sending the notification
    _notificationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // The rest of your AdminScreen build method remains unchanged...
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Admin Dashboard'),
          backgroundColor: Color.fromARGB(255, 2, 80, 113),
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
                      // color: Colors.blue,
                      // child: Text(
                      //   'Welcome back Admin ',
                      //   style: TextStyle(
                      //     fontSize: 24,
                      //     fontWeight: FontWeight.bold,
                      //     color: Colors.white,
                      //   ),
                      // ),
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
                                  StreamBuilder<
                                      QuerySnapshot<Map<String, dynamic>>>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }

                                      int userCount =
                                          snapshot.data!.docs.length;

                                      return ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UserDataScreen(),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            Text(
                                              'User',
                                              style: TextStyle(
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Total: $userCount',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Color.fromARGB(
                                                      255, 12, 57, 76)),
                                        ),
                                      );
                                    },
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ParkingDataScreen(),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          'Places',
                                          style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        StreamBuilder<
                                            QuerySnapshot<
                                                Map<String, dynamic>>>(
                                          stream: FirebaseFirestore.instance
                                              .collection('space')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            }

                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Text('Loading...');
                                            }

                                            int spaceCount =
                                                snapshot.data!.docs.length;

                                            return Text(
                                              'Total: $spaceCount',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color.fromARGB(255, 2, 80, 113)),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UserManageScreen(),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          'Users',
                                          style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '(Manage)',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color.fromARGB(255, 2, 80, 113)),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ParkingManageScreen(),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          'Places',
                                          style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '(Manage)',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color.fromARGB(255, 12, 57, 76)),
                                    ),
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
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all<Size>(
                                    Size(100, 50)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromARGB(255, 21, 100, 169)),
                                shadowColor: MaterialStateProperty.all<Color>(
                                    Color.fromARGB(255, 201, 185, 186)),
                                elevation:
                                    MaterialStateProperty.all<double>(70),
                              ),
                              child: Text(
                                'Logout',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            SizedBox(height: 16), // Add some spacing

                            // New Box with Text Field and Send Button
                            Container(
                              padding: EdgeInsets.all(16.0),
                              color: Colors.white,
                              child: Column(
                                children: [
                                  TextField(
                                    controller: _notificationController,
                                    decoration: InputDecoration(
                                      labelText: 'Type your notification here',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      String message =
                                          _notificationController.text.trim();
                                      if (message.isNotEmpty) {
                                        _sendNotification(context, message);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Please enter a message')),
                                        );
                                      }
                                    },
                                    child: Text('Send Notification',
                                        style: TextStyle(fontSize: 15)),
                                    style: ButtonStyle(
                                      minimumSize:
                                          MaterialStateProperty.all<Size>(
                                              Size(130, 50)),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color.fromARGB(
                                                  255, 21, 100, 169)),
                                      shadowColor: MaterialStateProperty.all<
                                              Color>(
                                          Color.fromARGB(255, 21, 246, 246)),
                                      elevation:
                                          MaterialStateProperty.all<double>(70),
                                    ),
                                  ),
                                ],
                              ),
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
      ),
    );
  }
}
