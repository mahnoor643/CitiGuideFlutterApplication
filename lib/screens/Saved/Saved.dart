import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Cities/cities.dart';
import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:citi_guide/screens/Details/details.dart';
import 'package:citi_guide/screens/SearchScreen/searchScreen.dart';
import 'package:citi_guide/screens/profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class SavedScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String username;
  final String profile;

  const SavedScreen({
    super.key,
    required this.userId,
    required this.email,
    required this.username,
    required this.profile,
  });

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  int selectedIndex = 1;

  // ─── Step 1: user doc se savedDestinations array listen karo ─────────────
  Stream<List<Map<String, dynamic>>> _savedStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .snapshots()
        .asyncMap((userDoc) async {
      final data = userDoc.data();
      if (data == null || data['savedDestinations'] == null) return [];

      final List<String> ids =
          List<String>.from(data['savedDestinations'] as List);

      if (ids.isEmpty) return [];

      // Har saved ID ke liye destinationDetails fetch karo
      final futures = ids.map((id) => FirebaseFirestore.instance
          .collection('destinationDetails')
          .doc(id)
          .get());

      final docs = await Future.wait(futures);

      return docs
          .where((doc) => doc.exists)
          .map((doc) => {
                'id': doc.id,
                ...doc.data()!,
              })
          .toList();
    });
  }

  // ─── Unsave — array se remove ─────────────────────────────────────────────
  Future<void> _unsave(String destinationId, String locationName) async {
    if (destinationId.isEmpty) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
        'savedDestinations': FieldValue.arrayRemove([destinationId]),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.star_border_rounded,
                  color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '$locationName removed from saved',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Constants.OrangeColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    } catch (e) {
      debugPrint('Unsave error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Scaffold(
      backgroundColor: const Color(0xfffbf8f3),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Enhanced Top Header ──
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: isSmallScreen ? 12 : 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Dashboard(
                          userId: widget.userId,
                          email: widget.email,
                          username: widget.username,
                          profile: widget.profile,
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xfffbf8f3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 18,
                        color: Constants.OrangeColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saved Places',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 18 : 22,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xff1a1a1a),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 2.5,
                        width: 50,
                        decoration: BoxDecoration(
                          gradient: Constants.orangeGradient,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // ── Icon Badge ──
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 8 : 12,
                      vertical: isSmallScreen ? 6 : 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: Constants.orangeGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.bookmark_rounded,
                      size: isSmallScreen ? 16 : 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // ── Grid Content ──
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _savedStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Constants.OrangeColor,
                        strokeWidth: 2,
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: Constants.orangeGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Constants.OrangeColor.withOpacity(0.2),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.bookmark_border_rounded,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'No Saved Places Yet!',
                            style: TextStyle(
                              color: const Color(0xff1a1a1a),
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              'Start exploring and save your favorite destinations',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xff999999),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final items = snapshot.data!;

                  return Padding(
                    padding: EdgeInsets.all(size.width * 0.04),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isSmallScreen ? 2 : 2,
                        crossAxisSpacing: isSmallScreen ? 10 : 14,
                        mainAxisSpacing: isSmallScreen ? 10 : 14,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final String imagePath =
                            item['imagePath'] ?? 'assets/images/PC.png';
                        final String locationName =
                            item['locationName'] ?? 'Unknown';
                        final String destinationId =
                            item['destinationId'] ?? item['id'] ?? '';

                        return GestureDetector(
                          onTap: () {
                            if (destinationId.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DestinationDetails(
                                    destinationID: destinationId,
                                    url: imagePath,
                                    userId: widget.userId,
                                  ),
                                ),
                              );
                            }
                          },
                          child: _buildSavedCard(
                            imagePath: imagePath,
                            locationName: locationName,
                            destinationId: destinationId,
                            index: index,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ── Bottom Navigation ──
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: size.height * 0.02,
            left: size.width * 0.05,
            right: size.width * 0.05,
            top: 8,
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
                    Navigator.pushReplacement(
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
                    Navigator.pushReplacement(
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
                    Navigator.pushReplacement(
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
                    Navigator.pushReplacement(
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
      ),
    );
  }

  // ── Enhanced Saved Card Widget ──
  Widget _buildSavedCard({
    required String imagePath,
    required String locationName,
    required String destinationId,
    required int index,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Image with proper loading ──
          _buildCardImage(imagePath),

          // ── Dark gradient overlay (bottom) ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Light gradient overlay (top) ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Location Name ──
          Positioned(
            bottom: 12,
            left: 12,
            right: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locationName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // ── Star / Unsave Button ──
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                // Stop propagation to parent GestureDetector
                // This ensures only unsave happens, no navigation
                _unsave(destinationId, locationName);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: Constants.orangeGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Constants.OrangeColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helper: Build card image with proper error handling ──
  Widget _buildCardImage(String imagePath) {
    String cleanPath = imagePath.replaceFirst('file://', '').trim();

    if (cleanPath.startsWith('assets/')) {
      return Image.asset(
        cleanPath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _cardFallback(),
      );
    }

    if (cleanPath.startsWith('http://') || cleanPath.startsWith('https://')) {
      return Image.network(
        cleanPath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/PC.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _cardFallback(),
        ),
      );
    }

    return Image.asset(
      'assets/images/PC.png',
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _cardFallback(),
    );
  }

  // ── Fallback widget ──
  Widget _cardFallback() {
    return Container(
      color: Colors.grey.shade200,
      child: Icon(
        Icons.image_not_supported_rounded,
        color: Colors.grey.shade400,
        size: 40,
      ),
    );
  }
}