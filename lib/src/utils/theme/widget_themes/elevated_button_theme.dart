import 'package:flutter/material.dart';
import 'package:learn01/src/constants/colors.dart';
import 'package:learn01/src/constants/sizes.dart';

/*--lignt and dark elevated Button Theme --*/

class TElevatedButtonTheme {
  TElevatedButtonTheme._(); //to avoid creating instances

  //lignt theme
  static final ligntElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(),
      foregroundColor: tWhiteColor,
      backgroundColor: tSecondaryColor,
      side: BorderSide(color: tSecondaryColor),
      padding: EdgeInsets.symmetric(vertical: tButtonHeight),
    ),
  );

  //dark theme

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(),
      foregroundColor: tSecondaryColor,
      backgroundColor: tWhiteColor,
      side: BorderSide(color: tSecondaryColor),
      padding: EdgeInsets.symmetric(vertical: tButtonHeight),
    ),
  );
}
