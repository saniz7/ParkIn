import 'package:flutter/material.dart';
import 'package:learn01/src/constants/colors.dart';
import 'package:learn01/src/constants/image_strings.dart';
import 'package:learn01/src/constants/text_strings.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LiquidSwipe(
            pages: [
              Container(
                color: tOnBoardingPage1Color,
                child: Column(
                  children: [
                    Image(image: AssetImage(tOnBoardingImage1)),
                    Text(tOnBoardingTitle1),
                    Text(tOnBoardingTitle2),
                    Text(tOnBoardingSubTitle3),
                  ],
                ),
              ),
              Container(color: tOnBoardingPage2Color),
              Container(color: tOnBoardingPage3Color),
            ],
          )
        ],
      ),
    );
  }
}
