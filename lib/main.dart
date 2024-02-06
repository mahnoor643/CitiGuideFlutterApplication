import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:citi_guide/screens/Details/details.dart';
import 'package:citi_guide/screens/Login/login.dart';
import 'package:citi_guide/screens/ResetPwd/pwdChangedScreen.dart';
import 'package:citi_guide/screens/ResetPwd/resetPwd.dart';
import 'package:citi_guide/screens/SignUpPages/signUp1.dart';
import 'package:citi_guide/screens/SignUpPages/signUp2.dart';
import 'package:citi_guide/screens/forgotPassword/forgotPwd.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CitiGuide());
}

class CitiGuide extends StatelessWidget {
  const CitiGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PwdChangedScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //Beneath colorScheme is used for background color setting of app
        colorScheme: ColorScheme.light(
          background:Colors.white,
        ),
        fontFamily: 'myfonts',
      ),
      routes: {
        '/home': (context) => Dashboard(),
        '/login': (context) => Login(),
        '/signup':(context) => SignUp2(),
      },
    );
  }
}
