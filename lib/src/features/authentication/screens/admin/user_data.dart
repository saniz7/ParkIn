import 'package:flutter/material.dart';

class UserDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data'),
      ),
      body: Center(
        child: Text('User Data Screen'),
      ),
    );
  }
}

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

//           List<TableRow> rows = [];

//           snapshot.data!.docs.forEach((doc) {
//             Map<String, dynamic>? userData = doc.data();
//             String username = userData?['username'] ?? '';
//             String email = userData?['email'] ?? '';

//             rows.add(
//               TableRow(
//                 children: [
//                   TableCell(child: Text(username)),
//                   TableCell(child: Text(email)),
//                 ],
//               ),
//             );
//           });

//           return SingleChildScrollView(
//             child: Table(
//               border: TableBorder.all(),
//               defaultColumnWidth: IntrinsicColumnWidth(),
//               children: [
//                 TableRow(
//                   children: [
//                     TableCell(child: Text('Username')),
//                     TableCell(child: Text('Email')),
//                   ],
//                 ),
//                 ...rows,
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
