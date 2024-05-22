import 'dart:convert';
import 'dart:typed_data';

import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Admin/admin.dart';
import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:citi_guide/screens/Login/login.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUp2 extends StatefulWidget {
  const SignUp2({super.key});

  @override
  State<SignUp2> createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> {
  //Validation
  final _formKey = GlobalKey<FormState>();
  //Email validation
  String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if (!isEmailValid) {
      return 'Please enter a valid email';
    }
    return null;
  }

  //Password validation
  String? validatePwd(String? pwd) {
    RegExp passwordRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).{8,}$');
    final isPwdValid = passwordRegex.hasMatch(pwd ?? '');
    if (!isPwdValid) {
      return 'Password must be of 8 characters\n including digits and alphabets';
    }
  }

  //Login Successful msg
  void successMessage(String successMsg) {
    final snackBar = SnackBar(
      content: Text(successMsg),
      backgroundColor: Constants.OrangeColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //TextField Controllers
  final TextEditingController username = new TextEditingController();
  final TextEditingController email = new TextEditingController();
  final TextEditingController pwd = new TextEditingController();

  //SignIn Function
  Future<void> signIn(String email, String pwd, String username) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pwd);

      // Making users class to add further details
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid) // Use user's UID as the document ID
          .set({
        'email': email,
        'id': credential.user!.uid,
        'username': username,
      });
      final FirebaseStorage _storage = FirebaseStorage.instance;
      Reference ref = _storage.ref().child('profile/${credential.user!.uid}');
      ByteData data =
          await rootBundle.load('assets/images/profileDefaultImg.jpg');
      Uint8List image = data.buffer.asUint8List();
      UploadTask uploadTask = ref.putData(image);

      String successMsg = 'Account Created Successfully';
      successMessage(successMsg);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Login()));
      // username.clear();
      // this above will work but bete apne stateless widget
      // use ki hui hai 1 hr laga diya error dhundne mai
    } catch (error) {
      print("Error signing in: $error");
    }
  }

  bool _isObscured = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Spacer(),
                  Image.asset(
                    Constants.appLogo,
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
                validator: (email) => email!.length < 3
                    ? 'Username should be atleast 3 characters'
                    : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      vertical: Constants.searchBarButtonHeight,
                      horizontal: 15),
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
                controller: email,
                validator: validateEmail,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      vertical: Constants.searchBarButtonHeight,
                      horizontal: 15),
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
              TextFormField(
                cursorColor: Colors.grey,
                controller: pwd,
                keyboardType: TextInputType.text,
                validator: validatePwd,
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  "Sign Up",
                  style: TextStyle(
                    color: Constants.whiteColor,
                    fontFamily: 'myfonts',
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                OntapFunction: () async {
                  if (_formKey.currentState!.validate()) {
                    await signIn(email.text, pwd.text, username.text);
                  }
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
      ),
    );
  }
}
