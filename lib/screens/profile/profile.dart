import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Admin/admin.dart';
import 'package:citi_guide/screens/Admin/fetchData.dart';
import 'package:citi_guide/screens/Cities/cities.dart';
import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:citi_guide/screens/Saved/Saved.dart';
import 'package:citi_guide/screens/SearchScreen/searchScreen.dart';
import 'package:citi_guide/screens/SignOut/signOut.dart';
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

  String? validatePwd(String? pwd) {
    if (pwd == null || pwd.isEmpty) return null;
    RegExp passwordRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).{8,}$');
    if (!passwordRegex.hasMatch(pwd)) {
      return 'Password must be 8+ characters\nincluding digits and alphabets';
    }
    return null;
  }

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

ImageProvider getImageProvider() {
  if (widget.profile.isEmpty || widget.profile == 'assets/images/profileDefaultImg.jpg') {
    return AssetImage('assets/images/profileDefaultImg.jpg');
  }
  if (widget.profile.startsWith('http')) {
    return NetworkImage(widget.profile);
  }
  return AssetImage(widget.profile);
}

  void showMessage(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Constants.OrangeColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

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
                      color: const Color(0xff888888),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: currentPwdController,
                    obscureText: obscure,
                    cursorColor: Constants.OrangeColor,
                    decoration: InputDecoration(
                      hintText: 'Current password',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xffe5e5e5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Constants.OrangeColor,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure ? Icons.visibility_off : Icons.visibility,
                          color: const Color(0xff999999),
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
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Color(0xff888888)),
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

  Future<void> updateUserData(String userId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        showMessage('User not logged in!');
        return;
      }

      String? currentPassword = await _askCurrentPassword();
      if (currentPassword == null || currentPassword.isEmpty) {
        showMessage('Current password is required to update profile.');
        return;
      }

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

      try {
        await user.updateDisplayName(usernameController.text.trim());

        if (pwdController.text.trim().isNotEmpty) {
          await user.updatePassword(pwdController.text.trim());
        }
      } catch (authError) {
        debugPrint('Auth update error: $authError');
        showMessage('Auth update failed. Please try again.');
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'username': usernameController.text.trim(),
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xfffbf8f3),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // ── Profile Avatar ──
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey.shade100,
                    backgroundImage: getImageProvider(),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── User Info ──
              Text(
                widget.username,
                style: const TextStyle(
                  color: Color(0xff1a1a1a),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.3,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 6),

              Text(
                widget.email,
                style: const TextStyle(
                  color: Color(0xff888888),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),

              // ── Form Container ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Name Field ──
                      _buildFieldLabel("Name", Icons.person_rounded),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: usernameController,
                        hintText: 'Your name',
                        validator: (val) => (val?.length ?? 0) < 3
                            ? 'Username should be at least 3 characters'
                            : null,
                      ),

                      const SizedBox(height: 20),

                      // ── Password Field ──
                      _buildFieldLabel("New Password (optional)", Icons.lock_rounded),
                      const SizedBox(height: 8),
                      _buildPasswordField(
                        controller: pwdController,
                        hintText: 'Leave empty to keep current password',
                        validator: validatePwd,
                      ),

                      const SizedBox(height: 24),

                      // ── Admin Options ──
                      if (widget.email == 'admin12@gmail.com') ...[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
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
                          child: Column(
                            children: [
                              _buildAdminButton(
                                title: 'Added Locations',
                                icon: Icons.location_on_rounded,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FetchData(
                                        userId: widget.userId,
                                        email: widget.email,
                                        username: widget.username,
                                        profile: widget.profile,
                                      ),
                                    ),
                                  );
                                },
                                isFirst: true,
                              ),
                              const Divider(
                                height: 1,
                                color: Color(0xfff0f0f0),
                              ),
                              _buildAdminButton(
                                title: 'Add A New Place',
                                icon: Icons.add_location_rounded,
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
                                isFirst: false,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // ── Action Buttons ──
                      Row(
                        children: [
                          // Update Button
                          Expanded(
                            child: Container(
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
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await updateUserData(widget.userId);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.check_rounded,
                                            color: Colors.white, size: 18),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Update Profile',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Sign Out Button
                          Container(
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
                                      builder: (context) =>
                                          const SignOutScreen(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Icon(
                                    Icons.logout_rounded,
                                    color: Constants.OrangeColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ── Bottom Navigation Bar ──
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: size.height * 0.02,
          left: size.width * 0.05,
          right: size.width * 0.05,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, -4),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: GNav(
              backgroundColor: Colors.white,
              color: const Color(0xffb0b0b0),
              activeColor: Colors.white,
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                setState(() => selectedIndex = index);
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
                      builder: (context) => SavedScreen(
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
              padding: const EdgeInsets.all(10),
              tabs: const [
                GButton(
                  icon: Icons.home_rounded,
                  text: "Home",
                  textStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                GButton(
                  icon: Icons.bookmark_rounded,
                  text: "Saved",
                  textStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                GButton(
                  icon: Icons.search_rounded,
                  text: "Search",
                  textStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                GButton(
                  icon: Icons.person_rounded,
                  text: "Profile",
                  textStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Helper Widgets ───────────────────────────────────────────────────────

  Widget _buildFieldLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xff888888), size: 16),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xff888888),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      cursorColor: Constants.OrangeColor,
      controller: controller,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xffaaaaaa),
          fontSize: 13,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffe5e5e5)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Constants.OrangeColor),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
      style: const TextStyle(
        color: Color(0xff1a1a1a),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      cursorColor: Constants.OrangeColor,
      controller: controller,
      keyboardType: TextInputType.text,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: _isObscured,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xffaaaaaa),
          fontSize: 13,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffe5e5e5)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Constants.OrangeColor),
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            color: const Color(0xff999999),
            size: 18,
          ),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
      style: const TextStyle(
        color: Color(0xff1a1a1a),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildAdminButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required bool isFirst,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: isFirst
            ? const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              )
            : const BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          child: Row(
            children: [
              Icon(icon, color: Constants.OrangeColor, size: 18),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff1a1a1a),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_rounded,
                color: const Color(0xffd0d0d0),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}