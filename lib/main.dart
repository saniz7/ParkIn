import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learn01/googlescreen.dart';
import 'package:learn01/src/features/authentication/screens/home_screen/mapscreen.dart';
import 'package:learn01/src/features/authentication/screens/welcome/welcome_screen.dart';
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




// notification code 

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:learn01/googlescreen.dart';
// import 'package:learn01/src/features/authentication/screens/home_screen/mapscreen.dart';
// import 'package:learn01/src/features/authentication/screens/welcome/welcome_screen.dart';
// import 'package:learn01/src/utils/theme/theme.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   runApp(MyApp());
// }

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
//   // Add your custom code to handle the background message here.
// }

// class MyApp extends StatelessWidget {
//   MyApp({Key? key}) : super(key: key) {
//     configureFirebaseMessaging();
//   }

//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   void configureFirebaseMessaging() {
//     _firebaseMessaging.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     _firebaseMessaging.getInitialMessage().then((message) {
//       if (message != null) {
//         // Handle the initial message when the app is launched from a notification
//         // You can extract data from the message and navigate to a specific screen if needed.
//       }
//     });

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       // Handle incoming messages when the app is in the foreground
//       // You can extract data from the message and display a notification, update UI, etc.
//       print(
//           "Received a message in the foreground: ${message.notification?.body}");
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       // Handle when the user taps on a notification while the app is in the background or terminated
//       // You can extract data from the message and navigate to a specific screen if needed.
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: TAppTheme.lightTheme,
//       darkTheme: TAppTheme.darkTheme,
//       themeMode: ThemeMode.system,
//       home: WelcomeScreen(),
//     );
//   }
// }
