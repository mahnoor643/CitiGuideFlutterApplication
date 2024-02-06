import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                "Log in",
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
                "Email address",
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

//pwd TextField
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
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                  Spacer(),
                  GestureDetector(
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'myfonts',
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    onTap: () {
                      print("page navigation add");
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),

            //login in  button
            BlueButton(
              topBottomPadding: Constants.searchBarButtonHeight,
              leftRightPadding: 10,
              widget_: Text(
                "Log in",
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
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 1,
                    width: 60, // Adjust the width according to your design
                    color: Colors.black,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                  ),
                  Text(
                    "Or Login with",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'myfonts',
                      fontSize: 12,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  Container(
                    height: 1,
                    width: 60, // Adjust the width according to your design
                    color: Colors.black,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    print("navigation btn");
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Constants.greyColor,
                      borderRadius:
                          BorderRadius.circular(Constants.buttonBorderRadius),
                      border: Border.all(
                        color: Constants.greyTextColor,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20), // Adjust the padding as needed
                        child: Image.asset(
                          'assets/images/facebook.png',
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    print("navigation btn");
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Constants.greyColor,
                      borderRadius:
                          BorderRadius.circular(Constants.buttonBorderRadius),
                      border: Border.all(
                        color: Constants.greyTextColor,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20), // Adjust the padding as needed
                        child: Icon(
                          Icons.apple,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    print("navigation btn");
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Constants.greyColor,
                      borderRadius:
                          BorderRadius.circular(Constants.buttonBorderRadius),
                      border: Border.all(
                        color: Constants.greyTextColor,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20), // Adjust the padding as needed
                        child: Image.asset(
                          'assets/images/googleIcon.png',
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //bottom div
            Spacer(),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
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
                      " Sign up",
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
