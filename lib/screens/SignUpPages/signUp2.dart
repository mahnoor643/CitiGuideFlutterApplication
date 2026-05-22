import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Login/login.dart';
import 'package:citi_guide/screens/Cities/SelectCity.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp2 extends StatefulWidget {
  const SignUp2({super.key});

  @override
  State<SignUp2> createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> {
  final _formKey = GlobalKey<FormState>();

  String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if (!isEmailValid) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePwd(String? pwd) {
    RegExp passwordRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).{8,}$');
    final isPwdValid = passwordRegex.hasMatch(pwd ?? '');
    if (!isPwdValid) {
      return 'Password must be of 8 characters\n including digits and alphabets';
    }
    return null;
  }

  void successMessage(String successMsg) {
    final snackBar = SnackBar(
      content: Text(successMsg),
      backgroundColor: Constants.OrangeColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  final TextEditingController username = TextEditingController();
  final TextEditingController email    = TextEditingController();
  final TextEditingController pwd      = TextEditingController();

  bool _isLoading = false;

  // ✅ Fixed SignUp — FirebaseAuthException alag catch kiya
  Future<void> signIn(String email, String pwd, String username) async {
    setState(() => _isLoading = true);

    try {
      // ✅ Step 1 — Firebase Auth user banao
      final UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email.trim(),
        password: pwd.trim(),
      );

      final String uid = credential.user!.uid;

      // ✅ Step 2 — Firestore mein data save karo
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email':    email.trim(),
        'id':       uid,
        'username': username.trim(),
        'role':     'user',
        'profile':  'assets/images/profileDefaultImg.jpg',
      });

      successMessage('Account Created Successfully');

      if (!mounted) return;

      // ✅ Step 3 — SelectCity pe navigate karo
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SelectCity(
            userId:   uid,
            username: username.trim(),
            email:    email.trim(),
            profile:  'assets/images/profileDefaultImg.jpg',
          ),
        ),
      );

    } on FirebaseAuthException catch (e) {
      // ✅ Firebase Auth errors — web pe bhi kaam karta hai
      String errorMsg;
      switch (e.code) {
        case 'email-already-in-use':
          errorMsg = 'This email is already registered.';
          break;
        case 'invalid-email':
          errorMsg = 'Email address is not valid.';
          break;
        case 'weak-password':
          errorMsg = 'Password is too weak.';
          break;
        case 'operation-not-allowed':
          errorMsg = 'Email/password sign-up is not enabled.';
          break;
        default:
          errorMsg = 'Sign up failed. Please try again.';
          print('FirebaseAuthException: ${e.code} — ${e.message}');
      }
      successMessage(errorMsg);

    } catch (e) {
      // ✅ General errors
      print('Signup error: $e');
      successMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  Image.asset(Constants.appLogo, height: 40),
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

              // Username TextField
              TextFormField(
                cursorColor: Constants.greyTextColor,
                controller: username,
                validator: (val) => val!.length < 3
                    ? 'Username should be atleast 3 characters'
                    : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.transparent),
                  ),
                  filled: true,
                  fillColor: Constants.greyColor,
                  hintText: '   Your username',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(Constants.buttonBorderRadius),
                    borderSide: BorderSide(color: Constants.greyColor),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: Constants.searchBarButtonHeight,
                    horizontal: 15,
                  ),
                ),
                style: TextStyle(color: Constants.greyTextColor),
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

              // Email TextField
              TextFormField(
                cursorColor: Constants.greyTextColor,
                controller: email,
                validator: validateEmail,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.transparent),
                  ),
                  filled: true,
                  fillColor: Constants.greyColor,
                  hintText: '   Your email',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(Constants.buttonBorderRadius),
                    borderSide: BorderSide(color: Constants.greyColor),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: Constants.searchBarButtonHeight,
                    horizontal: 15,
                  ),
                ),
                style: TextStyle(color: Constants.greyTextColor),
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

              // Password TextField
              TextFormField(
                cursorColor: Colors.grey,
                controller: pwd,
                keyboardType: TextInputType.text,
                validator: validatePwd,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.transparent),
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
                    onPressed: () =>
                        setState(() => _isObscured = !_isObscured),
                  ),
                ),
                style: const TextStyle(color: Colors.grey),
                obscureText: _isObscured,
              ),

              Container(
                margin: const EdgeInsets.only(top: 30),
                child: const Row(
                  children: [
                    Icon(Icons.verified_rounded, size: 20),
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
              const SizedBox(height: 30),

              // ✅ Sign Up Button — loader bhi hai
              BlueButton(
                topBottomPadding: Constants.searchBarButtonHeight,
                leftRightPadding: 10,
                widget_: _isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
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

              const Spacer(),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
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
                            builder: (context) => const Login(),
                          ),
                        );
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
                    ),
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