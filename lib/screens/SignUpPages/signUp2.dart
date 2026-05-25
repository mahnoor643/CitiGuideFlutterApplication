import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Login/login.dart';
import 'package:citi_guide/screens/Cities/SelectCity.dart';
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
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController pwd = TextEditingController();

  bool _isLoading = false;
  bool _isObscured = true;

  Future<void> signIn(String email, String pwd, String username) async {
    setState(() => _isLoading = true);

    try {
      final UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email.trim(),
        password: pwd.trim(),
      );

      final String uid = credential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': email.trim(),
        'id': uid,
        'username': username.trim(),
        'role': 'user',
        'profile': 'assets/images/profileDefaultImg.jpg',
      });

      successMessage('Account Created Successfully');

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SelectCity(
            userId: uid,
            username: username.trim(),
            email: email.trim(),
            profile: 'assets/images/profileDefaultImg.jpg',
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
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
      print('Signup error: $e');
      successMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Scaffold(
      backgroundColor: const Color(0xfffbf8f3),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Spacer ──
            SizedBox(height: size.height * 0.02),

            // ── Main Content (Scrollable + Centered) ──
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.08,
                      vertical: isSmallScreen ? 12 : 16,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Logo (Right Aligned) ──
                          Align(
                            alignment: Alignment.centerRight,
                            child: Image.asset(
                              Constants.appLogo,
                              height: isSmallScreen ? 36 : 40,
                            ),
                          ),

                          SizedBox(height: isSmallScreen ? 24 : 32),

                          // ── Title ──
                          Text(
                            "Create account",
                            style: TextStyle(
                              color: const Color(0xff1a1a1a),
                              fontSize: isSmallScreen ? 26 : 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),

                          SizedBox(height: isSmallScreen ? 20 : 28),

                          // ── Username Label ──
                          const Text(
                            "Username",
                            style: TextStyle(
                              color: Color(0xff888888),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // ── Username Field ──
                          TextFormField(
                            cursorColor: Constants.OrangeColor,
                            controller: username,
                            validator: (val) => val!.length < 3
                                ? 'Username should be atleast 3 characters'
                                : null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xffe5e5e5),
                                  width: 1.2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Constants.OrangeColor,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Your username',
                              hintStyle: const TextStyle(
                                color: Color(0xffaaaaaa),
                                fontSize: 13,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 14,
                              ),
                            ),
                            style: const TextStyle(
                              color: Color(0xff1a1a1a),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(height: isSmallScreen ? 16 : 20),

                          // ── Email Label ──
                          const Text(
                            "Email",
                            style: TextStyle(
                              color: Color(0xff888888),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // ── Email Field ──
                          TextFormField(
                            cursorColor: Constants.OrangeColor,
                            controller: email,
                            validator: validateEmail,
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xffe5e5e5),
                                  width: 1.2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Constants.OrangeColor,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'your@email.com',
                              hintStyle: const TextStyle(
                                color: Color(0xffaaaaaa),
                                fontSize: 13,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 14,
                              ),
                            ),
                            style: const TextStyle(
                              color: Color(0xff1a1a1a),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(height: isSmallScreen ? 16 : 20),

                          // ── Password Label ──
                          const Text(
                            "Password",
                            style: TextStyle(
                              color: Color(0xff888888),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // ── Password Field ──
                          TextFormField(
                            cursorColor: Constants.OrangeColor,
                            controller: pwd,
                            keyboardType: TextInputType.text,
                            validator: validatePwd,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            obscureText: _isObscured,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xffe5e5e5),
                                  width: 1.2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Constants.OrangeColor,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Enter your password',
                              hintStyle: const TextStyle(
                                color: Color(0xffaaaaaa),
                                fontSize: 13,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscured
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  color: const Color(0xff999999),
                                  size: 18,
                                ),
                                onPressed: () =>
                                    setState(() => _isObscured = !_isObscured),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 14,
                              ),
                            ),
                            style: const TextStyle(
                              color: Color(0xff1a1a1a),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(height: isSmallScreen ? 18 : 24),

                          // ── Terms Agreement ──
                          Row(
                            children: [
                              Icon(
                                Icons.verified_rounded,
                                size: isSmallScreen ? 16 : 18,
                                color: Constants.OrangeColor,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "I accept the term and privacy policy",
                                  style: TextStyle(
                                    color: const Color(0xff888888),
                                    fontSize: isSmallScreen ? 11 : 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: isSmallScreen ? 18 : 24),

                          // ── Sign Up Button ──
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: Constants.orangeGradient,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Constants.OrangeColor.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: _isLoading
                                    ? null
                                    : () async {
                                        if (_formKey.currentState!
                                            .validate()) {
                                          await signIn(
                                            email.text,
                                            pwd.text,
                                            username.text,
                                          );
                                        }
                                      },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: isSmallScreen ? 11 : 12,
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      if (_isLoading)
                                        const SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      else
                                        Text(
                                          "Sign Up",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                isSmallScreen ? 13 : 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: isSmallScreen ? 18 : 24),

                          // ── Login Link ──
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    color: Color(0xff888888),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Login(),
                                    ),
                                  ),
                                  child: const Text(
                                    "Log in",
                                    style: TextStyle(
                                      color: Color(0xff1a1a1a),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: isSmallScreen ? 12 : 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}