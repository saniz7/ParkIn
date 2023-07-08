// import 'package:flutter/material.dart';
// import 'package:learn01/src/constants/sizes.dart';
// import 'package:learn01/src/features/authentication/screens/admin_dashbord/home_screen/widget/admin_home_widget.dart';

// class AdminDashboard extends StatelessWidget {
//   const AdminDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

//     return SafeArea(
//       child: Scaffold(
//           appBar: AppBar(
//               title: Text(
//             'Admin DashBoard',
//             style: Theme.of(context).textTheme.titleLarge,
//           )),
//           body: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CircleAvatar(
//                     radius: 40,
//                   ),
//                   SizedBox(
//                     height: 12.0,
//                   ),
//                   Text(
//                     "Rikesh Admin",
//                     style: TextStyle(fontSize: 18),
//                   ),
//                   Text(
//                     "rikesh@admin.com",
//                     style: TextStyle(fontSize: 18),
//                   ),
//                   GridView.count(
//                     crossAxisCount: 2,
//                     shrinkWrap: true,
//                     primary: false,
//                     padding:
//                         const EdgeInsets.only(top: tDefaultSize, bottom: 0),
//                     children: [
//                       SingleDashItem(
//                         onPressed: () {},
//                         subtitle: "Users",
//                         title: "400",
//                       ),
//                       SingleDashItem(
//                         onPressed: () {},
//                         subtitle: "Parking Places",
//                         title: "35",
//                       ),
//                       SingleDashItem(
//                         onPressed: () {},
//                         subtitle: "Users",
//                         title: "Manage",
//                       ),
//                       SingleDashItem(
//                         onPressed: () {},
//                         subtitle: "Places",
//                         title: "Manage",
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           )),
//     );
//   }
// }

import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  // Function to handle logout
  void logout(BuildContext context) {
    // Add your logout logic here
    // For example, clear user session, navigate to login screen, etc.
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Admin Dashboard',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                const Text(
                  "Rikesh Admin",
                  style: TextStyle(fontSize: 18),
                ),
                const Text(
                  "rikesh@admin.com",
                  style: TextStyle(fontSize: 18),
                ),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.only(top: 12, bottom: 0),
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Users'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Parking Places'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Users (Manage)'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Places (Manage)'),
                    ),
                  ],
                ),
                const SizedBox(
                    height:
                        20.0), // Adding some space between grid and logout button
                ElevatedButton(
                  onPressed: () => logout(context),
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: AdminDashboard(),
  ));
}
