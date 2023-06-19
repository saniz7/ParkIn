import 'package:flutter/material.dart';
import 'package:learn01/src/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:learn01/src/utils/theme/widget_themes/outlined_button_theme.dart';
import 'package:learn01/src/utils/theme/widget_themes/text_field_theme.dart';
import 'package:learn01/src/utils/theme/widget_themes/text_theme.dart';

class TAppTheme {
  //making a constructer private
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.green,
    textTheme: TTextTheme.lightTextTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutLinedButtonTheme,
    elevatedButtonTheme: TElevatedButtonTheme.ligntElevatedButtonTheme,
  );
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: TTextTheme.darkTextTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
  );
}

//  brightness: Brightness.light, primarySwatch: Colors.deepPurple),