import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Cities/cities.dart';
import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:citi_guide/screens/SearchScreen/searchScreen.dart';
import 'package:citi_guide/screens/SignOut/signOut.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String username;
  final String profile;
  const ProfileScreen(
      {super.key,
      required this.userId,
      required this.email,
      required this.username,
      required this.profile});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //Initial state for controller
  @override
  void initState() {
    usernameController.text = widget.username;
    emailController.text = widget.email;
  }

  //TextField Controllers
  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController pwdController = new TextEditingController();
  //Edit data function
  Future<void> updateUserData(
      String userId, String newEmail, String newUsername) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'email': emailController.text,
        'username': usernameController.text,
      });
      //Image update
      if(_image!=null){
      uploadImageToStorage('profile/$userId', _image!);
      }
      print('User data updated successfully');
    } catch (error) {
      print('Error updating user data: $error');
    }
  }

  //Auth Update
  Future<void> updateUserInfo(String newEmail, String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.verifyBeforeUpdateEmail(newEmail);
        await user.updatePassword(newPassword);

        // Reload the user to get updated information
        await user.reload();
        user = FirebaseAuth.instance.currentUser;

        print('User information updated successfully');
        print('New email: ${user!.email}');
      } else {
        print('User not found');
      }
    } catch (error) {
      print('Error updating user information: $error');
    }
  }

  bool _isObscured = true;
  int selectedIndex = 3;

  //Image Picker
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    print("data saved");
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print("No image is selected");
  }

  Uint8List? _image;
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //profile design
          Stack(
            children: [
              Container(
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/profileScreenAbove.png',
                    fit: BoxFit.cover,
                  )),
              Center(
                child: Container(
                  padding: const EdgeInsets.only(top: 80),
                  child: Stack(children: [
                    ClipOval(
                      child: CircleAvatar(
                        radius: 90,
                        backgroundColor: Colors
                            .transparent, // Set background color to transparent if you want to see the border
                        backgroundImage: _image == null
                            ? NetworkImage(widget.profile)
                            : _image!.isNotEmpty
                                ? MemoryImage(_image!)
                                    as ImageProvider<Object>?
                                : null,

                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Constants
                                  .whiteColor, // Set your desired border color
                              width: 4.0, // Set the width of the border
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: IconButton(
                          onPressed: () {
                            selectImage();
                          },
                          icon: Icon(
                            Icons.edit_square,
                            color: Constants.greyTextColor,
                          )),
                      left: 120,
                    )
                  ]),
                ),
              ),
            ],
          ),
          //Name Displaying
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.username,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    //mail
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
                    const SizedBox(
                      height: 20,
                    ),

                    //TextFields
                    Row(
                      children: [
                        Icon(
                          Icons.manage_accounts_outlined,
                          color: Constants.greyTextColor,
                          size: 13,
                        ),
                        Text(
                          " Name",
                          style: TextStyle(
                            fontSize: 13,
                            color: Constants.greyTextColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    //Email TextField
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            60.0), // Adjust this value for more circular corners
                        color: Constants.whiteColor,
                        border: Border.all(
                          color: Constants
                              .greyTextColor, // Set your desired border color
                          width: 2.0, // Set the width of the border
                        ),
                      ),
                      child: TextFormField(
                        cursorColor: Constants.greyTextColor,
                        controller: usernameController,
                        decoration: InputDecoration(
                          hintText: 'Your name',
                          border: InputBorder.none, // Remove the default border
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              // Handle visibility toggle
                            },
                          ),
                        ),
                        style: TextStyle(
                          color: Constants.greyTextColor,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    //TextFields
                    Row(
                      children: [
                        Icon(
                          Icons.mail,
                          color: Constants.greyTextColor,
                          size: 13,
                        ),
                        Text(
                          " Email",
                          style: TextStyle(
                            fontSize: 13,
                            color: Constants.greyTextColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    //Email TextField
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            60.0), // Adjust this value for more circular corners
                        color: Constants.whiteColor,
                        border: Border.all(
                          color: Constants
                              .greyTextColor, // Set your desired border color
                          width: 2.0, // Set the width of the border
                        ),
                      ),
                      child: TextField(
                        cursorColor: Constants.greyTextColor,
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Your email',
                          border: InputBorder.none, // Remove the default border
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              // Handle visibility toggle
                            },
                          ),
                        ),
                        style: TextStyle(
                          color: Constants.greyTextColor,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    //TextFields
                    Row(
                      children: [
                        Icon(
                          Icons.lock,
                          color: Constants.greyTextColor,
                          size: 13,
                        ),
                        Text(
                          " Password",
                          style: TextStyle(
                            fontSize: 13,
                            color: Constants.greyTextColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            60.0), // Adjust this value for more circular corners
                        color: Constants.whiteColor,
                        border: Border.all(
                          color: Constants
                              .greyTextColor, // Set your desired border color
                          width: 2.0, // Set the width of the border
                        ),
                      ),
                      child: TextField(
                        cursorColor: Constants.greyTextColor,
                        controller: pwdController,
                        decoration: InputDecoration(
                          hintText: 'Your password',
                          border: InputBorder.none, // Remove the default border
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
                        style: TextStyle(
                          color: Constants.greyTextColor,
                        ),
                        obscureText: _isObscured,
                      ),
                    ),

                    BlueButton(
                        topBottomPadding: 10,
                        leftRightPadding: 20,
                        widget_: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sign out",
                              style: TextStyle(
                                color: Constants.whiteColor,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Constants.whiteColor,
                            ),
                          ],
                        ),
                        OntapFunction: () async {
                          await updateUserData(widget.userId,
                              emailController.text, usernameController.text);
                          updateUserInfo(
                              emailController.text, pwdController.text);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignOutScreen()));
                        },
                        topBottomMargin: 20,
                        leftRightMargin: 90)
                  ],
                ),
              ),
            ),
          )
        ],
      ),

      // Navigation Bar
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Constants.whiteColor, // Set your border color
            width: 1.0, // Set your border width
          ),
          color: Constants.whiteColor,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 25)],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            backgroundColor: Constants.whiteColor,
            color: Constants.greyTextColor,
            activeColor: Constants.whiteColor,
            onTabChange: (index) {
              // Update the selected index
              setState(() {
                selectedIndex = index;
              });
              // Handle tab change
              if (index == 0) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Dashboard()));
              } else if (index == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CitiesScreen()));
              } else if (index == 2) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchScreen()));
              } else {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const ProfileScreen()));
              }
            },
            tabBackgroundGradient: Constants.orangeGradient,
            gap: 8,
            padding: EdgeInsets.all(11),
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
