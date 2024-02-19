import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Login/login.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:flutter/material.dart';

class ForgotPwdScreen extends StatefulWidget {
  const ForgotPwdScreen({super.key});

  @override
  State<ForgotPwdScreen> createState() => _ForgotPwdScreenState();
}

class _ForgotPwdScreenState extends State<ForgotPwdScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 20, top: 30),
            child: Image.asset(
              Constants.appLogo,
              height: 40,
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Forgot password?",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'myfonts',
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const Text(
              "Don’t worry! It happens. Please enter the email associated with your account.",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'myfonts',
                fontSize: 13,
                fontWeight: FontWeight.w200,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            //Email TextField
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Email address",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'myfonts',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextField(
              cursorColor: Constants.greyTextColor,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 3, color: Colors.transparent), //<-- SEE HERE
                ),
                filled: true,
                fillColor: Constants.greyColor,
                hintText: '   Enter your email address',
                border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(Constants.buttonBorderRadius),
                    borderSide: BorderSide(color: Constants.greyColor)),
                contentPadding: EdgeInsets.symmetric(
                    vertical: Constants.searchBarButtonHeight, horizontal: 15),
              ),
              style: TextStyle(
                color: Constants.greyTextColor,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            //login in  button
            BlueButton(
              topBottomPadding: Constants.searchBarButtonHeight,
              leftRightPadding: 10,
              widget_: Text(
                "Send code",
                style: TextStyle(
                  color: Constants.greyColor,
                  fontFamily: 'myfonts',
                  fontSize: 12,
                  fontWeight: FontWeight.w200,
                ),
              ),
              OntapFunction: () {
                print("tapped");
              },
              topBottomMargin: 0,
              leftRightMargin: 0,
            ),
            const SizedBox(
              height: 20,
            ),

            //bottom div
            const Spacer(),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Remember password?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Login()));
                    },
                    child: const Text(
                      " Log in",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
