import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleDashItem extends StatelessWidget {
  final String title, subtitle;
  final void Function()? onPressed;
  const SingleDashItem(
      {super.key,
      required this.subtitle,
      required this.title,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Card(
        child: Container(
            width: double.infinity,
            color: Theme.of(context).primaryColor.withOpacity(0.7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 35),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            )),
      ),
    );
  }
}
