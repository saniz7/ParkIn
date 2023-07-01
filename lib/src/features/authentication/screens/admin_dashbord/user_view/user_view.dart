import 'package:flutter/material.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User View"),
      ),
      body:return ListView.builder(itemBuilder: itemBuilder),
    );
  }
}
