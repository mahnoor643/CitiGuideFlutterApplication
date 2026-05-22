import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Admin/admin.dart';
import 'package:citi_guide/screens/Admin/fetchData.dart';
import 'package:citi_guide/screens/Cities/cities.dart';
import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:citi_guide/screens/SearchScreen/searchScreen.dart';
import 'package:citi_guide/screens/SignOut/signOut.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String username;
  final String profile;
  const ProfileScreen({
    super.key,
    required this.userId,
    required this.email,
    required this.username,
    required this.profile,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isObscured = true;
  int selectedIndex = 3;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();

  // ─── Validators ───────────────────────────────────────────────────────────

  String? validatePwd(String? pwd) {
    if (pwd == null || pwd.isEmpty) return null; // optional
    RegExp passwordRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).{8,}$');
    if (!passwordRegex.hasMatch(pwd)) {
      return 'Password must be 8+ characters\nincluding digits and alphabets';
    }
    return null;
  }

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    usernameController.text = widget.username;
  }

  @override
  void dispose() {
    usernameController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  // ─── Profile Image ────────────────────────────────────────────────────────

  // Image picker commented out — future mein enable karna ho toh uncomment karo
  /*
  import 'dart:io';
  import 'package:path_provider/path_provider.dart';
  import 'package:path/path.dart' as path;
  import 'package:flutter/foundation.dart';
  import 'package:image_picker/image_picker.dart';

  String? _savedImagePath;
  Uint8List? _image;

  void selectImage() async { ... }
  ImageProvider getImageProvider() { ... }
  */

  ImageProvider getImageProvider() {
    if (widget.profile.startsWith('http')) {
      return NetworkImage(widget.profile);
    }
    return AssetImage(widget.profile);
  }

  // ─── Snackbar ─────────────────────────────────────────────────────────────

  void showMessage(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Constants.OrangeColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // ─── Current Password Dialog ──────────────────────────────────────────────

  Future<String?> _askCurrentPassword() async {
    final TextEditingController currentPwdController = TextEditingController();
    bool obscure = true;

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Confirm Identity',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Enter your current password to save changes.',
                    style: TextStyle(
                      color: Constants.greyTextColor,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: currentPwdController,
                    obscureText: obscure,
                    cursorColor: Constants.greyTextColor,
                    decoration: InputDecoration(
                      hintText: 'Current password',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Constants.greyTextColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Constants.greyTextColor),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () =>
                            setStateDialog(() => obscure = !obscure),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Constants.greyTextColor),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pop(context, currentPwdController.text.trim()),
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      color: Constants.OrangeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ─── Update Logic ─────────────────────────────────────────────────────────

  Future<void> updateUserData(String userId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        showMessage('User not logged in!');
        return;
      }

      // ── Step 1: Current password maango ──
      String? currentPassword = await _askCurrentPassword();
      if (currentPassword == null || currentPassword.isEmpty) {
        showMessage('Current password is required to update profile.');
        return;
      }

      // ── Step 2: Re-authenticate ──
      try {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
      } catch (reAuthError) {
        debugPrint('Re-auth error: $reAuthError');
        showMessage('Incorrect current password. Please try again.');
        return;
      }

      // ── Step 3: Firebase Auth update (username + password only) ──
      try {
        // Username (displayName) update
        await user.updateDisplayName(usernameController.text.trim());

        // Password — sirf tab jab naya likha ho
        if (pwdController.text.trim().isNotEmpty) {
          await user.updatePassword(pwdController.text.trim());
        }
      } catch (authError) {
        debugPrint('Auth update error: $authError');
        showMessage('Auth update failed. Please try again.');
        return;
      }

      // ── Step 4: Firestore update (username only — email same rahegi) ──
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'username': usernameController.text.trim(),
        // email: change nahi hogi
        // profile: image picker disabled hai abhi
      });

      showMessage('Profile updated successfully!');
      await Future.delayed(const Duration(seconds: 1));

      await FirebaseAuth.instance.signOut();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignOutScreen()),
        (route) => false,
      );
    } catch (error) {
      debugPrint('Error: $error');
      showMessage('Error updating profile! Try again.');
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ── Profile Header ──
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: Image.asset(
                  'assets/images/profileScreenAbove.png',
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Stack(
                    children: [
                      // Image picker icon commented out
                      ClipOval(
                        child: CircleAvatar(
                          radius: 90,
                          backgroundColor: Colors.transparent,
                          backgroundImage: getImageProvider(),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Constants.whiteColor,
                                width: 4.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // ── Image picker icon — commented out ──
                      // Positioned(
                      //   left: 120,
                      //   child: IconButton(
                      //     onPressed: selectImage,
                      //     icon: Icon(Icons.edit_square, color: Constants.greyTextColor),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Form ──
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Username display
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.username,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),

                      // Email display (read-only)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.email,
                            style: TextStyle(
                              color: Constants.greyTextColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── Name Field ──
                      Row(
                        children: [
                          Icon(Icons.manage_accounts_outlined,
                              color: Constants.greyTextColor, size: 13),
                          Text(
                            " Name",
                            style: TextStyle(
                                fontSize: 13, color: Constants.greyTextColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        cursorColor: Constants.greyTextColor,
                        controller: usernameController,
                        validator: (val) => (val?.length ?? 0) < 3
                            ? 'Username should be at least 3 characters'
                            : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.greyTextColor),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.greyTextColor),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          hintText: 'Your name',
                          suffixIcon:
                              const Icon(Icons.edit, color: Colors.grey),
                        ),
                        style: TextStyle(color: Constants.greyTextColor),
                      ),
                      const SizedBox(height: 10),

                      // ── Email Field — commented out (Firebase email update needs verification) ──
                      // Row(children: [ Icon(Icons.mail...), Text(" Email"...) ]),
                      // TextFormField(controller: emailController, ...),

                      // ── Password Field ──
                      Row(
                        children: [
                          Icon(Icons.lock,
                              color: Constants.greyTextColor, size: 13),
                          Text(
                            " New Password (optional)",
                            style: TextStyle(
                                fontSize: 13, color: Constants.greyTextColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        cursorColor: Constants.greyTextColor,
                        controller: pwdController,
                        keyboardType: TextInputType.text,
                        validator: validatePwd,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.greyTextColor),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.greyTextColor),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          hintText: 'Leave empty to keep current password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                          ),
                        ),
                        style: TextStyle(color: Constants.greyTextColor),
                        obscureText: _isObscured,
                      ),

                      // ── Admin Options ──
                      if (widget.email == 'admin12@gmail.com') ...[
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FetchData()),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                "Added Locations",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminScreen(
                                  userId: widget.userId,
                                  email: widget.email,
                                  username: widget.username,
                                  profile: widget.profile,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                "Add A New Place !",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // ── Update Button ──
                      BlueButton(
                        topBottomPadding: 10,
                        leftRightPadding: 10,
                        widget_: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Update Profile",
                              style: TextStyle(
                                color: Constants.whiteColor,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                            Icon(Icons.arrow_forward,
                                color: Constants.whiteColor),
                          ],
                        ),
                        OntapFunction: () async {
                          if (_formKey.currentState!.validate()) {
                            await updateUserData(widget.userId);
                          }
                        },
                        topBottomMargin: 20,
                        leftRightMargin: 90,
                      ),

                      // ── Sign Out Button ──
                      Row(
                        children: [
                          const Spacer(),
                          BlueButton(
                            topBottomPadding: 10,
                            leftRightPadding: 10,
                            widget_: Icon(Icons.arrow_forward,
                                color: Constants.whiteColor),
                            OntapFunction: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignOutScreen(),
                                ),
                              );
                            },
                            topBottomMargin: 20,
                            leftRightMargin: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // ── Bottom Nav Bar ──
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Constants.whiteColor, width: 1.0),
          color: Constants.whiteColor,
boxShadow: [
  BoxShadow(
    color: Colors.black.withOpacity(0.50), // Opacity ko 12% se badha kar 25% kar diya (Bright/Dark look)
    blurRadius: 22,                       // Shadow ko thoda crisp rakhne ke liye blur kam kiya
    offset: const Offset(0, 10),           // Shadow ko thoda neeche push kiya taake floating effect aaye
    spreadRadius: 1,                      // Shadow ko thoda phailane ke liye
  ),
],        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            backgroundColor: Constants.whiteColor,
            color: Constants.greyTextColor,
            activeColor: Constants.whiteColor,
            selectedIndex: selectedIndex,
            onTabChange: (index) {
              setState(() {
                selectedIndex = index;
              });
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Dashboard(
                      userId: widget.userId,
                      email: widget.email,
                      username: widget.username,
                      profile: widget.profile,
                    ),
                  ),
                );
              } else if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CitiesScreen(
                      userId: widget.userId,
                      email: widget.email,
                      username: widget.username,
                      profile: widget.profile,
                    ),
                  ),
                );
              } else if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(
                      userId: widget.userId,
                      email: widget.email,
                      username: widget.username,
                      profile: widget.profile,
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      userId: widget.userId,
                      email: widget.email,
                      username: widget.username,
                      profile: widget.profile,
                    ),
                  ),
                );
              }
            },
            tabBackgroundColor: Constants.OrangeColor,
            gap: 8,
            padding: const EdgeInsets.all(11),
            tabs: const [
              GButton(icon: Icons.home, text: "Home"),
              GButton(icon: Icons.language, text: "Cities"),
              GButton(icon: Icons.search, text: "Search"),
              GButton(
                  icon: Icons.supervised_user_circle_sharp, text: "Profile"),
            ],
          ),
        ),
      ),
    );
  }
}