// import 'package:flutter/material.dart';
// import 'package:khalti_flutter/khalti_flutter.dart';

// import 'khalti-widget.dart';

// void main() => runApp(const KhaltiPaymentApp());

// class KhaltiPaymentApp extends StatelessWidget {
//   const KhaltiPaymentApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return KhaltiScope(
//       publicKey: "test_public_key_c5db7d4b9c7141009a8756a18c0af80e",
//       builder: (context, navigatorKey) {
//         return MaterialApp(
//           navigatorKey: navigatorKey,
//           supportedLocales: const [
//             Locale('en', 'US'),
//             Locale('ne', 'NP'),
//           ],
//           localizationsDelegates: const [
//             KhaltiLocalizations.delegate,
//           ],
//           theme: ThemeData(
//               primaryColor: Color(0xFF56328c),
//               appBarTheme: const AppBarTheme(
//                 color: Color(0xFF56328c),
//               )), // AppBarTheme // ThemeData
//           title: 'Khalti Payment',
//           home: KhaltiPaymentPage(),
//         );
//       },
//     );
//   }
// }
