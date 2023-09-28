// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class UserDataScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Data'),
//       ),
//       body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//         stream: FirebaseFirestore.instance.collection('users').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           List<DataRow> rows = [];

//           snapshot.data!.docs.forEach((doc) {
//             Map<String, dynamic>? userData = doc.data();
//             String username = userData?['username'] ?? '';
//             String email = userData?['email'] ?? '';
//             dynamic phoneno = userData?['phoneno'];

//             rows.add(
//               DataRow(
//                 cells: [
//                   DataCell(Text(username)),
//                   DataCell(Text(email)),
//                   DataCell(Text(phoneno?.toString() ?? '')),
//                 ],
//               ),
//             );
//           });

//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: DataTable(
//               columns: [
//                 DataColumn(label: Text('Username')),
//                 DataColumn(label: Text('Email')),
//                 DataColumn(label: Text('Phone No')),
//               ],
//               rows: rows,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// 2
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class UserDataScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Data'),
//       ),
//       body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//         stream: FirebaseFirestore.instance.collection('users').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           List<DataRow> rows = [];

//           snapshot.data!.docs.forEach((doc) {
//             Map<String, dynamic>? userData = doc.data();
//             String username = userData?['username'] ?? '';
//             String email = userData?['email'] ?? '';
//             dynamic phoneno = userData?['phoneno'];
//             String password = userData?['password'] ?? '';
//             String uid = doc.id;
//             String role = userData?['role'] ?? '';

//             rows.add(
//               DataRow(
//                 cells: [
//                   DataCell(GestureDetector(
//                     child: Text(username),
//                     onTap: () {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: Text('User Details'),
//                             content: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text('Username: $username'),
//                                 Text('Email: $email'),
//                                 Text('Phone No: ${phoneno?.toString() ?? ''}'),
//                                 Text('Password: $password'),
//                                 Text('UID: $uid'),
//                                 Text('Role: $role'),
//                               ],
//                             ),
//                             actions: [
//                               ElevatedButton(
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                 },
//                                 child: Text('Close'),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                   )),
//                 ],
//               ),
//             );
//           });

//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: DataTable(
//               columns: [
//                 DataColumn(label: Text('Username')),
//               ],
//               rows: rows,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// 3
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('User Data'),
          backgroundColor: Color.fromARGB(255, 2, 80, 113),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            List<DataRow> rows = [];

            snapshot.data!.docs.forEach((doc) {
              Map<String, dynamic>? userData = doc.data();
              String username = userData?['username'] ?? '';
              String email = userData?['email'] ?? '';
              String phoneno = userData?['phoneno'].toString() ?? '';
              String password = userData?['password'] ?? '';
              String uid = doc.id;
              String role = userData?['role'] ?? '';

              rows.add(
                DataRow(
                  cells: [
                    DataCell(
                      GestureDetector(
                        child: Text(
                          username,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          _showUserDetailsDialog(context, username, email,
                              phoneno, password, uid, role);
                        },
                      ),
                    ),
                  ],
                ),
              );
            });

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  dataTextStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                  columnSpacing: 16.0,
                  columns: [
                    DataColumn(
                      label: Text('Username'),
                      numeric: false,
                      tooltip: 'Username',
                    ),
                  ],
                  rows: rows,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showUserDetailsDialog(BuildContext context, String username,
      String email, String phoneno, String password, String uid, String role) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserDetailRow('Username', username),
                _buildUserDetailRow('Email', email),
                _buildUserDetailRow('Phone No', phoneno),
                _buildUserDetailRow('Password', password),
                _buildUserDetailRow('UID', uid),
                _buildUserDetailRow('Role', role),
              ],
            ),
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

  Widget _buildUserDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
