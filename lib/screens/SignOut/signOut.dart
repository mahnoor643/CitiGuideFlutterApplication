import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:citi_guide/screens/SignUpPages/signUp2.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignOutScreen extends StatefulWidget {
  const SignOutScreen({super.key});

  @override
  State<SignOutScreen> createState() => _SignOutScreenState();
}

class _SignOutScreenState extends State<SignOutScreen> {
  //SignOut
  SignOut(){
    FirebaseAuth.instance.signOut().then((value) => {
      print("Signed out"),
      Navigator.push(context,MaterialPageRoute(builder: (context)=> SignUp2())),
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.splashScreenPageColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 250,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: Image.asset(Constants.appLogo)),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              child: const Text(
                "Thanks For Using Citi Guide!",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'myfonts',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(
              height: 30,
            ),
            //login in  button
            BlueButton(
              topBottomPadding: Constants.searchBarButtonHeight,
              leftRightPadding: 10,
              widget_: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Back to home",
                    style: TextStyle(
                      color: Constants.greyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: Constants.greyColor,
                    size: 16,
                  ),
                ],
              ),
              OntapFunction: () {
                SignOut();
              },
              topBottomMargin: 0,
              leftRightMargin: 50,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
