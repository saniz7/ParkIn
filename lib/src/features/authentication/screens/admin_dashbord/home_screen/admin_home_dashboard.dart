import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = true; // Initial login status (change as needed)

  bool get isLoggedIn => _isLoggedIn;

  void logout(BuildContext context) {
    // Perform logout operations (clear session, navigate to login, etc.)
    _isLoggedIn = false;
    Navigator.pushReplacementNamed(
        context, '/login'); // Navigate to login screen
    notifyListeners();
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
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
                  'Rikesh Admin',
                  style: TextStyle(fontSize: 18),
                ),
                const Text(
                  'rikesh@admin.com',
                  style: TextStyle(fontSize: 18),
                ),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.only(top: 12, bottom: 0),
                  children: [
                    ElevatedButton(
                      onPressed: null, // No functionality for this button
                      child: const Text('Users'),
                    ),
                    ElevatedButton(
                      onPressed: null, // No functionality for this button
                      child: const Text('Parking Places'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Functionality for this button
                      },
                      child: const Text('Users (Manage)'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Functionality for this button
                      },
                      child: const Text('Places (Manage)'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ), // Adding some space between grid and logout button
                ElevatedButton(
                  onPressed: () {
                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
                    authProvider.logout(context);
                  },
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

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Perform login operations
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            authProvider.logout(
                context); // For demonstration purposes, immediately log out after logging in
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (_) => const AdminDashboard(),
          '/login': (_) => const LoginScreen(),
        },
      ),
    ),
  );
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class AuthProvider extends ChangeNotifier {
//   bool _isLoggedIn = true; // Initial login status (change as needed)

//   bool get isLoggedIn => _isLoggedIn;

//   void logout(BuildContext context) {
//     // Perform logout operations (clear session, navigate to login, etc.)
//     _isLoggedIn = false;
//     Navigator.pushReplacementNamed(
//         context, '/login'); // Navigate to login screen
//     notifyListeners();
//   }
// }

// class AdminDashboard extends StatelessWidget {
//   const AdminDashboard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             onPressed: () {},
//             icon: const Icon(Icons.menu),
//           ),
//           title: const Text('Admin Dashboard'),
//           actions: [
//             IconButton(
//               onPressed: () {},
//               icon: Icon(isDark ? Icons.wb_sunny : Icons.brightness_2),
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Container(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 const Text(
//                   'Welcome, Admin',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Functionality for button 1
//                   },
//                   child: const Text('Button 1'),
//                 ),
//                 const SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Functionality for button 2
//                   },
//                   child: const Text('Button 2'),
//                 ),
//                 const SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Functionality for button 3
//                   },
//                   child: const Text('Button 3'),
//                 ),
//                 const SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Functionality for button 4
//                   },
//                   child: const Text('Button 4'),
//                 ),
//                 const SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     final authProvider =
//                         Provider.of<AuthProvider>(context, listen: false);
//                     authProvider.logout(context);
//                   },
//                   child: const Text('Logout'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             final authProvider =
//                 Provider.of<AuthProvider>(context, listen: false);
//             authProvider.logout(
//                 context); // For demonstration purposes, immediately log out after logging in
//           },
//           child: const Text('Login'),
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (_) => AuthProvider(),
//       child: Consumer<AuthProvider>(
//         builder: (context, authProvider, _) => MaterialApp(
//           initialRoute: '/',
//           routes: {
//             '/': (_) => const AdminDashboard(),
//             '/login': (_) => const LoginScreen(),
//           },
//         ),
//       ),
//     ),
//   );
// }
