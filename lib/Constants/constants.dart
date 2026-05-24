import 'package:flutter/material.dart';

class Constants {
  // ─── Existing Colors ─────────────────────────────────────────────────────
  static Color greyColor = const Color(0xffE7E7E7);
  static Color redColor = const Color(0xffb40e00);
  static Color OrangeColor = const Color(0xffE54000);
  static Color whiteColor = Colors.white;
  static Color lightBlueColor = const Color(0xffF0F3FB);
  static Color greyTextColor = const Color(0xffB6B6B6);

  // ─── Background Colors (Based on your theme) ─────────────────────────────
  /// Main page background - warm cream/beige that complements orange gradient
  static Color pageBackgroundColor = const Color(0xfffbf8f3);
  
  /// Alternative background - slightly warmer for onboarding screens
  static Color onboardingBackgroundColor = const Color(0xfffff9f5);
  
  /// Splash screen background - as per original design
  static Color splashScreenPageColor = const Color(0xffD6D4A7);

  // ─── Text Colors ────────────────────────────────────────────────────────
  static Color textPrimaryColor = const Color(0xff1a1a1a);
  static Color textSecondaryColor = const Color(0xff888888);
  static Color textTertiaryColor = const Color(0xff999999);

  // ─── Border & Shadow Colors ─────────────────────────────────────────────
  static Color borderColor = const Color(0xffe5e5e5);
  static Color lightBorderColor = const Color(0xffe8e8e8);

  // ─── Images ─────────────────────────────────────────────────────────────
  static String dashboardProfileImg = 'assets/images/profile.png';
  static String mainLogo = 'assets/images/MainLogo.png';
  static String appLogo = 'assets/images/citiGuideIcon.png';
  static String profileName = 'Hello Alex';

  // ─── Dimensions ─────────────────────────────────────────────────────────
  static double buttonBorderRadius = 10;
  static double searchBarButtonHeight = 15;

  // ─── Gradients ──────────────────────────────────────────────────────────
  static LinearGradient orangeGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0xffD76E00),
      Color(0xffE54000),
      Color(0xffA60000),
    ],
  );

  static LinearGradient redGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0xffFF512F), // orange-red
      Color(0xffDD1818), // mid red
      Color(0xffA60000), // deep dark red
    ],
    stops: [0.0, 0.4, 1.0],
  );
}