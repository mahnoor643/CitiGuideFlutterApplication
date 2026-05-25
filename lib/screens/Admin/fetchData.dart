import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Admin/admin.dart';
import 'package:citi_guide/screens/Login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FetchData extends StatefulWidget {
  final String userId;
  final String email;
  final String username;
  final String profile;

  const FetchData({
    super.key,
    required this.userId,
    required this.email,
    required this.username,
    required this.profile,
  });

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void successMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Constants.OrangeColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _deleteDestination(String docId) async {
    await FirebaseFirestore.instance
        .collection('destinationDetails')
        .doc(docId)
        .delete();
    successMessage('Destination deleted!');
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (route) => false,
    );
  }

  void _showDeleteDialog(String docId, String locationName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Destination?',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        content: Text(
          'Are you sure you want to delete "$locationName"?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: Constants.greyTextColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteDestination(docId);
            },
            child: const Text('Delete',
                style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  List<QueryDocumentSnapshot> _filterDocs(List<QueryDocumentSnapshot> docs) {
    if (_searchQuery.trim().isEmpty) return docs;
    final query = _searchQuery.toLowerCase().trim();
    return docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final locationName = (data['locationName'] ?? '').toString().toLowerCase();
      final city = (data['city'] ?? '').toString().toLowerCase();
      final category = (data['category'] ?? '').toString().toLowerCase();
      return locationName.contains(query) ||
          city.contains(query) ||
          category.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;
    final screenWidth = size.width;
    final screenHeight = size.height;
    final horizontalPadding = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants.redColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Added Destinations',
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
        child: Column(
          children: [
            // ✅ Search Bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: isSmallScreen ? 8 : 10,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 13 : 14,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search by name, city or category...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: isSmallScreen ? 12 : 13,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Constants.OrangeColor,
                      size: isSmallScreen ? 18 : 20,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                            child: Icon(Icons.close,
                                color: Colors.grey.shade400,
                                size: isSmallScreen ? 16 : 18),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 12 : 14,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
            ),

            // ✅ Stream + Filter
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('destinationDetails')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _emptyState(
                      icon: Icons.location_off,
                      message: 'No destinations added yet!',
                      isSmallScreen: isSmallScreen,
                    );
                  }

                  final filteredDocs = _filterDocs(snapshot.data!.docs);

                  if (filteredDocs.isEmpty) {
                    return _emptyState(
                      icon: Icons.search_off,
                      message: 'No results for "$_searchQuery"',
                      isSmallScreen: isSmallScreen,
                    );
                  }

                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: isSmallScreen ? 6 : 8,
                    ),
                    itemCount: filteredDocs.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: isSmallScreen ? 8 : 10),
                    itemBuilder: (context, index) {
                      final doc = filteredDocs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final String docId = doc.id;
                      final String locationName = data['locationName'] ?? 'Unknown';
                      final String city = data['city'] ?? 'Unknown City';
                      final String distance = data['distance'] ?? '';
                      final String category = data['category'] ?? '';
                      final String imagePath =
                          data['imagePath'] ?? 'assets/images/PC.png';

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Image
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(14),
                                bottomLeft: Radius.circular(14),
                              ),
                              child: imagePath.startsWith('http')
                                  ? Image.network(
                                      imagePath,
                                      width: screenWidth * (isSmallScreen ? 0.24 : 0.28),
                                      height:
                                          screenWidth * (isSmallScreen ? 0.20 : 0.24),
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _imageFallback(screenWidth, isSmallScreen),
                                    )
                                  : Image.asset(
                                      imagePath,
                                      width: screenWidth * (isSmallScreen ? 0.24 : 0.28),
                                      height:
                                          screenWidth * (isSmallScreen ? 0.20 : 0.24),
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _imageFallback(screenWidth, isSmallScreen),
                                    ),
                            ),

                            // Details
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 10 : 12,
                                  vertical: isSmallScreen ? 8 : 10,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      locationName,
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: isSmallScreen ? 3 : 4),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on,
                                            size: isSmallScreen ? 11 : 12,
                                            color: Constants.OrangeColor),
                                        SizedBox(
                                            width: isSmallScreen ? 2 : 3),
                                        Flexible(
                                          child: Text(
                                            city,
                                            style: TextStyle(
                                              fontSize:
                                                  isSmallScreen ? 11 : 12,
                                              color:
                                                  Constants.greyTextColor,
                                            ),
                                            overflow:
                                                TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (distance.isNotEmpty) ...[
                                          SizedBox(
                                              width:
                                                  isSmallScreen ? 6 : 8),
                                          Icon(Icons.directions_walk,
                                              size: isSmallScreen ? 11 : 12,
                                              color: Constants
                                                  .greyTextColor),
                                          SizedBox(
                                              width: isSmallScreen ? 2 : 3),
                                          Flexible(
                                            child: Text(
                                              distance,
                                              style: TextStyle(
                                                fontSize:
                                                    isSmallScreen ? 11 : 12,
                                                color: Constants
                                                    .greyTextColor,
                                              ),
                                              overflow:
                                                  TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    if (category.isNotEmpty) ...[
                                      SizedBox(
                                          height: isSmallScreen ? 5 : 6),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isSmallScreen ? 6 : 8,
                                          vertical: isSmallScreen ? 2 : 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Constants.OrangeColor
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          category,
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 9 : 10,
                                            color: Constants.OrangeColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),

                            // Delete button
                            Padding(
                              padding: EdgeInsets.only(
                                  right: isSmallScreen ? 8 : 10),
                              child: GestureDetector(
                                onTap: () =>
                                    _showDeleteDialog(docId, locationName),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.08),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.delete_outline,
                                      color: Colors.red,
                                      size: isSmallScreen ? 16 : 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // ✅ Add More Button
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                0,
                horizontalPadding,
                screenHeight * 0.02,
              ),
              child: SizedBox(
                width: double.infinity,
                height: isSmallScreen ? 46 : 52,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: Constants.redGradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Constants.OrangeColor.withOpacity(0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminScreen(
                              userId: widget.userId,
                              email: widget.email,
                              username: widget.username,
                              profile: widget.profile,
                            ),
                          ),
                        );
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_location_alt,
                                color: Colors.white,
                                size: isSmallScreen ? 18 : 20),
                            const SizedBox(width: 8),
                            Text(
                              'Add More Destination',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmallScreen ? 13 : 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
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

  // ✅ Empty state widget
  Widget _emptyState({
    required IconData icon,
    required String message,
    required bool isSmallScreen,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              size: isSmallScreen ? 50 : 60,
              color: Colors.grey.shade300),
          SizedBox(height: isSmallScreen ? 10 : 12),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: isSmallScreen ? 13 : 15,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ✅ Image fallback
  Widget _imageFallback(double screenWidth, bool isSmallScreen) {
    return Container(
      width: screenWidth * (isSmallScreen ? 0.24 : 0.28),
      height: screenWidth * (isSmallScreen ? 0.20 : 0.24),
      color: Colors.grey.shade100,
      child: Icon(Icons.image_not_supported,
          color: Colors.grey.shade400, size: isSmallScreen ? 24 : 28),
    );
  }
}