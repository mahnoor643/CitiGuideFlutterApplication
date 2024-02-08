import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:citi_guide/screens/SplashScreens/fiveSplashScreen.dart';
import 'package:flutter/material.dart';

class FourthSplashScreen extends StatelessWidget {
  const FourthSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/images/secondSplashScreenVector.png',
      nextScreen: FifthSplashScreen(),
      splashTransition: SplashTransition.scaleTransition,
      duration: 100,
         );
  }
}