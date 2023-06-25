import 'package:flutter/material.dart';
import 'package:learn01/src/constants/sizes.dart';
import 'package:learn01/src/constants/text_strings.dart';

class AdditionalDetailsWidget extends StatelessWidget {
  const AdditionalDetailsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
      child: Form(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              label: Text(tCitizenShipNo),
              prefixIcon: Icon(Icons.numbers_outlined),
            ),
          ),
          SizedBox(
            height: tFormHeight - 20,
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text(tSecondaryPhoneNo),
              prefixIcon: Icon(Icons.phone),
            ),
          ),
          SizedBox(
            height: tFormHeight - 20,
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text(tUploadDocument),
              prefixIcon: Icon(Icons.upload_file_sharp),
            ),
          ),
          SizedBox(
            height: tFormHeight - 20,
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text(tUplaodImage),
              prefixIcon: Icon(Icons.upload_rounded),
            ),
          ),
          SizedBox(
            height: tFormHeight - 10,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Text(tAddDetails.toUpperCase()),
            ),
          )
        ],
      )),
    );
  }
}
