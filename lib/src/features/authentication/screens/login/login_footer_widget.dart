import 'package:flutter/material.dart';
import 'package:learn01/src/features/authentication/screens/signup/signup_screen.dart';

import '../../../../constants/image_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("OR"),
        const SizedBox(
          height: tFormHeight - 20,
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: Image(
              image: AssetImage(tGoogleLogoImage),
              width: 25.0,
            ),
            onPressed: () {},
            label: Text(tSignInWithGoogle),
          ),
        ),
        const SizedBox(
          height: tFormHeight - 20,
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text.rich(TextSpan(
              text: tDontHaveAnAccount,
              //style: Theme.of(context).textTheme.bodyText1,
              children: const [
                TextSpan(
                  text: tSignUp,
                  style: TextStyle(color: Colors.blue),
                )
              ])),
        ),
      ],
    );
  }
}
