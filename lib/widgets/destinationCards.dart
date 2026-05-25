import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Cities/cities.dart';
import 'package:citi_guide/widgets/card.dart';
import 'package:citi_guide/widgets/transparentButton.dart';
import 'package:flutter/material.dart';

class DestinationCards extends StatelessWidget {
  final String imgPath;
  final String location;
  final String city;
  final String distance;

  const DestinationCards({
    super.key,
    required this.imgPath,
    required this.location,
    required this.city,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    // ✅ Responsive card dimensions
    final cardWidth = isSmallScreen ? 140.0 : 170.0;
    final cardHeight = isSmallScreen ? 140.0 : 170.0;
    final opacityHeight = isSmallScreen ? 40.0 : 50.0;
    final opacityMargin = isSmallScreen ? 100.0 : 120.0;

    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: EdgeInsets.only(right: isSmallScreen ? 8 : 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ✅ Background Image
            _buildBackgroundImage(),

            // ✅ Gradient Overlay (top)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: opacityHeight,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // ✅ Location Name (Top)
            Positioned(
              top: opacityHeight * 0.3,
              left: 10,
              right: 10,
              child: Text(
                location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Constants.greyColor,
                  fontSize: isSmallScreen ? 10 : 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // ✅ Gradient Overlay (bottom)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: opacityHeight,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // ✅ City & Distance Info (Bottom)
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Row(
                children: [
                  // City Info
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: Constants.greyColor,
                          size: isSmallScreen ? 8 : 10,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            city,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 8 : 10,
                              color: Constants.greyColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 4),

                  // Distance Info
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 4 : 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      distance,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 8 : 10,
                        color: Constants.greyColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Helper: Build background image with proper error handling
  Widget _buildBackgroundImage() {
    // Clean up path
    String cleanPath = imgPath.replaceFirst('file://', '').trim();

    // Asset image
    if (cleanPath.startsWith('assets/')) {
      return Image.asset(
        cleanPath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFallback(),
      );
    }

    // Network image
    if (cleanPath.startsWith('http://') || cleanPath.startsWith('https://')) {
      return Image.network(
        cleanPath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/PC.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallback(),
        ),
      );
    }

    // Default fallback
    return Image.asset(
      'assets/images/PC.png',
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildFallback(),
    );
  }

  // ✅ Fallback widget
  Widget _buildFallback() {
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