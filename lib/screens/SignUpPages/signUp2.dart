import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:flutter/material.dart';

class SignUp2 extends StatefulWidget {
  const SignUp2({super.key});

  @override
  State<SignUp2> createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> {
  bool _isObscured = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Spacer(),
                Image.asset(
                  'assets/images/googleIcon.png',
                  height: 40,
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                "Create account",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'myfonts',
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(bottom: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                "Username",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'myfonts',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            //Username TextField
            TextField(
              cursorColor: Constants.greyTextColor,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 3, color: Colors.transparent), //<-- SEE HERE
                ),
                filled: true,
                fillColor: Constants.greyColor,
                hintText: '   Your username',
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

            Container(
              margin: EdgeInsets.only(bottom: 10, top: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                "Email",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'myfonts',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            //Email TextField
            TextField(
              cursorColor: Constants.greyTextColor,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 3, color: Colors.transparent), //<-- SEE HERE
                ),
                filled: true,
                fillColor: Constants.greyColor,
                hintText: '   Your email',
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

            Container(
              margin: EdgeInsets.only(bottom: 10, top: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                "Password",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'myfonts',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            //pwd TextField
            TextField(
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 3,
            color: Colors.transparent,
          ),
        ),
        filled: true,
        fillColor: Constants.greyColor,
        hintText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        ),
      ),
      style: TextStyle(
        color: Colors.grey,
      ),
      obscureText: _isObscured,
    ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Row(
                children: [
                  Icon(
                    Icons.verified_rounded,
                    size: 20,
                  ),
                  Text(
                    "  I accept the term and privacy policy",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'myfonts',
                      fontSize: 12,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            BlueButton(
              topBottomPadding: Constants.searchBarButtonHeight,
              leftRightPadding: 10,
              widget_: Text(
                "Log in",
                style: TextStyle(
                  color: Constants.whiteColor,
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
            //bottom div
            Spacer(),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: () {
                      print("object");
                    },
                    child: Text(
                      "Log in",
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
