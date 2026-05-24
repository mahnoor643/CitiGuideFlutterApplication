import 'package:citi_guide/Constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddDestinationScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String username;
  final String profile;

  const AddDestinationScreen({
    super.key,
    required this.userId,
    required this.email,
    required this.username,
    required this.profile,
  });

  @override
  State<AddDestinationScreen> createState() => _AddDestinationScreenState();
}

class _AddDestinationScreenState extends State<AddDestinationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _selectedCity;

  final List<String> _categories = [
    'Foodie Finds',
    'Peaceful Corners',
    'Insta Worthy',
    'Geek Haven',
    'City Beats',
    'Culture Trails',
  ];

  String? _selectedCategory;

  final TextEditingController cityController         = TextEditingController();
  final TextEditingController locationController     = TextEditingController();
  final TextEditingController timingsController      = TextEditingController();
  final TextEditingController distanceController     = TextEditingController();
  final TextEditingController descriptionController  = TextEditingController();
  final TextEditingController contactController      = TextEditingController();
  final TextEditingController locationNameController = TextEditingController();
  final TextEditingController imageNameController    = TextEditingController();

  @override
  void dispose() {
    cityController.dispose();
    locationController.dispose();
    timingsController.dispose();
    distanceController.dispose();
    descriptionController.dispose();
    contactController.dispose();
    locationNameController.dispose();
    imageNameController.dispose();
    super.dispose();
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor:
            isError ? Colors.red.shade600 : Constants.OrangeColor,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String? _validateLocation(String? v) {
    RegExp r = RegExp(r'^-?\d+(\.\d+)?,\s*-?\d+(\.\d+)?$');
    return r.hasMatch(v ?? '') ? null : 'Enter valid Lat, Long';
  }

  String? _validateContact(String? v) {
    RegExp r = RegExp(r'^\+92[0-9]{10}$');
    return r.hasMatch(v ?? '') ? null : 'Format: +92XXXXXXXXXX';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      _showSnack('Please select a category!', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('destinationDetails')
          .add({
        'city':         _selectedCity,
        'location':     locationController.text.trim(),
        'timings':      timingsController.text.trim(),
        'distance':     distanceController.text.trim(),
        'description':  descriptionController.text.trim(),
        'contact':      contactController.text.trim(),
        'locationName': locationNameController.text.trim(),
        'imagePath':    'assets/images/${imageNameController.text.trim()}',
        'category':     _selectedCategory,
      });

      _showSnack('Destination added successfully!');

      cityController.clear();
      locationNameController.clear();
      locationController.clear();
      timingsController.clear();
      contactController.clear();
      distanceController.clear();
      imageNameController.clear();
      descriptionController.clear();
      setState(() {
        _selectedCategory = null;
        _isLoading = false;
      });

      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnack('Error occurred!', isError: true);
    }
  }

  // ── Input Decoration ─────────────────────────────────────────
  InputDecoration _inputDeco(String hint, IconData icon) {
    return InputDecoration(
      isDense: true,
      hintText: hint,
      hintStyle: TextStyle(
          color: Constants.greyTextColor.withOpacity(0.5), fontSize: 13),
      prefixIcon: Icon(icon, color: Constants.OrangeColor, size: 18),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Constants.OrangeColor, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  // ── Section Header ───────────────────────────────────────────
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: Constants.redColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87)),
        ],
      ),
    );
  }

  // ── Form Field with label ────────────────────────────────────
  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator ??
          (v) => v!.trim().length < 2 ? 'This field is required' : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: Constants.OrangeColor,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: _inputDeco(hint, icon),
      style: TextStyle(color: Constants.greyTextColor, fontSize: 13),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double sw = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants.redColor,
        elevation: 0,
        toolbarHeight: 56,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add Destination',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── Top Banner ─────────────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(sw * 0.05, 20, sw * 0.05, 28),
              decoration: BoxDecoration(
                color: Constants.redColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.add_location_alt,
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('New Destination',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800)),
                        SizedBox(height: 3),
                        Text('Fill in the details below to add a new place',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Form Card ───────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: sw * 0.05, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Location Info ──────────────────────────
                    _sectionHeader('Location Info'),
                    _field(
                      controller: locationNameController,
                      hint: 'Destination Name',
                      icon: Icons.place,
                      validator: (v) =>
                          v!.length < 3 ? 'Enter a valid name' : null,
                    ),
                    const SizedBox(height: 12),
                    StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance.collection('cities').snapshots(),
  builder: (context, snapshot) {
    // Jab tak data load ho raha ho ya error ho
    if (snapshot.hasError) {
      return Text('Error loading cities');
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    // Firestore se data documents ki list nikalna
    final cityDocs = snapshot.data?.docs ?? [];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _selectedCity != null
              ? Constants.OrangeColor
              : Colors.grey.shade200,
          width: _selectedCity != null ? 1.5 : 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCity,
          hint: Row(
            children: [
              Icon(Icons.location_city,
                  color: Constants.OrangeColor, size: 18),
              const SizedBox(width: 10),
              Text(
                'Select City',
                style: TextStyle(
                    color: Constants.greyTextColor.withOpacity(0.5),
                    fontSize: 13),
              ),
            ],
          ),
          icon: Icon(Icons.keyboard_arrow_down,
              color: Constants.OrangeColor),
          isExpanded: true,
          style: const TextStyle(color: Colors.black87, fontSize: 13),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCity = newValue;
            });
          },
          // ✅ Firestore documents se dynamically dropdown items banana
          items: cityDocs.map((DocumentSnapshot doc) {
            // Assume kar rahe hain ke aapke document mein field ka naam 'name' ya 'cityName' hai
            final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            final String cityName = data['city'] ?? 'Unknown'; 

            return DropdownMenuItem<String>(
              value: cityName,
              child: Text(cityName),
            );
          }).toList(),
        ),
      ),
    );
  },
),
                    
                    const SizedBox(height: 12),
                    _field(
                      controller: locationController,
                      hint: 'Coordinates (e.g. 24.8607, 67.0011)',
                      icon: Icons.map,
                      validator: _validateLocation,
                    ),
                    const SizedBox(height: 20),

                    // ── Category ───────────────────────────────
                    _sectionHeader('Category'),
                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedCategory != null
                              ? Constants.OrangeColor
                              : Colors.grey.shade200,
                          width: _selectedCategory != null ? 1.5 : 1,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          hint: Row(
                            children: [
                              Icon(Icons.category,
                                  color: Constants.OrangeColor, size: 18),
                              const SizedBox(width: 10),
                              Text('Select Category',
                                  style: TextStyle(
                                      color: Constants.greyTextColor
                                          .withOpacity(0.5),
                                      fontSize: 13)),
                            ],
                          ),
                          icon: Icon(Icons.keyboard_arrow_down,
                              color: Constants.OrangeColor),
                          isExpanded: true,
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 13),
                          onChanged: (v) =>
                              setState(() => _selectedCategory = v),
                          items: _categories
                              .map((c) => DropdownMenuItem(
                                  value: c, child: Text(c)))
                              .toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Details ────────────────────────────────
                    _sectionHeader('Details'),
                    _field(
                      controller: timingsController,
                      hint: 'Opening Timings (e.g. 9AM - 10PM)',
                      icon: Icons.access_time,
                      validator: (v) =>
                          v!.length < 3 ? 'Add timings' : null,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      controller: distanceController,
                      hint: 'Distance (e.g. 3.2 Km)',
                      icon: Icons.directions_walk,
                      validator: (v) =>
                          v!.length < 2 ? 'Add distance with unit' : null,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      controller: contactController,
                      hint: 'Contact (+92XXXXXXXXXX)',
                      icon: Icons.phone,
                      validator: _validateContact,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),

                    // ── Media ──────────────────────────────────
                    _sectionHeader('Media'),
                    _field(
                      controller: imageNameController,
                      hint: 'Image filename (e.g. karachi.png)',
                      icon: Icons.image,
                      validator: (v) =>
                          v!.trim().isEmpty ? 'Image name required' : null,
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              size: 11,
                              color: Constants.greyTextColor
                                  .withOpacity(0.5)),
                          const SizedBox(width: 4),
                          Text('File must exist in assets/images/ folder',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Constants.greyTextColor
                                      .withOpacity(0.5))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Description ────────────────────────────
                    _sectionHeader('Description'),
                    _field(
                      controller: descriptionController,
                      hint: 'Write a brief description of this place...',
                      icon: Icons.description,
                      maxLines: 4,
                      validator: (v) => v!.length < 20
                          ? 'At least 20 characters required'
                          : null,
                    ),
                    const SizedBox(height: 28),

                    // ── Submit Button ──────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: _isLoading
                              ? LinearGradient(colors: [
                                  Colors.grey.shade300,
                                  Colors.grey.shade300
                                ])
                              : Constants.redGradient,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: _isLoading
                              ? []
                              : [
                                  BoxShadow(
                                    color: Constants.OrangeColor
                                        .withOpacity(0.35),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: _isLoading ? null : _submit,
                            child: Center(
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_location_alt,
                                            color: Colors.white, size: 20),
                                        SizedBox(width: 8),
                                        Text('Add Destination',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight:
                                                    FontWeight.w700)),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}