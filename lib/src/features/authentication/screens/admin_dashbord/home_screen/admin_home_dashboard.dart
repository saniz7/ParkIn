import 'package:flutter/material.dart';
import 'package:learn01/src/constants/sizes.dart';
import 'package:learn01/src/features/authentication/screens/admin_dashbord/home_screen/widget/admin_home_widget.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              title: Text(
            'Admin DashBoard',
            style: Theme.of(context).textTheme.titleLarge,
          )),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    "Rikesh Admin",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "rikesh@admin.com",
                    style: TextStyle(fontSize: 18),
                  ),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    primary: false,
                    padding:
                        const EdgeInsets.only(top: tDefaultSize, bottom: 0),
                    children: const [
                      SingleDashItem(
                        subtitle: "Users",
                        title: "400",
                      ),
                      SingleDashItem(
                        subtitle: "Parking Places",
                        title: "35",
                      ),
                      SingleDashItem(
                        subtitle: "Users",
                        title: "Manage",
                      ),
                      SingleDashItem(
                        subtitle: "Places",
                        title: "Manage",
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
