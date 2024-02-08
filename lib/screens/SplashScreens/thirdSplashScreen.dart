import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:citi_guide/screens/SplashScreens/fourthSplashScreen.dart';
import 'package:flutter/material.dart';

class ThirdSplashScreen extends StatelessWidget {
  const ThirdSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/images/thirdSplashScreenVector.png',
      nextScreen: FourthSplashScreen(),
      splashTransition: SplashTransition.scaleTransition,
      duration: 100,
         );
  }
}