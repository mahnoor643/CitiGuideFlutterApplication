import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:citi_guide/screens/SplashScreens/thirdSplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';


class SecondSplashScreen extends StatelessWidget {
  const SecondSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: ('assets/images/secondSplashScreenVector.png'),
      nextScreen: ThirdSplashScreen(),
      splashTransition: SplashTransition.scaleTransition,
      duration: 100,
         );
  }
}