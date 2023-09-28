// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:learn01/src/features/authentication/screens/home_screen/home_screen.dart';
// import 'package:learn01/src/features/authentication/screens/welcome/welcome_screen.dart';
// import 'package:learn01/src/utils/theme/theme.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: TAppTheme.lightTheme,
//       darkTheme: TAppTheme.darkTheme,
//       themeMode: ThemeMode.system,
//       home: const CustomMarkerInfoWindow(),
//     );
//   }
// }
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:learn01/src/features/authentication/screens/notification/firebase_notification.dart';
import 'package:learn01/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:learn01/src/utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();
  runApp(const KhaltiPaymentApp());
}

class KhaltiPaymentApp extends StatelessWidget {
  const KhaltiPaymentApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: "test_public_key_c5db7d4b9c7141009a8756a18c0af80e",
      builder: (context, navigatorKey) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ne', 'NP'),
          ],
          localizationsDelegates: const [
            KhaltiLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          theme: TAppTheme.lightTheme,
          darkTheme: TAppTheme.darkTheme,
          themeMode: ThemeMode.system,
          // home: CustomMarkerInfoWindow(),
          home: WelcomeScreen(),
        );
      },
    );
  }
}
