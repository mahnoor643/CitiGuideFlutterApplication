import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CitiGuide());
}

class CitiGuide extends StatelessWidget {
  const CitiGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Dashboard(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //Beneath colorScheme is used for background color setting of app
        colorScheme: ColorScheme.light(
          background:Colors.orange,
        ),
      ),
    );
  }
}
