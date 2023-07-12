import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learn01/src/features/authentication/screens/Khalti/khalti-home.dart';
import 'package:learn01/src/features/authentication/screens/notification/firebase_notification.dart';
import 'package:learn01/src/utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();
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
      home: KhaltiPaymentApp(),
      //WelcomeScreen(),
      //Home(),
    );
  }
}
