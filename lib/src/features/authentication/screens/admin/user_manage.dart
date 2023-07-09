// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class UserManageScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User (Manage)'),
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
//             String phoneno = userData?['phoneno']?.toString() ?? '';
//             String password = userData?['password'] ?? '';
//             String role = userData?['role'] ?? '';

//             rows.add(
//               DataRow(
//                 cells: [
//                   DataCell(Text(username)),
//                   DataCell(Text(email)),
//                   DataCell(Text(phoneno)),
//                   DataCell(Text(password)),
//                   DataCell(Text(role)),
//                   DataCell(
//                     IconButton(
//                       icon: Icon(Icons.edit),
//                       onPressed: () {
//                         // Perform edit action for the user
//                         // Replace with your desired functionality
//                       },
//                     ),
//                   ),
//                   DataCell(
//                     IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         // Perform delete action for the user
//                         // Replace with your desired functionality
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           });

//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: DataTable(
//                 columns: [
//                   DataColumn(label: Text('Username')),
//                   DataColumn(label: Text('Email')),
//                   DataColumn(label: Text('Phone No')),
//                   DataColumn(label: Text('Password')),
//                   DataColumn(label: Text('Role')),
//                   DataColumn(label: Text('Edit')),
//                   DataColumn(label: Text('Delete')),
//                 ],
//                 rows: rows,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManageScreen extends StatefulWidget {
  @override
  _UserManageScreenState createState() => _UserManageScreenState();
}

class _UserManageScreenState extends State<UserManageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phonenoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _roleController = TextEditingController();
  bool _isEditing = false;
  late String _userId;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phonenoController.dispose();
    _passwordController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _editUser(String userId, String username, String email, String phoneno,
      String password, String role) {
    setState(() {
      _isEditing = true;
      _userId = userId;
      _usernameController.text = username;
      _emailController.text = email;
      _phonenoController.text = phoneno;
      _passwordController.text = password;
      _roleController.text = role;
    });
  }

  void _saveUser() {
    if (_formKey.currentState!.validate()) {
      final updatedUser = {
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'phoneno': _phonenoController.text.trim(),
        'password': _passwordController.text.trim(),
        'role': _roleController.text.trim(),
      };

      FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .update(updatedUser)
          .then((_) {
        setState(() {
          _isEditing = false;
          _userId = '';
          _usernameController.clear();
          _emailController.clear();
          _phonenoController.clear();
          _passwordController.clear();
          _roleController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User updated successfully'),
        ));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update user: $error'),
          backgroundColor: Colors.red,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User (Manage)'),
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
            String userId = doc.id;
            String username = userData?['username'] ?? '';
            String email = userData?['email'] ?? '';
            String phoneno = userData?['phoneno']?.toString() ?? '';
            String password = userData?['password'] ?? '';
            String role = userData?['role'] ?? '';

            rows.add(
              DataRow(
                cells: [
                  DataCell(Text(username)),
                  DataCell(Text(email)),
                  DataCell(Text(phoneno)),
                  DataCell(Text(password)),
                  DataCell(Text(role)),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _editUser(
                            userId, username, email, phoneno, password, role);
                      },
                    ),
                  ),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Perform delete action for the user
                        // Replace with your desired functionality
                      },
                    ),
                  ),
                ],
              ),
            );
          });

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Username')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Phone No')),
                  DataColumn(label: Text('Password')),
                  DataColumn(label: Text('Role')),
                  DataColumn(label: Text('Edit')),
                  DataColumn(label: Text('Delete')),
                ],
                rows: rows,
              ),
            ),
          );
        },
      ),
      floatingActionButton: _isEditing ? _buildSaveButton() : null,
    );
  }

  Widget _buildSaveButton() {
    return FloatingActionButton(
      onPressed: _saveUser,
      child: Icon(Icons.save),
    );
  }
}
