import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:learn01/src/constants/api_key.dart';
import 'package:learn01/src/features/authentication/screens/khalti_button/khalit_button.dart';
import 'package:learn01/src/utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const KhaltiTest());
}

class KhaltiTest extends StatelessWidget {
  const KhaltiTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
        publicKey: khaltiPublicKey,
        enabledDebugging: true,
        builder: (context, navkey) {
          return MaterialApp(
            theme: TAppTheme.lightTheme,
            darkTheme: TAppTheme.darkTheme,
            themeMode: ThemeMode.system,
            home: const KhaltiBtn(),

            navigatorKey: navkey,
            localizationsDelegates: const [KhaltiLocalizations.delegate],
            //Home(),
          );
        });
  }
}
