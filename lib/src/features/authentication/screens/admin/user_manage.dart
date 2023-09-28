// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class UserManageScreen extends StatefulWidget {
//   @override
//   _UserManageScreenState createState() => _UserManageScreenState();
// }

// class _UserManageScreenState extends State<UserManageScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _usernameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phonenoController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _roleController = TextEditingController();
//   bool _isEditing = false;
//   late String _userId;

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _emailController.dispose();
//     _phonenoController.dispose();
//     _passwordController.dispose();
//     _roleController.dispose();
//     super.dispose();
//   }

//   void _editUser(String userId, String username, String email, String phoneno,
//       String password, String role) {
//     setState(() {
//       _isEditing = true;
//       _userId = userId;
//       _usernameController.text = username;
//       _emailController.text = email;
//       _phonenoController.text = phoneno;
//       _passwordController.text = password;
//       _roleController.text = role;
//     });
//   }

//   void _saveUser() {
//     if (_formKey.currentState!.validate()) {
//       final updatedUser = {
//         'username': _usernameController.text.trim(),
//         'email': _emailController.text.trim(),
//         'phoneno': _phonenoController.text.trim(),
//         'password': _passwordController.text.trim(),
//         'role': _roleController.text.trim(),
//       };

//       FirebaseFirestore.instance
//           .collection('users')
//           .doc(_userId)
//           .update(updatedUser)
//           .then((_) {
//         setState(() {
//           _isEditing = false;
//           _userId = '';
//           _usernameController.clear();
//           _emailController.clear();
//           _phonenoController.clear();
//           _passwordController.clear();
//           _roleController.clear();
//         });
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('User updated successfully'),
//         ));
//       }).catchError((error) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Failed to update user: $error'),
//           backgroundColor: Colors.red,
//         ));
//       });
//     }
//   }

//   void _deleteUser(String userId) {
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .delete()
//         .then((_) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('User deleted successfully'),
//       ));
//     }).catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Failed to delete user: $error'),
//         backgroundColor: Colors.red,
//       ));
//     });
//   }

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
//             String userId = doc.id;
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
//                         _editUser(
//                             userId, username, email, phoneno, password, role);
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: Text('Edit User'),
//                               content: Form(
//                                 key: _formKey,
//                                 child: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     TextFormField(
//                                       controller: _usernameController,
//                                       decoration: InputDecoration(
//                                           labelText: 'Username'),
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Please enter a username';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                     TextFormField(
//                                       controller: _emailController,
//                                       decoration:
//                                           InputDecoration(labelText: 'Email'),
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Please enter an email';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                     TextFormField(
//                                       controller: _phonenoController,
//                                       decoration: InputDecoration(
//                                           labelText: 'Phone No'),
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Please enter a phone number';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                     TextFormField(
//                                       controller: _passwordController,
//                                       decoration: InputDecoration(
//                                           labelText: 'Password'),
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Please enter a password';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                     TextFormField(
//                                       controller: _roleController,
//                                       decoration:
//                                           InputDecoration(labelText: 'Role'),
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Please enter a role';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               actions: [
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: Text('Cancel'),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     _saveUser();
//                                   },
//                                   child: Text('Save'),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                   DataCell(
//                     IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         _deleteUser(userId);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           });

import 'package:cloud_firestore/cloud_firestore.dart';
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
        Navigator.of(context).pop(); // Dismiss the edit user dialog
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update user: $error'),
          backgroundColor: Colors.red,
        ));
      });
    }
  }

  void _deleteUser(String userId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('User deleted successfully'),
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete user: $error'),
        backgroundColor: Colors.red,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 2, 80, 113),
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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Edit User'),
                                content: SingleChildScrollView(
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          controller: _usernameController,
                                          decoration: InputDecoration(
                                              labelText: 'Username'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a username';
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller: _emailController,
                                          decoration: InputDecoration(
                                              labelText: 'Email'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter an email';
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller: _phonenoController,
                                          decoration: InputDecoration(
                                              labelText: 'Phone No'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a phone number';
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller: _passwordController,
                                          decoration: InputDecoration(
                                              labelText: 'Password'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a password';
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller: _roleController,
                                          decoration: InputDecoration(
                                              labelText: 'Role'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a role';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _saveUser();
                                    },
                                    child: Text('Save'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteUser(userId);
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
      ),
    );
  }
}
