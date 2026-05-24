import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Cities/SelectCity.dart';
import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:citi_guide/screens/Login/login.dart';
import 'package:citi_guide/screens/SignUpPages/signUp2.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SignUp1 extends StatefulWidget {
  const SignUp1({super.key});

  @override
  State<SignUp1> createState() => _SignUp1State();
}

class _SignUp1State extends State<SignUp1> {
  bool _isLoading = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  // ── Handle Firestore user sync for Google Sign-Up ──
  Future<void> _handleFirestoreUserSync(User user) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': user.email ?? '',
        'id': user.uid,
        'username': user.displayName ?? 'User',
        'role': 'user',
        'profile': user.photoURL ?? 'assets/images/profileDefaultImg.jpg',
        'city': '',
        'interests': [],
      });

      if (!mounted) return;
      // First-time user: Go to SelectCity
      Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (_) => SelectCity(
      userId: user.uid,
      username: user.displayName ?? '',
      email: user.email ?? '',
      profile: user.photoURL ?? '',
    ),
  ),
  (route) => false,
);
    } else {
      // Existing user: Go to SelectCity
      final userData = userDoc.data() as Map<String, dynamic>;
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => Dashboard(
            userId: user.uid,
      username: user.displayName ?? '',
      email: user.email ?? '',
      profile: user.photoURL ?? '',),
        ),
        (route) => false,
      );
    }
  }

  void showErrorMessage(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Constants.OrangeColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ── Google Sign-Up ──
  Future<void> _handleGoogleSignUp() async {
    setState(() => _isLoading = true);
    try {
      if (kIsWeb) {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithPopup(googleProvider);

        if (userCredential.user != null) {
          await _handleFirestoreUserSync(userCredential.user!);
        }
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          setState(() => _isLoading = false);
          return;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        await _handleFirestoreUserSync(userCredential.user!);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Google Sign-Up Firebase error: ${e.code} — ${e.message}');
      if (mounted) showErrorMessage('Google Sign-Up failed: ${e.message}');
    } catch (e) {
      debugPrint('Google Sign-Up error: $e');
      if (mounted) showErrorMessage('Google Sign-Up failed. Try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Constants.pageBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.04),

             


              // ── Main Card ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  decoration: BoxDecoration(
                    color: Constants.greyTextColor,
                    borderRadius: BorderRadius.circular(20),
                    
                  ),
                  child: Column(
                    children: [
                      // ── Logo Image ──
                      Container(
                        height: 180,
                        width: 180,
                        margin: const EdgeInsets.only(bottom: 24),
                        
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        Constants.mainLogo,
                        height: 190,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.map_outlined,
                          size: 190,
                          color: Constants.OrangeColor,
                        ),
                      ),
                    ),
                        ),
                      ),

                      // ── Title ──
                      const Text(
                        "Discover Amazing Places",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff1a1a1a),
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.3,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── Subtitle ──
                      Text(
                        "Explore local destinations, save your favorites, and create unforgettable memories",
                        style: TextStyle(
                          color: const Color(0xff888888),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 28),

                      // ── Google Button ──
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: Constants.orangeGradient,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Constants.OrangeColor.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: _isLoading ? null : _handleGoogleSignUp,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (!_isLoading)
                                    Image.asset(
                                      'assets/images/googleIcon.png',
                                      height: 20,
                                    ),
                                  if (!_isLoading) const SizedBox(width: 10),
                                  if (_isLoading)
                                    const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  else
                                    const Text(
                                      "Continue with Google",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── Apple Button ──
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xffe5e5e5),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              debugPrint("Apple Sign-Up");
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.apple_rounded,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "Continue with Apple",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff1a1a1a),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── Email Button ──
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xffe5e5e5),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUp2(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.mail_rounded,
                                    color: Color(0xff1a1a1a),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "Continue with Email",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff1a1a1a),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.08),

              // ── Login Link ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Color(0xff888888),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
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
                      "Log in",
                      style: TextStyle(
                        color: Color(0xff1a1a1a),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: size.height * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}