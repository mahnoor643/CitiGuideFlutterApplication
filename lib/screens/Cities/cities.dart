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
  // Firestore fields: city (String), img (String — asset path)
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
  Widget _buildCityCard(Map<String, dynamic> city) {
    final String name = city['name'] as String;
    final String imgPath = city['img'] as String;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CityDestinations(cityFetch: name, userId: widget.userId),
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
                top: 10,
                right: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.explore_outlined,
                          color: Colors.white, size: 10),
                      SizedBox(width: 3),
                      Text(
                        'Explore',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
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
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 8,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Constants.OrangeColor.withOpacity(0.9),
                          size: 11,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Pakistan',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 10,
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
  Widget _buildEmptyState() {
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
                size: 40, color: Constants.greyTextColor),
          ),
          const SizedBox(height: 16),
          Text(
            '"$_searchQuery" nahi mila',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Koi aur city try karein',
            style: TextStyle(
              fontSize: 13,
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
    return Scaffold(
      backgroundColor: Constants.greyColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── SliverAppBar — collapsible header ─────────────────────
          SliverAppBar(
            expandedHeight: 150,
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
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
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
                                    width: 26,
                                    height: 26,
                                    color: Colors.white,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.map,
                                            color: Colors.white, size: 26),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Discover Cities',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                              
                              Padding(
                                padding: const EdgeInsets.only(left: 36.0),
                                child: Text(
                                  'Search bestest for Pakistan',
                                  
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.75),
                                    fontSize: 12,
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.3)),
                            ),
                            child: Text(
                              '${_allCities.length} Cities',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
             
              titlePadding: const EdgeInsets.only(left: 56, bottom: 14),
            ),
          ),

          // ── Search bar ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Constants.whiteColor,
                  borderRadius:
                      BorderRadius.circular(Constants.buttonBorderRadius + 4),
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
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A1A1A),
                  ),
                  decoration: InputDecoration(
                    hintText: 'City search karein...',
                    hintStyle: TextStyle(
                      color: Constants.greyTextColor,
                      fontSize: 14,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 14, right: 8),
                      child: Icon(
                        Icons.search_rounded,
                        color: Constants.redColor,
                        size: 22,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 50),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? GestureDetector(
                            onTap: _clearSearch,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Icon(
                                Icons.close_rounded,
                                color: Constants.greyTextColor,
                                size: 20,
                              ),
                            ),
                          )
                        : null,
                    suffixIconConstraints: const BoxConstraints(minWidth: 40),
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
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 2),
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
                        fontSize: 12,
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
            SliverFillRemaining(child: _buildEmptyState())
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _buildCityCard(_filteredCities[i]),
                  childCount: _filteredCities.length,
                ),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.82,
                ),
              ),
            ),
        ],
      ),
    );
  }
}