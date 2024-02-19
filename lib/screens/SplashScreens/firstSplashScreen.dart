import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:citi_guide/screens/SplashScreens/secondSplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';


class firstSplashScreen extends StatelessWidget {
  const firstSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: ('assets/images/secondSplashScreenVector.png'),
      nextScreen: SecondSplashScreen(),
      splashTransition: SplashTransition.scaleTransition,
      duration: 100,
         );
  }
}