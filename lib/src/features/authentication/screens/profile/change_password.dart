import 'package:flutter/material.dart';
import 'package:learn01/src/constants/colors.dart';
import 'package:learn01/src/constants/image_strings.dart';
import 'package:learn01/src/constants/sizes.dart';
import 'package:learn01/src/constants/text_strings.dart';
import 'package:learn01/src/features/authentication/screens/profile/profile_screen.dart';
import 'package:learn01/src/features/authentication/screens/profile/update_profile_screen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UpdateProfileScreen()));
              },
              icon: const Icon(LineAwesomeIcons.angle_double_left),
            ),
            title: Text(
              tUpdatePassword,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          body: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.all(tDefaultSize),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: const Image(
                                    image: AssetImage(tForgetPasswordImage))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Form(
                        child: Column(
                          children: [
                            TextFormField(
                                decoration: const InputDecoration(
                                    label: Text(tOldPassword),
                                    prefixIcon: Icon(LineAwesomeIcons.lock))),
                            const SizedBox(height: tFormHeight - 20),
                            TextFormField(
                                decoration: const InputDecoration(
                                    label: Text(tNewPassword),
                                    prefixIcon:
                                        Icon(LineAwesomeIcons.fingerprint))),
                            const SizedBox(height: tFormHeight - 20),
                            TextFormField(
                                decoration: const InputDecoration(
                                    label: Text(tConfirmNewPassword),
                                    prefixIcon:
                                        Icon(LineAwesomeIcons.fingerprint))),
                            const SizedBox(height: tFormHeight),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ProfileScreen()));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: tPrimaryColor,
                                    side: BorderSide.none,
                                    shape: const StadiumBorder()),
                                child: const Text(
                                  tUpdatePassword,
                                  style: TextStyle(color: tDarkColor),
                                ),
                              ),
                            ),
                            const SizedBox(height: tFormHeight),
                          ],
                        ),
                      )
                    ],
                  )))),
    );
  }
}
