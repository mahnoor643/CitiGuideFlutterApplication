import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/SelectInterest/SelectInterest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SelectCity extends StatefulWidget {
  final String userId;
  final String username;
  final String email;
  final String profile;

  const SelectCity({
    super.key,
    required this.userId,
    required this.username,
    required this.email,
    required this.profile,
  });

  @override
  State<SelectCity> createState() => _SelectCityState();
}

class _SelectCityState extends State<SelectCity> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCity = '';
  String _searchQuery = '';
  bool _isLoading = false;

  // ✅ Asset imgs hata diye — sirf icon aur name
  final List<Map<String, dynamic>> _cities = [
    {'name': 'Karachi',   'icon': Icons.location_city},
    {'name': 'Lahore',    'icon': Icons.account_balance},
    {'name': 'Islamabad', 'icon': Icons.park},
    {'name': 'Multan',    'icon': Icons.mosque},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredCities {
    if (_searchQuery.isEmpty) return _cities;
    return _cities
        .where((c) =>
            (c['name'] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Future<void> _saveCityAndNavigate() async {
    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({'city': _selectedCity});

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectInterestPage(
            userId:   widget.userId,
            email:    widget.email,
            username: widget.username,
            profile:  widget.profile,
            city:     _selectedCity,
          ),
        ),
      );
    } catch (e) {
      print("City save error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth  = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Scrollable content ──
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),

                    // ── Logo ──
                    Image.asset(
                      'assets/images/citiGuideIcon.png',
                      height: screenHeight * 0.22,
                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // ── Welcome Text ──
                    Text(
                      'Welcome, ${widget.username}!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "First, let's select your city to\nget personalized suggestions.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.55),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // ── Search Bar ──
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) =>
                            setState(() => _searchQuery = val),
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Search or Select City',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.35),
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black.withOpacity(0.35),
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── City List ──
                    _filteredCities.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              'No city found.',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.4),
                                fontSize: 14,
                              ),
                            ),
                          )
                        : Column(
                            children: _filteredCities.map((city) {
                              final bool isSelected =
                                  _selectedCity == city['name'];
                              final IconData cityIcon =
                                  city['icon'] as IconData;

                              return GestureDetector(
                                onTap: () => setState(
                                    () => _selectedCity = city['name']),
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 200),
                                  margin:
                                      const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Constants.OrangeColor
                                            .withOpacity(0.15)
                                        : Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? Constants.OrangeColor
                                          : Colors.transparent,
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withOpacity(0.04),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // ✅ Sirf icon — no asset image
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Constants.OrangeColor
                                                  .withOpacity(0.15)
                                              : Constants.greyColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          cityIcon,
                                          color: isSelected
                                              ? Constants.OrangeColor
                                              : Colors.black
                                                  .withOpacity(0.5),
                                          size: 20,
                                        ),
                                      ),

                                      const SizedBox(width: 14),

                                      // City name
                                      Expanded(
                                        child: Text(
                                          city['name'] as String,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                            color: isSelected
                                                ? Constants.OrangeColor
                                                : Colors.black,
                                          ),
                                        ),
                                      ),

                                      // Check icon
                                      if (isSelected)
                                        Icon(
                                          Icons.check_circle,
                                          color: Constants.OrangeColor,
                                          size: 20,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),

            // ── Next Button ──
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.06,
                0,
                screenWidth * 0.06,
                screenHeight * 0.03,
              ),
              child: Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  gradient: _selectedCity.isEmpty
                      ? LinearGradient(
                          colors: [
                            Constants.OrangeColor.withOpacity(0.4),
                            Constants.OrangeColor.withOpacity(0.4),
                          ],
                        )
                      : Constants.orangeGradient,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton(
                  onPressed: (_selectedCity.isEmpty || _isLoading)
                      ? null
                      : _saveCityAndNavigate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
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
}