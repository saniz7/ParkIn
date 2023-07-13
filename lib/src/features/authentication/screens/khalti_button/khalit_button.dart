import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:learn01/src/features/authentication/screens/manage_parking_space/widgets/ViewAll_Space_Widget%20.dart';

class KhaltiBtn extends StatefulWidget {
  const KhaltiBtn({Key? key});

  @override
  State<KhaltiBtn> createState() => _KhaltiBtnState();
}

class _KhaltiBtnState extends State<KhaltiBtn> {
  String referenceId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Khalti Payment")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                payWithKhaltiInApp();
              },
              child: const Text("Pay with Khalti"),
            ),
            Text(referenceId),
          ],
        ),
      ),
    );
  }

  payWithKhaltiInApp() {
    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        amount: 1000,
        productIdentity: "Product id",
        productName: "Product Name",
      ),
      preferences: [
        PaymentPreference.khalti,
      ],
      onSuccess: onSuccess,
      onFailure: onFailure,
      onCancel: onCancel,
    );
  }

  void onSuccess(PaymentSuccessModel success) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewSpaceScreen()),
    );
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       title: const Text("Payment Successful"),
    //       // actions: [
    //       //   SimpleDialogOption(
    //       //     child: const Text("OK"),
    //       //     onPressed: () {
    //       //       Navigator.pop(context); // Close the dialog
    //       //     },
    //       //   )
    //       // ],
    //     );
    //   },
    // );
  }

  void onFailure(PaymentFailureModel failure) {
    debugPrint(failure.toString());
  }

  void onCancel() {
    debugPrint("Cancelled");
  }
}
