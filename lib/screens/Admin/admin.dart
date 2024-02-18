import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Cities/cities.dart';
import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:citi_guide/screens/Login/login.dart';
import 'package:citi_guide/screens/SearchScreen/searchScreen.dart';
import 'package:citi_guide/screens/profile/profile.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:citi_guide/widgets/greyButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_picker/image_picker.dart';

class AdminScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String username;
  final String profile;
  const AdminScreen({super.key, required this.userId, required this.email, required this.username, required this.profile});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  //Successfull added data msg displaying
  void successMessage(String successMsg) {
    final snackBar = SnackBar(
      content: Text(successMsg),
      backgroundColor: Constants.OrangeColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //Info Add
  Future<void> addDetails(
      String city,
      String location,
      String timings,
      String distance,
      String description,
      String contact,
      String locationName) async {
    try {
      // Making users class to add further details
      final destinationReference = await FirebaseFirestore.instance
          .collection('destinationDetails')
          .add({
        'city': city,
        'location': location,
        'timings': timings,
        'distance': distance,
        'description': description,
        'contact': contact,
        'locationName': locationName,
      });
      final String destinationID = destinationReference.id;

      //Adding Image aswell
      uploadImageToStorage('locations/$destinationID', _image!);
      String successMsg = 'Data added successfully';
      successMessage(successMsg);
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => const Login()));
      // username.clear();
      // this above will work but bete apne stateless widget
      // use ki hui hai 1 hr laga diya error dhundne mai
    } catch (error) {
      print(error);
      String successMsg = 'Error occurred!!';
      successMessage(successMsg);
    }
  }

  //Validation
  final _formKey = GlobalKey<FormState>();
  //Location Validation
  String? validateLocation(String? location) {
    RegExp locationRegex = RegExp(r'^-?\d+(\.\d+)?,\s*-?\d+(\.\d+)?$');
    final islocationValid = locationRegex.hasMatch(location ?? '');
    if (!islocationValid) {
      return 'Add Longitude and Latitude';
    }
    return null;
  }

  //Contact Number Validation
  String? validateContact(String? contact) {
    RegExp contactRegex = RegExp(r'^\+92[0-9]{10}$');
    final iscontactValid = contactRegex.hasMatch(contact ?? '');
    if (!iscontactValid) {
      return 'Add number starting with +92';
    }
    return null;
  }

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

// final _imagePicker = ImagePicker();
// File? imageFile;

// getImage() async {
//   final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
//   if (pickedFile != null) {
//     imageFile = File(pickedFile.path);
//     print("pic aagai");
//     uploadFile(imageFile!);
//   }
// }

