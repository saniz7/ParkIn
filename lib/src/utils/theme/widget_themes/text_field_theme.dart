import 'package:flutter/material.dart';
import 'package:learn01/src/constants/colors.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme =
    const InputDecorationTheme(
      border: OutlineInputBorder(),
      prefixIconColor: tPrimaryColor,
      floatingLabelStyle: TextStyle(color: tPrimaryColor),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2,color: tPrimaryColor),
      )
    );

    static InputDecorationTheme darkInputDecorationTheme =
    const InputDecorationTheme(
      border: OutlineInputBorder(),
      prefixIconColor: tPrimaryColor,
      floatingLabelStyle: TextStyle(color: tPrimaryColor),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2,color: tPrimaryColor),
      )
    );
}
