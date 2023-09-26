import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../manage_parking_space/widgets/ViewAll_Space_Widget .dart';
import '../parkingspace/ViewParking_Space_Widget .dart';

class KhaltiPaymentPage extends StatefulWidget {
  final time;
  final int rate;
  final String name;
  final String description;
  final String pid;
  final String uid;
  final int vehicleno;

  const KhaltiPaymentPage(
      {Key? key,
      required this.time,
      required this.rate,
      required this.description,
      required this.name,
      required this.uid,
      required this.pid,
      required this.vehicleno})
      : super(key: key);

  @override
  State<KhaltiPaymentPage> createState() => _KhaltiPaymentPageState();
}

class _KhaltiPaymentPageState extends State<KhaltiPaymentPage> {
  TextEditingController amountController = TextEditingController();

  getAmt() {
    return int.parse(amountController.text) * 100; // Converting to paisa
  }

  void storeBookingData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Prepare the booking data
      Map<String, dynamic> bookingData = {
        'time': widget.time,
        'rate': widget.rate,
        'name': widget.name,
        'description': widget.description,
        'pid': widget.pid,
        'uid': widget.uid,
        'vehicleno': widget.vehicleno,
        // Add other necessary booking data here
      };

      // Store the booking data in Firestore
      await firestore.collection('booking').doc().set(bookingData);

      const successsnackBar = SnackBar(
        content: Text('Payment Successful'),
      );
      ScaffoldMessenger.of(context).showSnackBar(successsnackBar);
    } catch (e) {
      const failedsnackBar = SnackBar(
        content: Text('Failed to store booking data'),
      );
      ScaffoldMessenger.of(context).showSnackBar(failedsnackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khalti Payment'),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            const SizedBox(height: 15),
            // For Amount
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter Amount to pay",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            // For Button
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.red),
              ),
              height: 50,
              color: const Color(0xFF56328c),
              child: const Text(
                'Pay With Khalti',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              onPressed: () {
                KhaltiScope.of(context).pay(
                  config: PaymentConfig(
                    amount: getAmt(),
                    productIdentity: 'dells-sssssg5-g55108-2021',
                    productName: 'Product Name',
                  ),
                  preferences: [PaymentPreference.khalti],
                  onSuccess: (su) {
                    // Store the booking data in Firestore
                    storeBookingData();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewAllParkingSpaceScreen()),
                    );

                    const successsnackBar = SnackBar(
                      content: Text('Payment Successful'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(successsnackBar);
                  },
                  onFailure: (fa) {
                    const failedsnackBar = SnackBar(
                      content: Text('Payment Failed'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(failedsnackBar);
                  },
                  onCancel: () {
                    const cancelsnakBar = SnackBar(
                      content: Text('Payment Cancelled'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(cancelsnakBar);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
