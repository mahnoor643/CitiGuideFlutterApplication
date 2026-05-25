import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Details/details.dart';
import 'package:citi_guide/widgets/card.dart';
import 'package:citi_guide/widgets/transparentButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CityDestinations extends StatefulWidget {
  final String userId;
  final String cityFetch;

  const CityDestinations({
    super.key,
    required this.cityFetch,
    required this.userId,
  });

  @override
  State<CityDestinations> createState() => _CityDestinationsState();
}

class _CityDestinationsState extends State<CityDestinations> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;
    final horizontalPadding = size.width * 0.05;

    return Scaffold(
      backgroundColor: Constants.whiteColor,
      appBar: AppBar(
        backgroundColor: Constants.redColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.cityFetch,
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        toolbarHeight: isSmallScreen ? 48 : 56,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              isSmallScreen ? 16 : 24,
              horizontalPadding,
              isSmallScreen ? 16 : 24,
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('destinationDetails')
                  .where('city', isEqualTo: widget.cityFetch)
                  .snapshots(),
              builder: (context, snapshot) {
                // Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: CircularProgressIndicator(
                        color: Constants.redColor,
                        strokeWidth: 2.5,
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }

                // Empty state
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return SizedBox(
                    height: size.height * 0.6,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_off_outlined,
                            size: isSmallScreen ? 50 : 60,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(height: isSmallScreen ? 12 : 16),
                          Text(
                            'No destinations found',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 6 : 8),
                          Text(
                            'for ${widget.cityFetch}',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                var destinationData = snapshot.data!.docs;

                return Column(
                  children: List.generate(
                    destinationData.length,
                    (index) {
                      var doc = destinationData[index];
                      var data = doc.data() as Map<String, dynamic>;

                      // ✅ Debug print
                      debugPrint('Doc $index data: $data');

                      String imagePath =
                          (data['imagePath'] ?? 'assets/images/PC.png')
                              .toString();
                      String dID = doc.id;
                      String locationName =
                          (data['locationName'] ?? 'Unknown').toString();
                      String city = (data['city'] ?? '').toString();
                      String distance = (data['distance'] ?? '').toString();

                      debugPrint('Image path: $imagePath');

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: isSmallScreen ? 12 : 16,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DestinationDetails(
                                  destinationID: dID,
                                  url: imagePath,
                                  userId: widget.userId,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: size.width * (isSmallScreen ? 0.55 : 0.60),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  // ── Image ──────────────────────────
                                  _buildImage(imagePath),

                                  // ── Top Info (City + Distance) ──────
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(
                                        isSmallScreen ? 10 : 12,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.5),
                                            Colors.black.withOpacity(0.1),
                                          ],
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          // City badge
                                          if (city.isNotEmpty)
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    isSmallScreen ? 8 : 10,
                                                vertical: isSmallScreen ? 4 : 5,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.4),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.3),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize:
                                                    MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .location_on_outlined,
                                                    color: Colors.white,
                                                    size: isSmallScreen
                                                        ? 10
                                                        : 11,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        isSmallScreen ? 3 : 4,
                                                  ),
                                                  Text(
                                                    city,
                                                    style: TextStyle(
                                                      fontSize: isSmallScreen
                                                          ? 11
                                                          : 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          const Spacer(),
                                          // Distance badge
                                          if (distance.isNotEmpty)
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    isSmallScreen ? 8 : 10,
                                                vertical: isSmallScreen ? 4 : 5,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Constants.redColor
                                                    .withOpacity(0.9),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Constants.redColor
                                                        .withOpacity(0.5),
                                                    blurRadius: 6,
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisSize:
                                                    MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.directions_walk,
                                                    color: Colors.white,
                                                    size: isSmallScreen
                                                        ? 10
                                                        : 11,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        isSmallScreen ? 3 : 4,
                                                  ),
                                                  Text(
                                                    distance,
                                                    style: TextStyle(
                                                      fontSize: isSmallScreen
                                                          ? 11
                                                          : 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // ── Bottom Info (Location Name) ────
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(
                                        isSmallScreen ? 10 : 12,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.85),
                                            Colors.black.withOpacity(0.3),
                                          ],
                                        ),
                                      ),
                                      child: Text(
                                        locationName,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              isSmallScreen ? 15 : 17,
                                          fontWeight: FontWeight.w800,
                                          shadows: const [
                                            Shadow(
                                              color: Colors.black54,
                                              blurRadius: 4,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ── Build Image with proper error handling ────────────────────────────
  Widget _buildImage(String imagePath) {
    // Remove 'file://' if present
    String cleanPath = imagePath.replaceFirst('file://', '');

    debugPrint('Trying to load image: $cleanPath');

    // Check if it's a network image
    if (cleanPath.startsWith('http://') || cleanPath.startsWith('https://')) {
      return Image.network(
        cleanPath,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey.shade100,
            child: Center(
              child: CircularProgressIndicator(
                color: Constants.redColor,
                strokeWidth: 2,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Network image error: $error');
          return _imageFallback('Network error');
        },
      );
    }

    // Try asset image
    if (cleanPath.startsWith('assets/')) {
      return Image.asset(
        cleanPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Asset image error for $cleanPath: $error');
          return _imageFallback('Asset not found');
        },
      );
    }

    // Try with assets/ prefix
    return Image.asset(
      'assets/images/$cleanPath',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Asset image error for assets/images/$cleanPath: $error');
        return _imageFallback('File not found');
      },
    );
  }

  // ── Image Fallback ──────────────────────────────────────────────────────
  Widget _imageFallback(String reason) {
    return Container(
      decoration: BoxDecoration(gradient: Constants.redGradient),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: 48,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 8),
            Text(
              reason,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}