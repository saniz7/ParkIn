import 'package:flutter/material.dart';
import 'package:learn01/src/constants/sizes.dart';
import 'package:learn01/src/constants/text_strings.dart';

import '../../../../../constants/colors.dart';

class RentSpaceWidget extends StatelessWidget {
  const RentSpaceWidget({
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
              label: Text(tLocation),
              prefixIcon: Icon(Icons.location_city),
            ),
          ),
          SizedBox(
            height: tFormHeight - 20,
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text(tType),
              prefixIcon: Icon(Icons.public_sharp),
            ),
          ),
          SizedBox(
            height: tFormHeight - 20,
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text(tRate),
              prefixIcon: Icon(Icons.currency_exchange_sharp),
            ),
          ),
          SizedBox(
            height: tFormHeight - 20,
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text(tCapacity),
              prefixIcon: Icon(Icons.numbers),
            ),
          ),
          SizedBox(
            height: tFormHeight - 20,
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text(tParkingPlaceImage),
              prefixIcon: Icon(Icons.image),
            ),
          ),
          SizedBox(
            height: tFormHeight - 20,
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text(tAddDescription),
              prefixIcon: Icon(Icons.description),
            ),
          ),
          SizedBox(
            height: tFormHeight - 10,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: tPrimaryColor,
                  side: BorderSide.none,
                  shape: const StadiumBorder()),
              child: const Text(
                tRentYourSpace,
                style: TextStyle(color: tDarkColor),
              ),
            ),
          )
        ],
      )),
    );
  }
}
