import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Admin/admin.dart';
import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:citi_guide/screens/SignUpPages/signUp2.dart';
import 'package:citi_guide/screens/forgotPassword/forgotPwd.dart';
import 'package:citi_guide/screens/profile/profile.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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

  //Error validating
  void showErrorMessage(String errorToShow) {
    final snackBar = SnackBar(
      content: Text(errorToShow),
      backgroundColor: Constants.OrangeColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //TextField Controllers
  final TextEditingController username = new TextEditingController();
  final TextEditingController email = new TextEditingController();
  final TextEditingController pwd = new TextEditingController();

//Login

  void loginbtn(String email, String pwd) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pwd,
      );
      //Fetching details
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      QuerySnapshot querySnapshot =
          await users.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Access the data of the first document (assuming there's only one match)
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        String emailFromFirestore = userData['email'] ?? '';
        String usernameFromFirestore = userData['username'] ?? '';
        String idFromFirestore = userData['id'] ?? '';

        //Fetching Image
        final refImg =
            FirebaseStorage.instance.ref().child('profile/${userData['id']}');
        String ProfileUrlFromFirestore = await refImg.getDownloadURL();

// Check the email and password for specific conditions
        
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Dashboard(
                    userId: idFromFirestore,
                    email: emailFromFirestore,
                    username: usernameFromFirestore,
                    profile: ProfileUrlFromFirestore)),
          );

        // Print or use the retrieved data
        print('Email from Firestore: $emailFromFirestore');
        print('Username from Firestore: $usernameFromFirestore');
      } else {
        print('No matching documents');
      }
    } on FirebaseAuthException catch (e) {
      // Handle authentication errors
      String errorToShow;

      switch (e.code) {
        case 'user-not-found':
          errorToShow = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorToShow = 'Wrong password provided for that user.';
          break;
        case 'invalid-email':
          errorToShow = 'Email address is not valid.';
          break;
        default:
          errorToShow = 'User not found!!';
          print("Errorrrrrrr: ${e.message}");
        // errorToShow = 'Authentication failed. ${e.message}';
      }

      showErrorMessage(errorToShow);
    } catch (e) {
      // Handle other errors
      String errorToShow = 'User not found!!';
      print("Erorrrrr is: ${e}");
      showErrorMessage(errorToShow);
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
                validator: validateEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      vertical: Constants.searchBarButtonHeight,
                      horizontal: 15),
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
                OntapFunction: () async {
                  if (_formKey.currentState!.validate()) {
                    loginbtn(email.text, pwd.text);
                  }
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
      ),
    );
  }
}
