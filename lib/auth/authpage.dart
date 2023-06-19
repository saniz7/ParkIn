// import 'package:flutter/material.dart';

// import '../pages/call_page.dart';
// import '../pages/registerpage.dart';

// class Authpage extends StatefulWidget {
//   const Authpage({super.key});

//   @override
//   State<Authpage> createState() => _AuthpageState();
// }

// class _AuthpageState extends State<Authpage> {
//   bool showLoginPage = true;
//   void toggleScreens(){
//     setState(() {
//   showLoginPage=!showLoginPage;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
// if (showLoginPage){
//   return CallsScreen(showRegister:toggleScreens);
// }
// else{
//   return Registerpage(showLoginPage:toggleScreens);
// }}
// }