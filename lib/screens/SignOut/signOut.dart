import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:flutter/material.dart';

class SignOutScreen extends StatefulWidget {
  const SignOutScreen({super.key});

  @override
  State<SignOutScreen> createState() => _SignOutScreenState();
}

class _SignOutScreenState extends State<SignOutScreen> {
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
                  child: Image.asset('assets/images/googleIcon.png')),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                child: const Text(
                  "Thanks For Using City Guide!",
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
                        fontFamily: 'myfonts',
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
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
                  print("tapped");
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