import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String username;
  final String profile;
  const AdminScreen({
    super.key,
    required this.userId,
    required this.email,
    required this.username,
    required this.profile,
  });

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // Success/Error message
  void successMessage(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Constants.OrangeColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Add Details to Firestore
  Future<void> addDetails(
    String city,
    String location,
    String timings,
    String distance,
    String description,
    String contact,
    String locationName,
  ) async {
    try {
      if (imageNameController.text.trim().isEmpty) {
        successMessage('Please enter image name!');
        return;
      }

      await FirebaseFirestore.instance
          .collection('destinationDetails')
          .add({
        'city': city,
        'location': location,
        'timings': timings,
        'distance': distance,
        'description': description,
        'contact': contact,
        'locationName': locationName,
        'imagePath': 'assets/images/${imageNameController.text.trim()}', // ✅ asset path
      });

      successMessage('Data added successfully!');

      // Clear all fields after success
      cityController.clear();
      locationNameController.clear();
      locationController.clear();
      timingsController.clear();
      contactController.clear();
      distanceController.clear();
      imageNameController.clear();
      descriptionController.clear();

    } catch (error) {
      print(error);
      successMessage('Error occurred!!');
    }
  }

  // Validation
  final _formKey = GlobalKey<FormState>();

  // Location Validation
  String? validateLocation(String? location) {
    RegExp locationRegex = RegExp(r'^-?\d+(\.\d+)?,\s*-?\d+(\.\d+)?$');
    final isValid = locationRegex.hasMatch(location ?? '');
    if (!isValid) {
      return 'Add Longitude and Latitude';
    }
    return null;
  }

  // Contact Number Validation
  String? validateContact(String? contact) {
    RegExp contactRegex = RegExp(r'^\+92[0-9]{10}$');
    final isValid = contactRegex.hasMatch(contact ?? '');
    if (!isValid) {
      return 'Add number starting with +92';
    }
    return null;
  }

  // TextField Controllers
  final TextEditingController cityController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController timingsController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController locationNameController = TextEditingController(); // ✅ fixed
  final TextEditingController imageNameController = TextEditingController();   // ✅ new

  // Helper: InputDecoration
  InputDecoration buildInputDecoration(String hint) {
    return InputDecoration(
      isDense: true,
      hintText: hint,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Constants.greyTextColor),
        borderRadius: BorderRadius.circular(30.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Constants.greyTextColor),
        borderRadius: BorderRadius.circular(30.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(30.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(30.0),
      ),
    );
  }

  // Helper: Label
  Widget buildLabel(String label) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Constants.greyTextColor),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          // Profile design
          Stack(
            children: [
              Container(
                width: double.infinity,
                child: Image.asset(
                  'assets/images/profileScreenAbove.png',
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.only(top: 80),
                  child: ClipOval(
                    child: CircleAvatar(
                      radius: 90,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          const AssetImage('assets/images/profile2.png'),
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
                ),
              ),
            ],
          ),

          // Form
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Admin Name
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Admin",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),

                      // Admin Email
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // City Name
                      buildLabel("Add A New City"),
                      const SizedBox(height: 5),
                      TextFormField(
                        validator: (val) =>
                            val!.length < 3 ? 'Invalid City Name' : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        cursorColor: Constants.greyTextColor,
                        controller: cityController,
                        decoration: buildInputDecoration('Enter City Name'),
                        style: TextStyle(color: Constants.greyTextColor),
                      ),
                      const SizedBox(height: 10),

                      // Location Name
                      buildLabel("Name for Location"),
                      const SizedBox(height: 5),
                      TextFormField(
                        validator: (val) =>
                            val!.length < 3 ? 'Invalid' : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        cursorColor: Constants.greyTextColor,
                        controller: locationNameController, // ✅ fixed
                        decoration:
                            buildInputDecoration('Enter Your Destination'),
                        style: TextStyle(color: Constants.greyTextColor),
                      ),
                      const SizedBox(height: 10),

                      // Location Coordinates
                      buildLabel("Add Location (Latitude, Longitude)"),
                      const SizedBox(height: 5),
                      TextFormField(
                        cursorColor: Constants.greyTextColor,
                        controller: locationController,
                        validator: validateLocation,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: buildInputDecoration(
                            'e.g 24.8607, 67.0011'),
                        style: TextStyle(color: Constants.greyTextColor),
                      ),
                      const SizedBox(height: 10),

                      // Timings
                      buildLabel("Add Opening Timings"),
                      const SizedBox(height: 5),
                      TextFormField(
                        cursorColor: Constants.greyTextColor,
                        controller: timingsController,
                        validator: (val) =>
                            val!.length < 3 ? 'Add time with its unit' : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration:
                            buildInputDecoration('Enter Opening Timings'),
                        style: TextStyle(color: Constants.greyTextColor),
                      ),
                      const SizedBox(height: 10),

                      // Contact
                      buildLabel("Add Contact Number"),
                      const SizedBox(height: 5),
                      TextFormField(
                        cursorColor: Constants.greyTextColor,
                        controller: contactController,
                        validator: validateContact,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration:
                            buildInputDecoration('Enter Contact Number'),
                        style: TextStyle(color: Constants.greyTextColor),
                      ),
                      const SizedBox(height: 10),

                      // Distance
                      buildLabel("Add Distance"),
                      const SizedBox(height: 5),
                      TextFormField(
                        cursorColor: Constants.greyTextColor,
                        controller: distanceController,
                        validator: (val) =>
                            val!.length < 3 ? 'Add distance with unit' : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration:
                            buildInputDecoration('Enter Distance e.g 3.2 Km'),
                        style: TextStyle(color: Constants.greyTextColor),
                      ),
                      const SizedBox(height: 10),

                      // ✅ Image Name TextField
                      buildLabel("Add Image Name"),
                      const SizedBox(height: 5),
                      TextFormField(
                        cursorColor: Constants.greyTextColor,
                        controller: imageNameController,
                        validator: (val) =>
                            val!.trim().isEmpty ? 'Image name required' : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: buildInputDecoration(
                            'Enter image name e.g karachi.png'),
                        style: TextStyle(color: Constants.greyTextColor),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.info_outline,
                              size: 12, color: Constants.greyTextColor),
                          const SizedBox(width: 4),
                          Text(
                            'Image must exist in assets/images/ folder',
                            style: TextStyle(
                              fontSize: 11,
                              color: Constants.greyTextColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Description
                      buildLabel("Add Description"),
                      const SizedBox(height: 5),
                      TextFormField(
                        cursorColor: Constants.greyTextColor,
                        controller: descriptionController,
                        maxLines: 3,
                        validator: (val) => val!.length < 20
                            ? 'Must contain 20 characters'
                            : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: buildInputDecoration('Enter Description'),
                        style: TextStyle(color: Constants.greyTextColor),
                      ),
                      const SizedBox(height: 10),

                      // Submit Button
                      BlueButton(
                        topBottomPadding: 10,
                        leftRightPadding: 20,
                        widget_: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Add details",
                              style: TextStyle(color: Constants.whiteColor),
                            ),
                            Icon(Icons.arrow_forward,
                                color: Constants.whiteColor),
                          ],
                        ),
                        OntapFunction: () async {
                          if (_formKey.currentState!.validate()) {
                            await addDetails(
                              cityController.text,
                              locationController.text,
                              timingsController.text,
                              distanceController.text,
                              descriptionController.text,
                              contactController.text,
                              locationNameController.text, // ✅ fixed
                            );
                          }
                        },
                        topBottomMargin: 20,
                        leftRightMargin: 90,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}