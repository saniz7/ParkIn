import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn01/src/constants/colors.dart';
import 'package:learn01/src/constants/image_strings.dart';
import 'package:learn01/src/constants/sizes.dart';
import 'package:learn01/src/constants/text_strings.dart';
import 'package:learn01/src/features/authentication/screens/additional_details/additional_details.dart';
import 'package:learn01/src/features/authentication/screens/booking/Mybookings.dart';
import 'package:learn01/src/features/authentication/screens/profile/widgets/profile_menu.dart';
import 'package:learn01/src/features/authentication/screens/rent_out_your_space/rent_out-your_space.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../login/login_screen.dart';
import '../manage_parking_space/widgets/ViewAll_Space_Widget .dart';
import '../parkingspace/ViewParking_Space_Widget .dart';
import 'update_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Drawer(
      child: SafeArea(
        child: Drawer(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(LineAwesomeIcons.angle_left)),
              title: Text("Park-In",
                  style: Theme.of(context).textTheme.headlineMedium),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                        isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
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
                            child:
                                const Image(image: AssetImage(tProfileImage)),
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
                    FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Data is still loading
                          return CircularProgressIndicator();
                        } else if (snapshot.hasData &&
                            snapshot.data?.exists == true) {
                          // User data is available
                          Map<String, dynamic>? userData =
                              snapshot.data?.data();
                          if (userData != null) {
                            // Display the user data
                            return Column(
                              children: [
                                Text(userData['username'],
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                                Text(userData['email'],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ],
                            );
                          }
                        }
                        // User data not found
                        return Text('User data not found');
                      },
                    ),
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
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AdditionalDetails()));
                        }),
                    ProfileMenuWidget(
                        title: 'My Bookings',
                        icon: LineAwesomeIcons.user_plus,
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MyBookingPageSpaceScreen()));
                        }),
                    ProfileMenuWidget(
                        title: 'View All space',
                        icon: LineAwesomeIcons.user_plus,
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ViewAllParkingSpaceScreen()));
                        }),
                    ProfileMenuWidget(
                      title: tMenu2,
                      icon: LineAwesomeIcons.alternate_map_marked,
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RentSpace()));
                      },
                    ),
                    ProfileMenuWidget(
                        title: tMenu3,
                        icon: LineAwesomeIcons.edit,
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ViewSpaceScreen()));
                        }),
                    const Divider(
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    ProfileMenuWidget(
                        title: tMenu4,
                        icon: LineAwesomeIcons.info,
                        onPress: () {}),
                    ProfileMenuWidget(
                      title: tMenu5,
                      icon: LineAwesomeIcons.alternate_sign_out,
                      textColor: Colors.red,
                      endIcon: false,
                      onPress: () {
                        try {
                          FirebaseAuth.instance.signOut();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        } catch (e) {
                          print('Error during sign-out: $e');
                        }
                      },
                    ),
                    const Divider(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
