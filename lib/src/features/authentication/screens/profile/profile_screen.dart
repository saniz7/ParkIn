import 'package:flutter/material.dart';
import 'package:learn01/src/constants/colors.dart';
import 'package:learn01/src/constants/image_strings.dart';
import 'package:learn01/src/constants/sizes.dart';
import 'package:learn01/src/constants/text_strings.dart';
import 'package:learn01/src/features/authentication/screens/profile/widgets/profile_menu.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'update_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {}, icon: const Icon(LineAwesomeIcons.angle_left)),
          title: Text("Park-In",
              style: Theme.of(context).textTheme.headlineMedium),
          actions: [
            IconButton(
                onPressed: () {},
                icon:
                    Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
          ],
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
                        child: const Image(image: AssetImage(tProfileImage)),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: tPrimaryColor),
                        child: const Icon(
                          LineAwesomeIcons.alternate_pencil,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text(tProfileHeading,
                    style: Theme.of(context).textTheme.bodyLarge),
                Text(tProfileSubheading,
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const UpdateProfileScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: tPrimaryColor,
                        side: BorderSide.none,
                        shape: const StadiumBorder()),
                    child: const Text(tEditProfile,
                        style: TextStyle(color: tDarkColor)),
                  ),
                ),
                const SizedBox(height: 30),
                const Divider(), //covers the complete width, so widgets get center aligned,defalt main-axis center
                const SizedBox(height: 30),

                //Menu
                ProfileMenuWidget(
                    title: tMenu1,
                    icon: LineAwesomeIcons.user_plus,
                    onPress: () {}),
                ProfileMenuWidget(
                    title: tMenu2,
                    icon: LineAwesomeIcons.alternate_map_marked,
                    onPress: () {}),
                ProfileMenuWidget(
                    title: tMenu3, icon: LineAwesomeIcons.edit, onPress: () {}),
                const Divider(
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),
                ProfileMenuWidget(
                    title: tMenu4, icon: LineAwesomeIcons.info, onPress: () {}),
                ProfileMenuWidget(
                  title: tMenu5,
                  icon: LineAwesomeIcons.alternate_sign_out,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
