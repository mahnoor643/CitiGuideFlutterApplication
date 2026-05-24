// import 'package:citi_guide/screens/Admin/admin.dart';
// import 'package:citi_guide/screens/Admin/fetchData.dart';
// import 'package:citi_guide/screens/Cities/cities.dart';
// import 'package:citi_guide/screens/CityDestinations/cityDestinations.dart';
// import 'package:citi_guide/screens/Dashboard/dashboard.dart';
// import 'package:citi_guide/screens/Login/login.dart';
// import 'package:citi_guide/screens/SearchScreen/searchScreen.dart';
// import 'package:citi_guide/screens/SignUpPages/signUp1.dart';
// import 'package:citi_guide/screens/SignUpPages/signUp2.dart';
// import 'package:citi_guide/screens/SplashScreens/firstSplashScreen.dart';
// import 'package:citi_guide/screens/map/map_page.dart';
// import 'package:citi_guide/screens/profile/profile.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(CitiGuide());
// }

// class CitiGuide extends StatelessWidget {
//   const CitiGuide({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: firstSplashScreen(),
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         //Beneath colorScheme is used for background color setting of app
//         colorScheme: ColorScheme.light(
//           background: Colors.white,
//         ),
//       ),
//       routes: {
//         // '/home': (context) => Dashboard(),
//         '/login': (context) => Login(),
//         '/signup': (context) => SignUp2(),
//       },
//     );
//   }
// }

import 'package:citi_guide/firebase_options.dart';
import 'package:citi_guide/screens/Admin/admin.dart';
import 'package:citi_guide/screens/Admin/fetchData.dart';
import 'package:citi_guide/screens/Cities/SelectCity.dart';
import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:citi_guide/screens/Login/login.dart';
import 'package:citi_guide/screens/Saved/Saved.dart';
import 'package:citi_guide/screens/SignUpPages/signUp2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
  runApp(const CityGuideApp());
}

class CityGuideApp extends StatelessWidget {
  const CityGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'City Guide AI',
      theme: ThemeData(
        primaryColor: const Color(0xFFD32F2F), 
        scaffoldBackgroundColor: const Color(0xFFF5F5DC), 
        fontFamily: 'Sans-Serif',
      ),
      // App yahan se start hogi
      home: const MainAppWrapper(), 
    );
  }
}

// Ek chota sa wrapper banaya hai taake Navigator ko sahi "BuildContext" mile
class MainAppWrapper extends StatelessWidget {
  const MainAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Login();
  }
}

// temporary placeholder screen jab tak aap apni real screen nahi bana leti
class DummyCategoryScreen extends StatelessWidget {
  const DummyCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Categories Screen Coming Soon!")),
    );
  }
}