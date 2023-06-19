import 'package:flutter/material.dart';
import 'package:learn01/src/constants/colors.dart';
import 'package:learn01/src/constants/image_strings.dart';
import 'package:learn01/src/constants/sizes.dart';
import 'package:learn01/src/constants/text_strings.dart';
import 'package:learn01/src/features/authentication/screens/login/login_screen.dart';
import 'package:learn01/src/features/authentication/screens/signup/signup_screen.dart';

import '../../../../../auth/home.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    var height = mediaQuery.size.height;
    final isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? tSecondaryColor : Colors.white,
      body: Container(
          padding: EdgeInsets.all(tDefaultSize),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(
                image: AssetImage(tWelcomeScreenImage1),
                height: height * 0.6,
              ),
              Column(
                children: [
                  Text(tWelcomeTitle,
                      style: Theme.of(context).textTheme.headlineMedium),
                  Text(
                    twelcomeSubTitle,
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    twelcomeSubTitle,
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainPage()));
                      },
                      child: Text(tLogin.toUpperCase()),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                      },
                      child: Text(tSignUp.toUpperCase()),
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}
