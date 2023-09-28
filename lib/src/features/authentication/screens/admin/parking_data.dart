import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ParkingDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Parking Data'),
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
              String spaceName = spaceData?['spacename'] ?? '';

              rows.add(
                DataRow(
                  cells: [
                    DataCell(
                      GestureDetector(
                        child: Text(
                          spaceName,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          _showSpaceDetailsDialog(context, spaceData);
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
                      label: Text('Space Name'),
                      numeric: false,
                      tooltip: 'Space Name',
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

  void _showSpaceDetailsDialog(
      BuildContext context, Map<String, dynamic>? spaceData) {
    if (spaceData == null) return;

    String spaceName = spaceData['spacename'] ?? '';
    int capacity = spaceData['capacity'] is int
        ? spaceData['capacity']
        : int.tryParse(spaceData['capacity'] ?? '0') ?? 0;
    int availableSpace = spaceData['available_space'] is int
        ? spaceData['available_space']
        : int.tryParse(spaceData['available_space'] ?? '0') ?? 0;
    int rate = spaceData['rate'] is int
        ? spaceData['rate']
        : int.tryParse(spaceData['rate'] ?? '0') ?? 0;
    String description = spaceData['description'] ?? '';
    String location = spaceData['location'] ?? '';
    String type = spaceData['type'] ?? '';
    String view = spaceData['view'] ?? '';
    String imageUrl = spaceData['imageUrl'] ?? ''; // Add this line

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Space Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSpaceDetailRow('Space Name', spaceName),
                _buildSpaceDetailRow('Capacity', capacity.toString()),
                _buildSpaceDetailRow(
                    'Available Space', availableSpace.toString()),
                _buildSpaceDetailRow('Rate', rate.toString()),
                _buildSpaceDetailRow('Description', description),
                _buildSpaceDetailRow('Location', location),
                _buildSpaceDetailRow('Type', type),
                _buildSpaceDetailRow('View', view),
                if (imageUrl.isNotEmpty) // Check if imageUrl is not empty
                  Image.network(imageUrl), // Display the image
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

  Widget _buildSpaceDetailRow(String label, String value) {
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
