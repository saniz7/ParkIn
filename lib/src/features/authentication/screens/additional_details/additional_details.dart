import 'package:flutter/material.dart';
import 'package:learn01/src/common_widgets/form/form_header_widget.dart';
import 'package:learn01/src/constants/image_strings.dart';
import 'package:learn01/src/constants/sizes.dart';
import 'package:learn01/src/constants/text_strings.dart';
import 'package:learn01/src/features/authentication/screens/additional_details/widgets/additional_details_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class AdditionalDetails extends StatelessWidget {
  const AdditionalDetails({Key? key}) : super(key: key);

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
            tAddDetails,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(children: [
              FormHeaderWidget(
                image: tExtraDetailsImage,
                title: tAdditionalDetailsTitle,
                subTitle: tAdditionalDetailsSubTitle,
              ),
              const AdditionalDetailsWidget(),
            ]),
          ),
        ),
      ),
    );
  }
}
