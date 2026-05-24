import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Admin/admin.dart';
import 'package:citi_guide/screens/Admin/fetchData.dart';
import 'package:citi_guide/screens/Cities/SelectCity.dart';
import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:citi_guide/screens/SignUpPages/signUp2.dart';
import 'package:citi_guide/screens/forgotPassword/forgotPwd.dart';
import 'package:citi_guide/widgets/blueButton.dart';
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

    // ✅ Check if first-time login
    final bool isFirstTimeLogin = !userDoc.exists;

    if (isFirstTimeLogin) {
      // Create new user document for first-time login
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': user.email ?? '',
        'id': user.uid,
        'username': user.displayName ?? 'User',
        'role': 'user',
        'profile': user.photoURL ?? 'assets/images/profileDefaultImg.jpg',
        'city': '', // Empty for first-time
        'interests': [], // Empty for first-time
      });
    }

    await _navigateBasedOnLogin(user.uid, isFirstTimeLogin);
  }

  // ── Navigation based on login type (first-time or returning) ──
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

    debugPrint('✅ Login Check:');
    debugPrint('   isFirstTimeLogin: $isFirstTimeLogin');
    debugPrint('   roleVal: $roleVal');
    debugPrint('   cityVal: "$cityVal"');
    debugPrint('   interestsVal: $interestsVal');

    // ✅ LOGIC: Check user role first, then check if first-time login
    if (roleVal == 'admin') {
      debugPrint('🔴 Navigating to Admin');
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
      // Regular user
      if (isFirstTimeLogin) {
        // ✅ First time: Go to SelectCity (need to select city and interests)
        debugPrint('🟡 First-time user → SelectCity');
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
        // ✅ Returning user with complete profile: Go to Dashboard
        debugPrint('🟢 Returning user with profile → Dashboard');
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
        // ✅ Returning user but missing city/interests: Go to SelectCity
        debugPrint('🟡 Returning user incomplete profile → SelectCity');
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
      // ✅ For email login: Check if city and interests are set
      if (cityVal.isNotEmpty && interestsVal.isNotEmpty) {
        // Has completed profile: Go to Dashboard
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
        // Missing city/interests: Go to SelectCity
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

  // ── Validators ─────────────────────────────────────────────────
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

  // ── Email Login ────────────────────────────────────────────────
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

  // ── Google Sign-In ─────────────────────────────────────────────
  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      if (kIsWeb) {
        // ✅ WEB: Firebase ka built-in Google popup
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithPopup(googleProvider);

        if (userCredential.user != null) {
          await _handleFirestoreUserSync(userCredential.user!);
        }
      } else {
        // ✅ MOBILE: google_sign_in package
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

  // ── Build ──────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.pageBackgroundColor,
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Logo
              Row(
                children: [
                  const Spacer(),
                  Image.asset(Constants.appLogo, height: 40),
                ],
              ),

              // Title
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

              // Email Label
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

              // Email Field
              TextFormField(
                cursorColor: Constants.greyTextColor,
                controller: email,
                validator: validateEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.transparent),
                  ),
                  filled: true,
                  fillColor: Constants.greyColor,
                  hintText: '   Your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Constants.buttonBorderRadius),
                    borderSide: BorderSide(color: Constants.greyColor),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: Constants.searchBarButtonHeight,
                    horizontal: 15,
                  ),
                ),
                style: TextStyle(color: Constants.greyTextColor),
              ),

              // Password Label
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

              // Password Field
              TextFormField(
                cursorColor: Colors.grey,
                controller: pwd,
                obscureText: _isObscured,
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
              ),

              // Forgot Password
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ForgotPwdScreen()),
                      ),
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'myfonts',
                          fontSize: 12,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Login Button
              BlueButton(
                topBottomPadding: Constants.searchBarButtonHeight,
                leftRightPadding: 10,
                widget_: _isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        "Log in",
                        style: TextStyle(
                          color: Constants.greyColor,
                          fontFamily: 'myfonts',
                          fontSize: 12,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                OntapFunction: _isLoading ? () {} : _loginWithEmail,
                topBottomMargin: 0,
                leftRightMargin: 0,
              ),
              const SizedBox(height: 20),

              // Divider
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 1,
                      width: 60,
                      color: Colors.black,
                      margin: const EdgeInsets.symmetric(horizontal: 20)),
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
                      width: 60,
                      color: Colors.black,
                      margin: const EdgeInsets.symmetric(horizontal: 20)),
                ],
              ),
              const SizedBox(height: 20),

              // Social Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Facebook
                  _socialIconButton(
                    onTap: () => debugPrint("Facebook btn"),
                    child: Image.asset('assets/images/facebook.png', height: 20),
                  ),

                  // Apple
                  _socialIconButton(
                    onTap: () => debugPrint("Apple btn"),
                    child: const Icon(Icons.apple, size: 20),
                  ),

                  // Google
                  _socialIconButton(
                    onTap: _isLoading ? null : _handleGoogleSignIn,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.grey),
                          )
                        : Image.asset('assets/images/googleIcon.png', height: 20),
                  ),
                ],
              ),

              const Spacer(),

              // Sign Up
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
                          fontWeight: FontWeight.w200),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignUp2()),
                      ),
                      child: const Text(
                        " Sign up",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
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

  Widget _socialIconButton({required Widget child, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Constants.greyColor,
          borderRadius: BorderRadius.circular(Constants.buttonBorderRadius),
          border: Border.all(color: Constants.greyTextColor),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: child,
        ),
      ),
    );
  }
}