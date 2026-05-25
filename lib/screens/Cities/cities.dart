import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/CityDestinations/cityDestinations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CitiesScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String username;
  final String profile;

  const CitiesScreen({
    super.key,
    required this.userId,
    required this.email,
    required this.username,
    required this.profile,
  });

  @override
  State<CitiesScreen> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  List<Map<String, dynamic>> _allCities = [];
  List<Map<String, dynamic>> _filteredCities = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchCities();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  // ─── Firestore fetch ──────────────────────────────────────────────────────
  Future<void> _fetchCities() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('cities').get();

      final cities = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': (data['city'] ?? '').toString(),
          'img': (data['img'] ?? '').toString(),
        };
      }).toList();

      // A-Z sort
      cities.sort((a, b) =>
          (a['name'] as String).compareTo(b['name'] as String));

      if (mounted) {
        setState(() {
          _allCities = cities;
          _filteredCities = cities;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Cities fetch error: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ─── Search — city name se filter ─────────────────────────────────────────
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

  void _clearSearch() {
    _searchController.clear();
    _searchFocus.unfocus();
  }

  // ─── City Card ────────────────────────────────────────────────────────────
  Widget _buildCityCard(Map<String, dynamic> city, bool isSmallScreen) {
    final String name = city['name'] as String;
    final String imgPath = city['img'] as String;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              CityDestinations(cityFetch: name, userId: widget.userId),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Asset image ────────────────────────────────────────
              imgPath.isNotEmpty
                  ? Image.asset(
                      imgPath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _fallback(name),
                    )
                  : _fallback(name),

              // ── Bottom gradient overlay ────────────────────────────
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.15),
                        Colors.black.withOpacity(0.78),
                      ],
                      stops: const [0.35, 0.6, 1.0],
                    ),
                  ),
                ),
              ),

              // ── Top-right: subtle red tint badge ──────────────────
              Positioned(
                top: isSmallScreen ? 8 : 10,
                right: isSmallScreen ? 8 : 10,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 6 : 8,
                    vertical: isSmallScreen ? 3 : 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: Constants.redGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Constants.redColor.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.explore_outlined,
                          color: Colors.white,
                          size: isSmallScreen ? 9 : 10),
                      SizedBox(width: isSmallScreen ? 2 : 3),
                      Text(
                        'Explore',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 8 : 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Bottom: city info ──────────────────────────────────
              Positioned(
                left: isSmallScreen ? 10 : 12,
                right: isSmallScreen ? 10 : 12,
                bottom: isSmallScreen ? 10 : 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 14 : 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                        shadows: const [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 8,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isSmallScreen ? 3 : 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Constants.OrangeColor.withOpacity(0.9),
                          size: isSmallScreen ? 10 : 11,
                        ),
                        SizedBox(width: isSmallScreen ? 2 : 3),
                        Text(
                          'Pakistan',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: isSmallScreen ? 9 : 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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

  // ─── Fallback widget ──────────────────────────────────────────────────────
  Widget _fallback(String name) {
    return Container(
      decoration: BoxDecoration(gradient: Constants.redGradient),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 52,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  // ─── Empty search state ───────────────────────────────────────────────────
  Widget _buildEmptyState(bool isSmallScreen) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Constants.greyColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search_off_rounded,
                size: isSmallScreen ? 35 : 40,
                color: Constants.greyTextColor),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Text(
            '"$_searchQuery" nahi mila',
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: isSmallScreen ? 4 : 6),
          Text(
            'Koi aur city try karein',
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 13,
              color: Constants.greyTextColor,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Scaffold(
      backgroundColor: Constants.greyColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── SliverAppBar — collapsible header ─────────────────────
            SliverAppBar(
              expandedHeight: isSmallScreen ? 120 : 150,
              pinned: true,
              elevation: 0,
              backgroundColor: Constants.redColor,
              iconTheme: const IconThemeData(color: Colors.white),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Container(
                  decoration: BoxDecoration(
                    gradient: Constants.redGradient,
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      isSmallScreen ? 12 : 16,
                      20,
                      isSmallScreen ? 12 : 16,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    Constants.appLogo,
                                    width: isSmallScreen ? 22 : 26,
                                    height: isSmallScreen ? 22 : 26,
                                    color: Colors.white,
                                    errorBuilder: (_, __, ___) => Icon(
                                      Icons.map,
                                      color: Colors.white,
                                      size: isSmallScreen ? 22 : 26,
                                    ),
                                  ),
                                  SizedBox(width: isSmallScreen ? 6 : 8),
                                  Text(
                                    'Discover Cities',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isSmallScreen ? 18 : 22,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: isSmallScreen ? 30 : 36,
                                ),
                                child: Text(
                                  'Search bestest for Pakistan',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.75),
                                    fontSize: isSmallScreen ? 11 : 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                            ],
                          ),
                        ),
                        // City count badge
                        if (_allCities.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 10 : 12,
                              vertical: isSmallScreen ? 5 : 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              '${_allCities.length} Cities',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmallScreen ? 10 : 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                titlePadding: EdgeInsets.only(
                  left: isSmallScreen ? 48 : 56,
                  bottom: isSmallScreen ? 10 : 14,
                ),
              ),
            ),

            // ── Search bar ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  isSmallScreen ? 12 : 16,
                  isSmallScreen ? 12 : 16,
                  isSmallScreen ? 12 : 16,
                  0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Constants.whiteColor,
                    borderRadius: BorderRadius.circular(
                      Constants.buttonBorderRadius + 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocus,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 13 : 14,
                      color: const Color(0xFF1A1A1A),
                    ),
                    decoration: InputDecoration(
                      hintText: 'City search karein...',
                      hintStyle: TextStyle(
                        color: Constants.greyTextColor,
                        fontSize: isSmallScreen ? 13 : 14,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 14, right: 8),
                        child: Icon(
                          Icons.search_rounded,
                          color: Constants.redColor,
                          size: isSmallScreen ? 20 : 22,
                        ),
                      ),
                      prefixIconConstraints:
                          const BoxConstraints(minWidth: 50),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? GestureDetector(
                              onTap: _clearSearch,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Icon(
                                  Icons.close_rounded,
                                  color: Constants.greyTextColor,
                                  size: isSmallScreen ? 18 : 20,
                                ),
                              ),
                            )
                          : null,
                      suffixIconConstraints:
                          const BoxConstraints(minWidth: 40),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 4,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Result count ───────────────────────────────────────────
            if (!_isLoading)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    isSmallScreen ? 16 : 20,
                    isSmallScreen ? 10 : 14,
                    isSmallScreen ? 16 : 20,
                    2,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 3,
                        height: 14,
                        decoration: BoxDecoration(
                          gradient: Constants.redGradient,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _searchQuery.isEmpty
                            ? 'All cities — ${_allCities.length} available'
                            : '${_filteredCities.length} results found',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 11 : 12,
                          color: Constants.greyTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // ── Grid / Loading / Empty ─────────────────────────────────
            if (_isLoading)
              SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Constants.redColor,
                    strokeWidth: 2.5,
                  ),
                ),
              )
            else if (_filteredCities.isEmpty)
              SliverFillRemaining(
                child: _buildEmptyState(isSmallScreen),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  isSmallScreen ? 12 : 16,
                  isSmallScreen ? 6 : 8,
                  isSmallScreen ? 12 : 16,
                  isSmallScreen ? 20 : 30,
                ),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => _buildCityCard(_filteredCities[i], isSmallScreen),
                    childCount: _filteredCities.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: isSmallScreen ? 10 : 14,
                    mainAxisSpacing: isSmallScreen ? 10 : 14,
                    childAspectRatio: isSmallScreen ? 0.75 : 0.82,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}