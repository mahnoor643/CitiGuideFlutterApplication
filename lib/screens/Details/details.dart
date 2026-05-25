import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/map/map_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DestinationDetails extends StatefulWidget {
  final String destinationID;
  final String url;
  final String userId; // ✅ save/unsave ke liye
  const DestinationDetails({
    super.key,
    required this.destinationID,
    required this.url,
    required this.userId,
  });

  @override
  State<DestinationDetails> createState() => _DestinationDetailsState();
}

class _DestinationDetailsState extends State<DestinationDetails> {
  bool _isSaved = false;
  bool _saveLoading = true;

  @override
  void initState() {
    super.initState();
    _checkSaved();
  }

  // ─── Check if already saved ───────────────────────────────────────────────
  Future<void> _checkSaved() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      final data = doc.data();
      if (data != null && data['savedDestinations'] != null) {
        final List list = data['savedDestinations'] as List;
        if (mounted) {
          setState(() {
            _isSaved = list.contains(widget.destinationID);
            _saveLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _saveLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _saveLoading = false);
    }
  }

  // ─── Toggle save ──────────────────────────────────────────────────────────
  Future<void> _toggleSave(String locationName) async {
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(widget.userId);

    setState(() => _isSaved = !_isSaved);

    try {
      if (_isSaved) {
        await userRef.update({
          'savedDestinations': FieldValue.arrayUnion([widget.destinationID]),
        });
        _showSnack('$locationName saved!', saved: true);
      } else {
        await userRef.update({
          'savedDestinations': FieldValue.arrayRemove([widget.destinationID]),
        });
        _showSnack('$locationName removed', saved: false);
      }
    } catch (e) {
      // revert on error
      setState(() => _isSaved = !_isSaved);
      debugPrint('Save error: $e');
    }
  }

  void _showSnack(String msg, {required bool saved}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              saved ? Icons.bookmark_added : Icons.bookmark_remove,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(msg,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
        backgroundColor: saved ? Constants.OrangeColor : Colors.grey.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ─── Info tile — distance / timings / contact ─────────────────────────────
  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Constants.greyColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Constants.OrangeColor, size: 16),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Constants.greyTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Constants.greyColor,
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('destinationDetails')
            .doc(widget.destinationID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: Constants.redColor,
                strokeWidth: 2.5,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final doc = snapshot.data!;
          final data = doc.data()!;

          // Parse lat/lng
          final String locationString = data['location'] ?? '0,0';
final List<String> latLngList = locationString.split(',');
final double latitude = double.tryParse(latLngList[0].trim()) ?? 0;
final double longitude = double.tryParse(
    latLngList.length > 1 ? latLngList[1].trim() : '0') ?? 0;

// ADD THESE DEBUG PRINTS:
debugPrint('📍 Raw location: "$locationString"');
debugPrint('📍 Split: lat="${latLngList[0]}", lng="${latLngList.length > 1 ? latLngList[1] : 'MISSING'}"');
debugPrint('📍 After trim: lat=$latitude, lng=$longitude');

// Debug:
          debugPrint('🗺️ Location: lat=$latitude, lng=$longitude');

          final String locationName = data['locationName'] ?? '';
          final String city = data['city'] ?? '';
          final String distance = data['distance'] ?? '';
          final String timings = data['timings'] ?? '';
          final String contact = data['contact'] ?? distance;
          final String description = data['description'] ?? '';

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── SliverAppBar with image ──────────────────────────
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                elevation: 0,
                backgroundColor: Constants.OrangeColor,
                iconTheme: const IconThemeData(color: Colors.white),
                // ✅ Save button top-right
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: _saveLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : GestureDetector(
                            onTap: () => _toggleSave(locationName),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: _isSaved
                                    ? Constants.OrangeColor
                                    : Colors.black.withOpacity(0.3),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _isSaved
                                      ? Constants.OrangeColor
                                      : Colors.white.withOpacity(0.4),
                                  width: 1.5,
                                ),
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  _isSaved
                                      ? Icons.bookmark
                                      : Icons.bookmark_border_rounded,
                                  key: ValueKey(_isSaved),
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image
                      Image.asset(
                        widget.url,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          decoration:
                              BoxDecoration(gradient: Constants.redGradient),
                        ),
                      ),
                      // Gradient overlay
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.15),
                              Colors.black.withOpacity(0.72),
                            ],
                            stops: const [0.4, 0.65, 1.0],
                          ),
                        ),
                      ),
                      // Bottom info on image
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // City + distance badges
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.35),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.location_on_outlined,
                                          color: Colors.white, size: 11),
                                      const SizedBox(width: 3),
                                      Text(
                                        city,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Text(
                            //   locationName,
                            //   style: const TextStyle(
                            //     color: Colors.white,
                            //     fontSize: 22,
                            //     fontWeight: FontWeight.w900,
                            //     letterSpacing: 0.2,
                            //     shadows: [
                            //       Shadow(
                            //           color: Colors.black54,
                            //           blurRadius: 8),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Pinned title
                  // r
                  titlePadding: const EdgeInsets.only(left: 56, bottom: 14),
                ),
              ),

              // ── Content ──────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Location name + save status ───────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              locationName,
                              style: TextStyle(
                                color: Constants.OrangeColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          if (_isSaved)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Constants.OrangeColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Constants.OrangeColor.withOpacity(0.4),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.bookmark,
                                      size: 12, color: Constants.OrangeColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Saved',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Constants.OrangeColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // ── Description ───────────────────────────────
                      Text(
                        description,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── Info tiles row ────────────────────────────
                      Row(
                        children: [
                          _infoTile(
                            icon: Icons.route_sharp,
                            label: 'Distance',
                            value: distance,
                          ),
                          const SizedBox(width: 10),
                          _infoTile(
                            icon: Icons.access_time_sharp,
                            label: 'Opening Hours',
                            value: timings,
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // ── Contact tile full width ───────────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: Constants.greyColor, width: 1.2),
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
                            Icon(Icons.phone_in_talk_outlined,
                                color: Constants.OrangeColor, size: 16),
                            const SizedBox(width: 8),
                            const Text(
                              'Contact Number',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              contact,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Constants.greyTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── Map preview ───────────────────────────────
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MapPage(
                              longitudeDetected: longitude,
                              latitudeDetected: latitude,
                            ),
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Constants.whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  'assets/images/map.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Constants.greyColor,
                                    child: Icon(Icons.map_outlined,
                                        color: Constants.greyTextColor,
                                        size: 48),
                                  ),
                                ),
                                // Tap overlay hint
                                Positioned(
                                  right: 12,
                                  bottom: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      gradient: Constants.redGradient,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Constants.redColor
                                              .withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.map_outlined,
                                            color: Colors.white, size: 13),
                                        SizedBox(width: 5),
                                        Text(
                                          'Open Map',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── Let's Go button ───────────────────────────
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MapPage(
                              longitudeDetected: longitude,
                              latitudeDetected: latitude,
                            ),
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 54,
                          decoration: BoxDecoration(
                            gradient: Constants.orangeGradient,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Constants.redColor.withOpacity(0.4),
                                blurRadius: 14,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Let's Go",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_outward_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
