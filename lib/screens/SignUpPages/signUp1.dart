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
      // Existing user: Go to Dashboard
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => Dashboard(
            userId: user.uid,
            username: user.displayName ?? '',
            email: user.email ?? '',
            profile: user.photoURL ?? '',
          ),
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
    final isSmallScreen = size.height < 700;

    return Scaffold(
      backgroundColor: Constants.splashScreenPageColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Spacer ──
            SizedBox(height: size.height * 0.04),

            // ── Main Content (Centered) ──
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.08,
                      vertical: isSmallScreen ? 8 : 12,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ── Logo Image ──
                        Container(
                          height: isSmallScreen ? 130 : 160,
                          width: isSmallScreen ? 130 : 160,
                          margin: EdgeInsets.only(
                            bottom: isSmallScreen ? 24 : 32,
                          ),
                          child: Image.asset(
                            Constants.mainLogo,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.map_outlined,
                              size: isSmallScreen ? 130 : 160,
                              color: Constants.OrangeColor,
                            ),
                          ),
                        ),

                        // ── Title ──
                        Text(
                          "Discover Amazing Places",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xff1a1a1a),
                            fontSize: isSmallScreen ? 24 : 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),

                        SizedBox(height: isSmallScreen ? 12 : 16),

                        // ── Subtitle ──
                        Text(
                          "Explore local destinations, save your favorites, and create unforgettable memories",
                          style: TextStyle(
                            color: const Color(0xff888888),
                            fontSize: isSmallScreen ? 12 : 13,
                            fontWeight: FontWeight.w500,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: isSmallScreen ? 32 : 40),

                        // ── Google Button ──
                        _buildAuthButton(
                          label: "Continue with Google",
                          icon: 'assets/images/googleIcon.png',
                          onTap: _isLoading ? null : _handleGoogleSignUp,
                          isLoading: _isLoading,
                          isSmallScreen: isSmallScreen,
                        ),

                        SizedBox(height: isSmallScreen ? 10 : 12),

                        // ── Apple Button ──
                        _buildAuthButton(
                          label: "Continue with Apple",
                          icon: Icons.apple_rounded,
                          onTap: () => debugPrint("Apple Sign-Up"),
                          isSmallScreen: isSmallScreen,
                        ),

                        SizedBox(height: isSmallScreen ? 10 : 12),

                        // ── Email Button ──
                        _buildAuthButton(
                          label: "Continue with Email",
                          icon: Icons.mail_rounded,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUp2(),
                              ),
                            );
                          },
                          isSmallScreen: isSmallScreen,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Bottom Section (Login Link) ──
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: isSmallScreen ? 14 : 18,
                horizontal: size.width * 0.08,
              ),
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
                    onTap: () {
                      Navigator.pushReplacement(
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
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Reusable Auth Button Widget ──
  Widget _buildAuthButton({
    required String label,
    required dynamic icon,
    required VoidCallback? onTap,
    bool isLoading = false,
    required bool isSmallScreen,
  }) {
    final isGoogleButton = label.contains("Google");
    final isAppleButton = label.contains("Apple");

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isGoogleButton ? Constants.orangeGradient : null,
        color: isGoogleButton ? null : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: !isGoogleButton
            ? Border.all(
                color: const Color(0xffe0e0e0),
                width: 1.2,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: isGoogleButton
                ? Constants.OrangeColor.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: isGoogleButton ? 12 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: isSmallScreen ? 12 : 14,
              horizontal: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isLoading && icon is String)
                  Image.asset(
                    icon,
                    height: isSmallScreen ? 18 : 20,
                    width: isSmallScreen ? 18 : 20,
                  )
                else if (!isLoading && icon is IconData)
                  Icon(
                    icon,
                    color: isGoogleButton ? Colors.white : const Color(0xff1a1a1a),
                    size: isSmallScreen ? 18 : 20,
                  ),
                if (!isLoading) SizedBox(width: isSmallScreen ? 8 : 10),
                if (isLoading)
                  SizedBox(
                    height: isSmallScreen ? 18 : 20,
                    width: isSmallScreen ? 18 : 20,
                    child: CircularProgressIndicator(
                      color: isGoogleButton ? Colors.white : Constants.OrangeColor,
                      strokeWidth: 2,
                    ),
                  )
                else
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 13 : 14,
                      color:
                          isGoogleButton ? Colors.white : const Color(0xff1a1a1a),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}