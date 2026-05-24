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

class _SelectCityState extends State<SelectCity>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  // ─── State ────────────────────────────────────────────────────────────────
  List<Map<String, dynamic>> _allCities = [];
  List<Map<String, dynamic>> _filteredCities = [];
  String _selectedCity = '';
  String _selectedImg = '';
  String _searchQuery = '';
  bool _isLoadingCities = true;
  bool _isSaving = false;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fetchCities();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // ─── Firestore: cities collection fetch ───────────────────────────────────
  Future<void> _fetchCities() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('cities').get();

      final cities = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'name': (data['city'] ?? '').toString(),
          'img': (data['img'] ?? '').toString(),
        };
      }).toList();

      cities.sort((a, b) =>
          (a['name'] as String).compareTo(b['name'] as String));

      if (mounted) {
        setState(() {
          _allCities = cities;
          _filteredCities = cities;
          _isLoadingCities = false;
        });
        _fadeController.forward();
      }
    } catch (e) {
      debugPrint('City fetch error: $e');
      if (mounted) setState(() => _isLoadingCities = false);
    }
  }

  // ─── Search filter ────────────────────────────────────────────────────────
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _searchQuery = query;
      _filteredCities = query.isEmpty
          ? _allCities
          : _allCities
              .where((c) =>
                  (c['name'] as String).toLowerCase().contains(query))
              .toList();
    });
  }

  // ─── Save city to Firestore + navigate ───────────────────────────────────
  Future<void> _saveCityAndNavigate() async {
    if (_selectedCity.isEmpty) return;
    setState(() => _isSaving = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({'city': _selectedCity});

      if (!mounted) return;

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              SelectInterestPage(
            userId: widget.userId,
            email: widget.email,
            username: widget.username,
            profile: widget.profile,
            city: _selectedCity,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    } catch (e) {
      debugPrint('City save error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('City save nahi hui, dobara try karein'),
            backgroundColor: Constants.redColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ─── City tile with icon design ───────────────────────────────────────────
  Widget _buildCityTile(Map<String, dynamic> city, int index) {
    final String name = city['name'] as String;
    final bool isSelected = _selectedCity == name;

    return GestureDetector(
      onTap: () => setState(() {
        _selectedCity = name;
        _selectedImg = '';
      }),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(milliseconds: 280 + (index * 25)),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, (1 - value) * 15),
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? Constants.OrangeColor.withOpacity(0.08)
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? Constants.OrangeColor
                  : const Color(0xffe5e5e5),
              width: isSelected ? 2 : 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? Constants.OrangeColor.withOpacity(0.12)
                    : Colors.black.withOpacity(0.04),
                blurRadius: isSelected ? 10 : 6,
                offset: Offset(0, isSelected ? 3 : 1),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => setState(() {
                _selectedCity = name;
                _selectedImg = '';
              }),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                child: Row(
                  children: [
                    // ── City icon ──────────────────────────────────────
                    _buildCityIcon(name, isSelected),

                    const SizedBox(width: 14),

                    // ── City name ───────────────────────────────────────
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: isSelected
                              ? Constants.OrangeColor
                              : const Color(0xff2a2a2a),
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),

                    // ── Check icon ──────────────────────────────────────
                    if (isSelected)
                      AnimatedScale(
                        duration: const Duration(milliseconds: 200),
                        scale: isSelected ? 1.0 : 0.0,
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: Constants.OrangeColor,
                          size: 22,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── City icon builder ─────────────────────────────────────────────────────
  Widget _buildCityIcon(String cityName, bool isSelected) {
    IconData icon;
    Color iconColor = isSelected ? Constants.OrangeColor : const Color(0xff888888);

    // Select icon based on city name
    switch (cityName.toLowerCase()) {
      case 'karachi':
        icon = Icons.location_city_rounded;
        break;
      case 'lahore':
        icon = Icons.location_city_rounded;
        break;
      case 'islamabad':
        icon = Icons.domain_rounded;
        break;
      case 'multan':
        icon = Icons.location_city_rounded;
        break;
      case 'hyderabad':
        icon = Icons.location_city_rounded;
        break;
      case 'peshawar':
        icon = Icons.location_city_rounded;
        break;
      case 'quetta':
        icon = Icons.location_city_rounded;
        break;
      case 'faisalabad':
        icon = Icons.location_city_rounded;
        break;
      case 'rawalpindi':
        icon = Icons.location_city_rounded;
        break;
      case 'gujranwala':
        icon = Icons.location_city_rounded;
        break;
      default:
        icon = Icons.location_on_rounded;
    }

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: isSelected
            ? Constants.OrangeColor.withOpacity(0.1)
            : const Color(0xfff5f5f5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected
              ? Constants.OrangeColor.withOpacity(0.3)
              : const Color(0xffe8e8e8),
          width: 1,
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          color: iconColor,
          size: 22,
        ),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Constants.pageBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Clean Header with Logo ────────────────────────────────────
            _buildCleanHeader(size),

            // ── Scrollable content ────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Search bar ─────────────────────────────────────
                    _buildSearchBar(size),

                    const SizedBox(height: 18),

                    // ── City list ──────────────────────────────────────
                    _buildCityList(),

                    SizedBox(height: size.height * 0.02),
                  ],
                ),
              ),
            ),

            // ── Next Button ───────────────────────────────────────────
            _buildNextButton(size),
          ],
        ),
      ),
    );
  }

  // ─── Clean Header builder (no appbar, just logo & text) ──────────────────
  Widget _buildCleanHeader(Size size) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        size.width * 0.05,
        16,
        size.width * 0.05,
        8,
      ),
      child: Column(
        children: [
          // ── Logo (MainLogo.png) with shadow ────────────────────────
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.11),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Image.asset(
              Constants.mainLogo,
              height: 190,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.map_outlined,
                size: 190,
                color: Constants.OrangeColor,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Welcome text ───────────────────────────────────────────
          Text(
            'Welcome, ${widget.username}!',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xff1a1a1a),
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 6),

          // ── Subtitle ────────────────────────────────────────────────
          Text(
            'First, let\'s select your city to get personalized suggestions',
            style: TextStyle(
              fontSize: 13.5,
              color: const Color(0xff888888),
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ─── Search bar builder ────────────────────────────────────────────────────
  Widget _buildSearchBar(Size size) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xffe0e0e0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xff1a1a1a),
        ),
        decoration: InputDecoration(
          hintText: 'Search or Select City',
          hintStyle: TextStyle(
            color: const Color(0xffaaaaaa),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: Icon(
              Icons.search_rounded,
              color: const Color(0xffaaaaaa),
              size: 20,
            ),
          ),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 0),
          suffixIcon: _searchQuery.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    FocusScope.of(context).unfocus();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.close_rounded,
                      color: const Color(0xffaaaaaa),
                      size: 18,
                    ),
                  ),
                )
              : null,
          suffixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 0),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 0,
          ),
        ),
        cursorColor: Constants.OrangeColor,
        cursorRadius: const Radius.circular(2),
      ),
    );
  }

  // ─── City list builder ─────────────────────────────────────────────────────
  Widget _buildCityList() {
    if (_isLoadingCities) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              color: Constants.OrangeColor,
              strokeWidth: 2.8,
            ),
          ),
        ),
      );
    }

    if (_filteredCities.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Icon(
                Icons.location_off_rounded,
                size: 42,
                color: const Color(0xffe0e0e0),
              ),
              const SizedBox(height: 10),
              Text(
                '"$_searchQuery" nahi mila',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff999999),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: List.generate(
        _filteredCities.length,
        (index) => _buildCityTile(_filteredCities[index], index),
      ),
    );
  }

  // ─── Next button builder ───────────────────────────────────────────────────
  Widget _buildNextButton(Size size) {
    final isEnabled = _selectedCity.isNotEmpty && !_isSaving;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        size.width * 0.05,
        12,
        size.width * 0.05,
        size.height * 0.03,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          gradient: isEnabled
              ? Constants.orangeGradient
              : LinearGradient(
                  colors: [
                    const Color(0xffdddddd),
                    const Color(0xffd0d0d0),
                  ],
                ),
          borderRadius: BorderRadius.circular(26),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: Constants.OrangeColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(26),
            onTap: isEnabled ? _saveCityAndNavigate : null,
            child: Center(
              child: _isSaving
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      'Next',
                      style: TextStyle(
                        color: isEnabled
                            ? Colors.white
                            : const Color(0xff999999),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}