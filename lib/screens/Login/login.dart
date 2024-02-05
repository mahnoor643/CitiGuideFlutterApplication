import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int _currentIndex = 1;

  final List<Widget> _pages = [
    // Add your pages here
    Dashboard(),
    Login(),
    Login(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("pagal"),
      ),

      // Navigation Bar
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            // Use Navigator to navigate to the selected page
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/home');
                break;
              case 1:
                Navigator.pushNamed(context, '/login');
                break;
              case 2:
                Navigator.pushNamed(context, '/login');
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pageview),
              label: 'Page 2',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Page 3',
            ),
          ],
          
        ),
      ),
    );
  }
}