// final storageRef = FirebaseStorage.instance.ref();
// uploadFile(File imageFile) async {
//   UploadTask uploadTask = storageRef.child('images/imageName').putFile(imageFile);
//   print("File uploaded");
// }

  // Future<String> uploadFile(XFile? file) async {
  //   final storageRef = FirebaseStorage.instance.ref();
  //   final imagesRef = storageRef.child("images");
  //   String fileName = file!.path.split('/').last;
  //   final imageRef = imagesRef.child(fileName);
  //   String? imageUrl = null;
  //   try {
  //     final task = imageRef.putData(await file.readAsBytes());
  //     final snapshot = await task.whenComplete(() => null);

  //     // Get the download URL of the uploaded image
  //     imageUrl = await snapshot.ref.getDownloadURL();
  //     // await imageRef.putFile(file);
  //   } on FirebaseException catch (e) {
  //     print("uploadFile_Exception ${e.message}");
  //   }
  //   return imageUrl ?? "";
  // }

  //TextField Controllers
  final TextEditingController city = new TextEditingController();
  final TextEditingController location = new TextEditingController();
  final TextEditingController timings = new TextEditingController();
  final TextEditingController distance = new TextEditingController();
  final TextEditingController description = new TextEditingController();
  final TextEditingController contact = new TextEditingController();
  final TextEditingController locationName = new TextEditingController();
  int selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                  child: ClipOval(
                    child: CircleAvatar(
                      radius: 90,
                      backgroundColor: Colors
                          .transparent, // Set background color to transparent if you want to see the border
                      backgroundImage:
                          const AssetImage('assets/images/profile2.png'),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Fatima Hadid",
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
                            "fatimahadid32@gmail.com",
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
                          // Icon(
                          //   Icons.manage_accounts_outlined,
                          //   color: Constants.greyTextColor,
                          //   size: 13,
                          // ),
                          Text(
                            "Add A New City",
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

                      //City Name TextField
                      TextFormField(
                        validator: (city) =>
                            city!.length < 3 ? 'Invalid City Name' : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        cursorColor: Constants.greyTextColor,
                        controller: city,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Enter City Name',
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.greyTextColor),
                            borderRadius: BorderRadius.circular(
                                30.0), // Adjust the value for more rounded corners
                          ),
                          // Remove the default border
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.greyTextColor),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .red), // Customize the error border color
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .red), // Customize the focused error border color
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        style: TextStyle(
                          color: Constants.greyTextColor,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      //TextFields
                      Row(
                        children: [
                          // Icon(
                          //   Icons.manage_accounts_outlined,
                          //   color: Constants.greyTextColor,
                          //   size: 13,
                          // ),
                          Text(
                            "Name for Location",
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

                      //City Name TextField
                      TextFormField(
                        validator: (city) =>
                            city!.length < 3 ? 'Invalid' : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        cursorColor: Constants.greyTextColor,
                        controller: locationName,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Enter Your Destination',
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.greyTextColor),
                            borderRadius: BorderRadius.circular(
                                30.0), // Adjust the value for more rounded corners
                          ),
                          // Remove the default border
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.greyTextColor),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .red), // Customize the error border color
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .red), // Customize the focused error border color
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        style: TextStyle(
                          color: Constants.greyTextColor,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        children: [
                          // Icon(
                          //   Icons.manage_accounts_outlined,
                          //   color: Constants.greyTextColor,
                          //   size: 13,
                          // ),
                          Text(
                            "Add A Place / Location",
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

                      //Location TextField
                      TextFormField(
                        cursorColor: Constants.greyTextColor,
                        controller: location,
                        validator: validateLocation,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Enter Place / Location Name',
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.greyTextColor),
                            borderRadius: BorderRadius.circular(
                                30.0), // Adjust the value for more rounded corners
                          ),
                          // Remove the default border
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.greyTextColor),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .red), // Customize the error border color
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .red), // Customize the focused error border color
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        style: TextStyle(
                          color: Constants.greyTextColor,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        children: [
                          // Icon(
                          //   Icons.manage_accounts_outlined,
                          //   color: Constants.greyTextColor,
                          //   size: 13,
                          // ),
                          Text(
                            "Add Opening Timings",
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

                      //Timings TextField
                      TextFormField(
                        cursorColor: Constants.greyTextColor,
                        controller: timings,
                        validator: (time) => time!.length < 3
                            ? 'Add time with it\'s unit'
                            : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Enter Opening Timings',
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.greyTextColor),
                            borderRadius: BorderRadius.circular(
                                30.0), // Adjust the value for more rounded corners
                          ),
                          // Remove the default border
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.greyTextColor),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .red), // Customize the error border color
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .red), // Customize the focused error border color
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        style: TextStyle(
                          color: Constants.greyTextColor,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          // Icon(
                          //   Icons.manage_accounts_outlined,
                          //   color: Constants.greyTextColor,
                          //   size: 13,
                          // ),
                          Text(
                            "Add Contact Number",
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

                      //Contact TextField
                      TextFormField(
                        cursorColor: Constants.greyTextColor,
                        controller: contact,
                        validator: validateContact,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Enter Contact Number',
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.greyTextColor),
                            borderRadius: BorderRadius.circular(
                                30.0), // Adjust the value for more rounded corners
                          ),
                          // Remove the default border
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.greyTextColor),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .red), // Customize the error border color
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .red), // Customize the focused error border color
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        style: TextStyle(
                          color: Constants.greyTextColor,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        children: [
                          // Icon(
                          //   Icons.manage_accounts_outlined,
                          //   color: Constants.greyTextColor,
                          //   size: 13,
                          // ),
                          Text(
                            "Add Distance",
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

                      TextFormField(
                        cursorColor: Constants.greyTextColor,
                        controller: distance,
                        validator: (distance) => distance!.length < 3
                            ? 'Add distance with unit'
                            : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Enter Distance',
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.greyTextColor),
                            borderRadius: BorderRadius.circular(
                                30.0), // Adjust the value for more rounded corners
                          ),
                          // Remove the default border
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.greyTextColor),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .red), // Customize the error border color
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .red), // Customize the focused error border color
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        style: TextStyle(
                          color: Constants.greyTextColor,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        children: [
                          // Icon(
                          //   Icons.manage_accounts_outlined,
                          //   color: Constants.greyTextColor,
                          //   size: 13,
                          // ),
                          Text(
                            "Add Image",
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
                        child: GreyButton(
                            topBottomPadding: 10,
                            leftRightPadding: 10,
                            widget_: Text(
                              "Upload Image",
                              style: TextStyle(color: Constants.greyTextColor),
                            ),
                            OntapFunction: () {
                              selectImage();
                            },
                            topBottomMargin: 0,
                            leftRightMargin: 0),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        children: [
                          // Icon(
                          //   Icons.manage_accounts_outlined,
                          //   color: Constants.greyTextColor,
                          //   size: 13,
                          // ),
                          Text(
                            "Add Description",
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

                      //Description TextField

                      TextFormField(
                        cursorColor: Constants.greyTextColor,
                        controller: description,
                        validator: (desc) => desc!.length < 20
                            ? 'Must contain 20 characters'
                            : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Enter Description',
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.greyTextColor),
                            borderRadius: BorderRadius.circular(
                                30.0), // Adjust the value for more rounded corners
                          ),
                          // Remove the default border
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.greyTextColor),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .red), // Customize the error border color
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .red), // Customize the focused error border color
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        style: TextStyle(
                          color: Constants.greyTextColor,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      BlueButton(
                          topBottomPadding: 10,
                          leftRightPadding: 20,
                          widget_: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Add details",
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
                            if (_formKey.currentState!.validate()) {
                           await addDetails(
                                city.text,
                                location.text,
                                timings.text,
                                distance.text,
                                description.text,
                                contact.text,
                                locationName.text);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const SignOutScreen()));
                          }},
                          topBottomMargin: 20,
                          leftRightMargin: 90),
                      //                _image != null
                      // ? Image.memory(_image!)
                      // :  Container(child: Text("nhi hua")),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),

      
    );
  }
}
