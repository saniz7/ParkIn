import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learn01/googlescreen.dart';
import 'package:learn01/src/features/authentication/screens/home_screen/mapscreen.dart';
import 'package:learn01/src/utils/theme/theme.dart';

import 'Coordinate_conversion.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: CoordinateConversion(),
      //Home(),
    );
  }
}
