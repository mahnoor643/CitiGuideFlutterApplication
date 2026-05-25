import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Admin/admin.dart';
import 'package:citi_guide/screens/Admin/fetchData.dart';
import 'package:citi_guide/screens/Cities/SelectCity.dart';
import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:citi_guide/screens/SignUpPages/signUp1.dart';
import 'package:citi_guide/screens/SignUpPages/signUp2.dart';
import 'package:citi_guide/screens/forgotPassword/forgotPwd.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isObscured = true;

  final TextEditingController email = TextEditingController();
  final TextEditingController pwd = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  void dispose() {
    email.dispose();
    pwd.dispose();
    super.dispose();
  }

  // ── Firestore user sync with first-time check ────────────────
  Future<void> _handleFirestoreUserSync(User user) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final bool isFirstTimeLogin = !userDoc.exists;

    if (isFirstTimeLogin) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': user.email ?? '',
        'id': user.uid,
        'username': user.displayName ?? 'User',
        'role': 'user',
        'profile': user.photoURL ?? 'assets/images/profileDefaultImg.jpg',
        'city': '',
        'interests': [],
      });
    }

    await _navigateBasedOnLogin(user.uid, isFirstTimeLogin);
  }

  // ── Navigation based on login type ──
  Future<void> _navigateBasedOnLogin(String uid, bool isFirstTimeLogin) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (!mounted) return;

    if (!userDoc.exists) {
      showErrorMessage('User data not found!');
      return;
    }

    final userData = userDoc.data() as Map<String, dynamic>;

    final String emailVal = userData['email'] ?? '';
    final String usernameVal = userData['username'] ?? '';
    final String idVal = userData['id'] ?? uid;
    final String roleVal = userData['role'] ?? 'user';
    final String profileVal =
        userData['profile'] ?? 'assets/images/profileDefaultImg.jpg';
    final String cityVal = userData['city'] ?? '';
    final List<dynamic> interestsVal = userData['interests'] ?? [];

    if (roleVal == 'admin') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => AdminScreen(
            userId: idVal,
            email: emailVal,
            username: usernameVal,
            profile: profileVal,
          ),
        ),
        (route) => false,
      );
    } else {
      if (isFirstTimeLogin) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => SelectCity(
              userId: idVal,
              email: emailVal,
              username: usernameVal,
              profile: profileVal,
            ),
          ),
          (route) => false,
        );
      } else if (cityVal.isNotEmpty && interestsVal.isNotEmpty) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => Dashboard(
              userId: idVal,
              email: emailVal,
              username: usernameVal,
              profile: profileVal,
            ),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => SelectCity(
              userId: idVal,
              email: emailVal,
              username: usernameVal,
              profile: profileVal,
            ),
          ),
          (route) => false,
        );
      }
    }
  }

  // ── Navigation for email login ──
  Future<void> _navigateBasedOnRole(String uid) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (!mounted) return;

    if (!userDoc.exists) {
      showErrorMessage('User data not found!');
      return;
    }

    final userData = userDoc.data() as Map<String, dynamic>;

    final String emailVal = userData['email'] ?? '';
    final String usernameVal = userData['username'] ?? '';
    final String idVal = userData['id'] ?? uid;
    final String roleVal = userData['role'] ?? 'user';
    final String profileVal =
        userData['profile'] ?? 'assets/images/profileDefaultImg.jpg';
    final String cityVal = userData['city'] ?? '';
    final List<dynamic> interestsVal = userData['interests'] ?? [];

    if (roleVal == 'admin') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => FetchData(
            userId: idVal,
            email: emailVal,
            username: usernameVal,
            profile: profileVal,
          ),
        ),
        (route) => false,
      );
    } else {
      if (cityVal.isNotEmpty && interestsVal.isNotEmpty) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => Dashboard(
              userId: idVal,
              email: emailVal,
              username: usernameVal,
              profile: profileVal,
            ),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => SelectCity(
              userId: idVal,
              email: emailVal,
              username: usernameVal,
              profile: profileVal,
            ),
          ),
          (route) => false,
        );
      }
    }
  }

  // ── Validators ──────────────────────────────────────────────────
  String? validateEmail(String? value) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value ?? '')) return 'Please enter a valid email';
    return null;
  }

  String? validatePwd(String? value) {
    final regex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).{8,}$');
    if (!regex.hasMatch(value ?? '')) {
      return 'Password must be 8+ characters\nincluding digits and alphabets';
    }
    return null;
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

  // ── Email Login ─────────────────────────────────────────────────
  Future<void> _loginWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: pwd.text.trim(),
      );
      await _navigateBasedOnRole(cred.user!.uid);
    } on FirebaseAuthException catch (e) {
      final msg = switch (e.code) {
        'user-not-found' => 'No user found for that email.',
        'wrong-password' => 'Wrong password provided.',
        'invalid-email' => 'Email address is not valid.',
        'invalid-credential' => 'Invalid email or password.',
        _ => 'Login failed. Please try again.',
      };
      showErrorMessage(msg);
      debugPrint("FirebaseAuthException: ${e.message}");
    } catch (e) {
      showErrorMessage('Something went wrong. Try again.');
      debugPrint("Login error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Google Sign-In ──────────────────────────────────────────────
  Future<void> _handleGoogleSignIn() async {
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
      debugPrint('Google Sign-In Firebase error: ${e.code} — ${e.message}');
      if (mounted) showErrorMessage('Google Sign-In failed: ${e.message}');
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      if (mounted) showErrorMessage('Google Sign-In failed. Try again.');
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
                            "Log in",
                            style: TextStyle(
                              color: const Color(0xff1a1a1a),
                              fontSize: isSmallScreen ? 26 : 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),

                          SizedBox(height: isSmallScreen ? 20 : 28),

                          // ── Email Label ──
                          const Text(
                            "Email address",
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.emailAddress,
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
                            obscureText: _isObscured,
                            validator: validatePwd,
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
                                onPressed: () => setState(
                                    () => _isObscured = !_isObscured),
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

                          SizedBox(height: isSmallScreen ? 14 : 18),

                          // ── Forgot Password ──
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ForgotPwdScreen(),
                                ),
                              ),
                              child: const Text(
                                "Forgot password?",
                                style: TextStyle(
                                  color: Color(0xff888888),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: isSmallScreen ? 18 : 24),

                          // ── Login Button ──
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
                                onTap: _isLoading ? null : _loginWithEmail,
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
                                          "Log in",
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

                          SizedBox(height: isSmallScreen ? 16 : 22),

                          // ── Divider ──
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: Color(0xffe5e5e5),
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  "Or login with",
                                  style: TextStyle(
                                    color: const Color(0xff888888),
                                    fontSize: isSmallScreen ? 11 : 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: Color(0xffe5e5e5),
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: isSmallScreen ? 16 : 20),

                          // ── Social Buttons ──
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _socialButton(
                                onTap: () => debugPrint("Facebook"),
                                child: Image.asset(
                                  'assets/images/facebook.png',
                                  height: isSmallScreen ? 18 : 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              _socialButton(
                                onTap: () => debugPrint("Apple"),
                                child: Icon(
                                  Icons.apple_rounded,
                                  color: const Color(0xff1a1a1a),
                                  size: isSmallScreen ? 18 : 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              _socialButton(
                                onTap: _isLoading
                                    ? null
                                    : _handleGoogleSignIn,
                                child: _isLoading
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color:
                                              const Color(0xff888888),
                                        ),
                                      )
                                    : Image.asset(
                                        'assets/images/googleIcon.png',
                                        height: isSmallScreen ? 18 : 20,
                                      ),
                              ),
                            ],
                          ),

                          SizedBox(height: isSmallScreen ? 18 : 24),

                          // ── Sign Up Link ──
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account?",
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
                                      builder: (_) => const SignUp2(),
                                    ),
                                  ),
                                  child: const Text(
                                    "Sign up",
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

  Widget _socialButton({
    required VoidCallback? onTap,
    required Widget child,
  }) {
    return Container(
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
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: child,
          ),
        ),
      ),
    );
  }
}