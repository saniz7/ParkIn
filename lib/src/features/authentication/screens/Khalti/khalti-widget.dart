import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

import '../manage_parking_space/widgets/ViewAll_Space_Widget .dart';

class KhaltiPaymentPage extends StatefulWidget {
  const KhaltiPaymentPage({Key? key}) : super(key: key);

  @override
  State<KhaltiPaymentPage> createState() => _KhaltiPaymentPageState();
}

class _KhaltiPaymentPageState extends State<KhaltiPaymentPage> {
  TextEditingController amountController = TextEditingController();

  getAmt() {
    return int.parse(amountController.text) * 100; // Converting to paisa
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khalti Payment'),
      ), // AppBar
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
                  ), // OutlineInputBorder
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  )), // OutlineInputBorder // InputDecoration
            ), // TextField
            const SizedBox(
              height: 8,
            ), // SizedBox
            // For Button
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(
                        color: Colors.red)), // RoundedRectangleBorder
                height: 50,
                color: const Color(0xFF56328c),
                child: const Text(
                  'Pay With Khalti',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ), //text
                onPressed: () {
                  KhaltiScope.of(context).pay(
                    config: PaymentConfig(
                      amount: getAmt(),
                      productIdentity: 'dells-sssssg5-g55108-2021',
                      productName: 'Product Name',
                    ), // PaymentConfig
                    preferences: [
                      PaymentPreference.khalti,
                    ],
                    onSuccess: (su) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewSpaceScreen()),
                      );
                      const successsnackBar = SnackBar(
                        content: Text('Payment Successful'),
                      ); // SnackBar
                      ScaffoldMessenger.of(context)
                          .showSnackBar(successsnackBar);
                    },
                    onFailure: (fa) {
                      const failedsnackBar = SnackBar(
                        content: Text('Payment Failed'),
                      ); // SnackBar
                      ScaffoldMessenger.of(context)
                          .showSnackBar(failedsnackBar);
                    },
                    onCancel: () {
                      const cancelsnakBar = SnackBar(
                        content: Text('paymentCancelled'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(cancelsnakBar);
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
