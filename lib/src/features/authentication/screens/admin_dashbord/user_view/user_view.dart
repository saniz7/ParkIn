import 'package:flutter/material.dart';

class UserView extends StatelessWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User View"),
      ),
      body: ListView.builder(
        itemCount: 0, // Replace 0 with the actual number of items
        itemBuilder: (context, index) {
          // Return your item widget here based on the index
          return ListTile(
            title: Text('Item $index'),
          );
        },
      ),
    );
  }
}
