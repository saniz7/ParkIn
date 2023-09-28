import 'package:flutter/material.dart';
import 'package:learn01/src/common_widgets/form/form_header_widget.dart';
import 'package:learn01/src/constants/image_strings.dart';
import 'package:learn01/src/constants/sizes.dart';
import 'package:learn01/src/constants/text_strings.dart';
import 'package:learn01/src/features/authentication/screens/rent_out_your_space/widgets/rent_out_your_space_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class RentSpace extends StatelessWidget {
  const RentSpace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(LineAwesomeIcons.angle_double_left),
          ),
          title: Text(
            tRentYourSpace,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(children: [
              FormHeaderWidget(
                image: tRentYourSpaceImage,
                // title: tAdditionalDetailsTitle,
                subTitle: tRentYourSpaceSubTitle,
              ),
              const RentSpaceWidget(),
            ]),
          ),
        ),
      ),
    );
  }
}
