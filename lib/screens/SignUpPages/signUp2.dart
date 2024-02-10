import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Login/login.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp2 extends StatefulWidget {
  const SignUp2({super.key});

  @override
  State<SignUp2> createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> {
  //TextField Controllers
  final TextEditingController username = new TextEditingController();
  final TextEditingController email = new TextEditingController();
  final TextEditingController pwd = new TextEditingController();

  //SignIn Function
  signIn(String email, String pwd) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: pwd);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Login()));
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
              margin: const EdgeInsets.only(bottom: 10),
              alignment: Alignment.centerLeft,
              child: const Text(
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
            TextFormField(
              cursorColor: Constants.greyTextColor,
              controller: username,
              keyboardType: TextInputType.name,
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
              margin: const EdgeInsets.only(bottom: 10, top: 20),
              alignment: Alignment.centerLeft,
              child: const Text(
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
            TextFormField(
              cursorColor: Constants.greyTextColor,
              keyboardType: TextInputType.emailAddress,
              controller: email,
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

            //pwd TextField
            TextField(
              cursorColor: Colors.grey,
              keyboardType: TextInputType.text,
              controller: pwd,
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
              child: const Row(
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
            const SizedBox(
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
                signIn(email.text, pwd.text);
              },
              topBottomMargin: 0,
              leftRightMargin: 0,
            ),
            //bottom div
            const Spacer(),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()));
                    },
                    child: const Text(
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
