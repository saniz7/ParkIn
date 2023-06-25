import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn01/src/constants/colors.dart';
import 'package:learn01/src/constants/image_strings.dart';
import 'package:learn01/src/constants/sizes.dart';
import 'package:learn01/src/constants/text_strings.dart';
import 'package:learn01/src/features/authentication/screens/profile/change_password.dart';
import 'package:learn01/src/features/authentication/screens/profile/profile_screen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

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
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            icon: const Icon(LineAwesomeIcons.angle_double_left),
          ),
          title: Text(
            tEditProfile,
            style: Theme.of(context).textTheme.headline4,
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
                          image: AssetImage(tProfileImage),
                        ),
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
                          color: tPrimaryColor,
                        ),
                        child: const Icon(
                          LineAwesomeIcons.camera,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Data is still loading
                      return CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      // User data is available
                      Map<String, dynamic>? userData = snapshot.data?.data();
                      if (userData != null) {
                        return Form(
                          child: Column(
                            children: [
                              TextFormField(
                                initialValue: userData['username'],
                                decoration: InputDecoration(
                                  labelText: tFullName,
                                  prefixIcon: Icon(LineAwesomeIcons.user),
                                ),
                              ),
                              const SizedBox(height: tFormHeight - 20),
                              TextFormField(
                                initialValue: userData['email'],
                                decoration: InputDecoration(
                                  labelText: tEmail,
                                  prefixIcon: Icon(LineAwesomeIcons.envelope_1),
                                ),
                              ),
                              const SizedBox(height: tFormHeight - 20),
                              TextFormField(
                                initialValue: userData['phoneno'].toString(),
                                decoration: InputDecoration(
                                  labelText: tPhoneNo,
                                  prefixIcon: Icon(LineAwesomeIcons.phone),
                                ),
                              ),
                              const SizedBox(height: tFormHeight - 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ProfileScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: tPrimaryColor,
                                    side: BorderSide.none,
                                    shape: const StadiumBorder(),
                                  ),
                                  child: const Text(
                                    tUpdateProfile,
                                    style: TextStyle(color: tDarkColor),
                                  ),
                                ),
                              ),
                              const SizedBox(height: tFormHeight),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ChangePassword(),
                                      ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.green.shade500,
                                    side: BorderSide.none,
                                    shape: const StadiumBorder(),
                                  ),
                                  child: const Text(
                                    tChangePassword,
                                    style: TextStyle(color: tDarkColor),
                                  ),
                                ),
                              ),
                              const SizedBox(height: tFormHeight),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      text: tJoined,
                                      style: const TextStyle(fontSize: 12),
                                      children: [
                                        TextSpan(
                                          text: tJoinedAt,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.redAccent.withOpacity(0.1),
                                      elevation: 0,
                                      foregroundColor: Colors.red,
                                      shape: const StadiumBorder(),
                                      side: BorderSide.none,
                                    ),
                                    child: const Text(tDelete),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    }
                    // User data not found
                    return Text('User data not found');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
