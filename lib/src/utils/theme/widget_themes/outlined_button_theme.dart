import 'package:flutter/material.dart';
import 'package:learn01/src/constants/colors.dart';
import 'package:learn01/src/constants/sizes.dart';

/*--lignt and dark Outlined Button Theme --*/

class TOutlinedButtonTheme {
  TOutlinedButtonTheme._(); //to avoid creating instances

  //lignt theme

  static final lightOutLinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(),
      foregroundColor: tSecondaryColor,
      side: BorderSide(color: tSecondaryColor),
      padding: EdgeInsets.symmetric(vertical: tButtonHeight),
    ),
  );

  //dark theme

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(),
      foregroundColor: tWhiteColor,
      side: BorderSide(color: tWhiteColor),
      padding: EdgeInsets.symmetric(vertical: tButtonHeight),
    ),
  );
}
