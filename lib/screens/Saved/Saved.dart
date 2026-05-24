import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Cities/cities.dart';
import 'package:citi_guide/screens/Dashboard/dashboard.dart';
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

      // Theme matching clean english Snack-bar toggle notification
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
                  '$locationName removed from saved places',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Constants
              .OrangeColor, // Matching theme orange color
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

    return Scaffold(
      backgroundColor: const Color(0xfffbf8f3),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios,
                        size: 20, color: Colors.black),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saved',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Constants.OrangeColor,
                        ),
                      ),
                      Container(
                        height: 2,
                        width: 40,
                        color: Constants.OrangeColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: Color(0xFFEEEEEE)),

            // ── Grid Content ──
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _savedStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                            color: Constants.OrangeColor));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bookmark_border_rounded,
                              size: 60, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          Text(
                            'No saved places yet!',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final items = snapshot.data!;

                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final String imagePath =
                            item['imagePath'] ?? 'assets/images/PC.png';
                        final String locationName =
                            item['locationName'] ?? 'Unknown';

                        // ✅ Fix: ID safe fallbacks ensuring the document map path matches properly
                        final String destinationId =
                            item['destinationId'] ?? item['id'] ?? '';

                        return _buildSavedCard(
                          imagePath: imagePath,
                          locationName: locationName,
                          destinationId: destinationId,
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

      // ── Navigation Bar ──
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

  // ── Saved Card Widget ──
  Widget _buildSavedCard({
    required String imagePath,
    required String locationName,
    required String destinationId,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Image ──
          imagePath.startsWith('http')
              ? Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported,
                        color: Colors.grey),
                  ),
                )
              : Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported,
                        color: Colors.grey),
                  ),
                ),

          // ── Dark gradient bottom ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
            ),
          ),

          // ── Location Name ──
          Positioned(
            bottom: 10,
            left: 10,
            right: 40,
            child: Text(
              locationName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // ── Star / Unsave Toggle Icon Button ──
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => _unsave(destinationId, locationName),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black
                      .withOpacity(0.4), // Thoda visually readable background contrast ke liye
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star_rounded, // Better filled rounded clean star icon
                  color: Colors.amber,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}