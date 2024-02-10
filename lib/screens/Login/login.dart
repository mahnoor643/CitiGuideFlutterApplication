import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:citi_guide/screens/SignUpPages/signUp2.dart';
import 'package:citi_guide/screens/forgotPassword/forgotPwd.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //TextField Controllers
  final TextEditingController username = new TextEditingController();
  final TextEditingController email = new TextEditingController();
  final TextEditingController pwd = new TextEditingController();

//Login
loginbtn(String email, String pwd)async{
  await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pwd).then((value) => {
          Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Dashboard()))
        }).onError((error, stackTrace) => {
          // print("Error: ${error.toString()}")
        });
}
  bool _isObscured = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                const Spacer(),
                Image.asset(
                  'assets/images/googleIcon.png',
                  height: 40,
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.centerLeft,
              child: const Text(
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
            //Email TextField
            TextFormField(
              cursorColor: Constants.greyTextColor,
              controller: email,
              keyboardType: TextInputType.emailAddress,
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
              margin: const EdgeInsets.only(bottom: 10, top: 20),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Password",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'myfonts',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            TextFormField(
              cursorColor: Colors.grey,
              controller: pwd,
              keyboardType: TextInputType.text,
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
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                ),
              ),
              style: const TextStyle(
                color: Colors.grey,
              ),
              obscureText: _isObscured,
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'myfonts',
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPwdScreen()));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
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
                loginbtn(email.text,pwd.text);
              },
              topBottomMargin: 0,
              leftRightMargin: 0,
            ),
            const SizedBox(
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
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  const Text(
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
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(
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
                    margin: const EdgeInsets.symmetric(
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
                        padding: const EdgeInsets.symmetric(
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
                    margin: const EdgeInsets.symmetric(
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
                    child: const Center(
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
                    margin: const EdgeInsets.symmetric(
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
                        padding: const EdgeInsets.symmetric(
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
            const Spacer(),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp2()));
                    },
                    child: const Text(
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
