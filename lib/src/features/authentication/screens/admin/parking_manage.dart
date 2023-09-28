import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ParkingManageScreen extends StatefulWidget {
  @override
  _ParkingManageScreenState createState() => _ParkingManageScreenState();
}

class _ParkingManageScreenState extends State<ParkingManageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _spaceNameController = TextEditingController();
  final _capacityController = TextEditingController();
  final _availableSpaceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _locationController = TextEditingController();
  final _rateController = TextEditingController();
  final _typeController = TextEditingController();
  final _viewController = TextEditingController();
  bool _isEditing = false;
  late String _spaceId;

  @override
  void dispose() {
    _spaceNameController.dispose();
    _capacityController.dispose();
    _availableSpaceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _locationController.dispose();
    _rateController.dispose();
    _typeController.dispose();
    _viewController.dispose();
    super.dispose();
  }

  void _editSpace(
      String spaceId,
      String spaceName,
      int capacity,
      int availableSpace,
      String description,
      String imageUrl,
      String location,
      int rate,
      String type,
      String view) {
    setState(() {
      _isEditing = true;
      _spaceId = spaceId;
      _spaceNameController.text = spaceName;
      _capacityController.text = capacity.toString();
      _availableSpaceController.text = availableSpace.toString();
      _descriptionController.text = description;
      _imageUrlController.text = imageUrl;
      _locationController.text = location;
      _rateController.text = rate.toString();
      _typeController.text = type;
      _viewController.text = view;
    });
  }

  void _saveSpace() {
    if (_formKey.currentState!.validate()) {
      final updatedSpace = {
        'spacename': _spaceNameController.text.trim(),
        'capacity': int.tryParse(_capacityController.text.trim()) ?? 0,
        'available_space':
            int.tryParse(_availableSpaceController.text.trim()) ?? 0,
        'description': _descriptionController.text.trim(),
        'imageUrl': _imageUrlController.text.trim(),
        'location': _locationController.text.trim(),
        'rate': int.tryParse(_rateController.text.trim()) ?? 0,
        'type': _typeController.text.trim(),
        'view': _viewController.text.trim(),
      };

      FirebaseFirestore.instance
          .collection('space')
          .doc(_spaceId)
          .update(updatedSpace)
          .then((_) {
        setState(() {
          _isEditing = false;
          _spaceId = '';
          _spaceNameController.clear();
          _capacityController.clear();
          _availableSpaceController.clear();
          _descriptionController.clear();
          _imageUrlController.clear();
          _locationController.clear();
          _rateController.clear();
          _typeController.clear();
          _viewController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Parking space updated successfully'),
        ));
        Navigator.of(context).pop(); // Dismiss the edit space dialog
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update parking space: $error'),
          backgroundColor: Colors.red,
        ));
      });
    }
  }

  void _deleteSpace(String spaceId) {
    FirebaseFirestore.instance
        .collection('space')
        .doc(spaceId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Parking space deleted successfully'),
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete parking space: $error'),
        backgroundColor: Colors.red,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Parking Space (Manage)'),
          backgroundColor: Color.fromARGB(255, 2, 80, 113),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('space').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            List<DataRow> rows = [];

            snapshot.data!.docs.forEach((doc) {
              Map<String, dynamic>? spaceData = doc.data();
              String spaceId = doc.id;
              String spaceName = spaceData?['spacename'] ?? '';
              int capacity = spaceData?['capacity'] is int
                  ? spaceData!['capacity']
                  : int.tryParse(spaceData!['capacity'] ?? '0') ?? 0;
              int availableSpace = spaceData?['available_space'] is int
                  ? spaceData!['available_space']
                  : int.tryParse(spaceData!['available_space'] ?? '0') ?? 0;
              String description = spaceData?['description'] ?? '';
              String imageUrl = spaceData?['imageUrl'] ?? '';
              String location = spaceData?['location'] ?? '';
              int rate = spaceData?['rate'] is int
                  ? spaceData!['rate']
                  : int.tryParse(spaceData!['rate'] ?? '0') ?? 0;
              String type = spaceData?['type'] ?? '';
              String view = spaceData?['view'] ?? '';

              rows.add(
                DataRow(
                  cells: [
                    DataCell(Text(spaceName)),
                    DataCell(Text(capacity.toString())),
                    DataCell(Text(availableSpace.toString())),
                    DataCell(Text(description)),
                    DataCell(imageUrl.isNotEmpty
                        ? Image.network(imageUrl)
                        : Text(
                            'No Image')), // Show 'No Image' if the imageUrl is empty
                    DataCell(Text(location)),
                    DataCell(Text(rate.toString())),
                    DataCell(Text(type)),
                    DataCell(Text(view)),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editSpace(
                              spaceId,
                              spaceName,
                              capacity,
                              availableSpace,
                              description,
                              imageUrl,
                              location,
                              rate,
                              type,
                              view);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Edit Parking Space'),
                                content: SingleChildScrollView(
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          controller: _spaceNameController,
                                          decoration: InputDecoration(
                                              labelText: 'Space Name'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a space name';
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller: _capacityController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              labelText: 'Capacity'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter the capacity';
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller: _availableSpaceController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              labelText: 'Available Space'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter the available space';
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller: _descriptionController,
                                          decoration: InputDecoration(
                                              labelText: 'Description'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a description';
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller: _imageUrlController,
                                          decoration: InputDecoration(
                                              labelText: 'Image URL'),
                                          validator: (value) {
                                            // You can add URL validation here if needed
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller: _locationController,
                                          decoration: InputDecoration(
                                              labelText: 'Location'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a location';
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller: _rateController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              labelText: 'Rate'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter the rate';
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller: _typeController,
                                          decoration: InputDecoration(
                                              labelText: 'Type'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a type';
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller: _viewController,
                                          decoration: InputDecoration(
                                              labelText: 'View'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a view';
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
                                      _saveSpace();
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
                          _deleteSpace(spaceId);
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
                    DataColumn(label: Text('Space Name')),
                    DataColumn(label: Text('Capacity')),
                    DataColumn(label: Text('Available Space')),
                    DataColumn(label: Text('Description')),
                    DataColumn(label: Text('Image URL')),
                    DataColumn(label: Text('Location')),
                    DataColumn(label: Text('Rate')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('View')),
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
