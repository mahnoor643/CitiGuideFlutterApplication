import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Admin/addDestination.dart';
import 'package:citi_guide/screens/Admin/fetchData.dart';
import 'package:citi_guide/screens/Cities/cities.dart';
import 'package:citi_guide/screens/Login/login.dart';
import 'package:citi_guide/widgets/adminDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String username;
  final String profile;

  const AdminScreen({
    super.key,
    required this.userId,
    required this.email,
    required this.username,
    required this.profile,
  });

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout?',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Constants.greyTextColor)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const Login()));
            },
            child: Text('Logout',
                style: TextStyle(
                    color: Constants.OrangeColor, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ── Stat Card ────────────────────────────────────────────────────
  Widget _statCard({
    required String label,
    required IconData icon,
    required Color color,
    required Stream<QuerySnapshot> stream,
    required bool isSmallScreen,
  }) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snap) {
          final count = snap.hasData ? snap.data!.docs.length : 0;
          return Container(
            padding: EdgeInsets.symmetric(
              vertical: isSmallScreen ? 14 : 18,
              horizontal: isSmallScreen ? 10 : 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.12),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: color.withOpacity(0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: isSmallScreen ? 16 : 18),
                ),
                SizedBox(height: isSmallScreen ? 8 : 10),
                Text(
                  snap.connectionState == ConnectionState.waiting ? '—' : '$count',
                  style: TextStyle(
                      fontSize: isSmallScreen ? 20 : 24,
                      fontWeight: FontWeight.w800,
                      color: color),
                ),
                SizedBox(height: isSmallScreen ? 1 : 2),
                Text(label,
                    style: TextStyle(
                        fontSize: isSmallScreen ? 9 : 10,
                        color: Constants.greyTextColor,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Quick Action Tile ────────────────────────────────────────────
  Widget _actionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required bool isSmallScreen,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: isSmallScreen ? 40 : 48,
              height: isSmallScreen ? 40 : 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: isSmallScreen ? 18 : 22),
            ),
            SizedBox(width: isSmallScreen ? 10 : 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87)),
                  SizedBox(height: isSmallScreen ? 1 : 2),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: isSmallScreen ? 11 : 12,
                          color: Constants.greyTextColor)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.arrow_forward_ios,
                  size: isSmallScreen ? 10 : 12, color: color),
            ),
          ],
        ),
      ),
    );
  }

  // ── Recent Destination Item ───────────────────────────────────────
  Widget _recentItem(QueryDocumentSnapshot doc, bool isSmallScreen) {
    final data = doc.data() as Map<String, dynamic>;
    final imagePath = data['imagePath'] ?? 'assets/images/PC.png';
    final name = data['locationName'] ?? 'Unknown';
    final city = data['city'] ?? '';
    final category = data['category'] ?? '';

    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 10),
      padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imagePath.startsWith('http')
                ? Image.network(imagePath,
                    width: isSmallScreen ? 45 : 52,
                    height: isSmallScreen ? 45 : 52,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _imgFallback(isSmallScreen))
                : Image.asset(imagePath,
                    width: isSmallScreen ? 45 : 52,
                    height: isSmallScreen ? 45 : 52,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _imgFallback(isSmallScreen)),
          ),
          SizedBox(width: isSmallScreen ? 10 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                SizedBox(height: isSmallScreen ? 2 : 3),
                Row(
                  children: [
                    Icon(Icons.location_on,
                        size: isSmallScreen ? 10 : 11,
                        color: Constants.OrangeColor),
                    SizedBox(width: isSmallScreen ? 2 : 3),
                    Text(city,
                        style: TextStyle(
                            fontSize: isSmallScreen ? 10 : 11,
                            color: Constants.greyTextColor)),
                  ],
                ),
              ],
            ),
          ),
          if (category.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 6 : 8,
                vertical: isSmallScreen ? 3 : 4,
              ),
              decoration: BoxDecoration(
                color: Constants.OrangeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(category,
                  style: TextStyle(
                      fontSize: isSmallScreen ? 8 : 9,
                      color: Constants.OrangeColor,
                      fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }

  Widget _imgFallback(bool isSmallScreen) => Container(
        width: isSmallScreen ? 45 : 52,
        height: isSmallScreen ? 45 : 52,
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10)),
        child: Icon(Icons.image_not_supported,
            color: Colors.grey.shade400,
            size: isSmallScreen ? 18 : 20),
      );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;
    final horizontalPadding = size.width * 0.05;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Constants.redColor,
        elevation: 0,
        toolbarHeight: isSmallScreen ? 48 : 56,
        leading: IconButton(
          icon: Icon(Icons.menu,
              color: Colors.white, size: isSmallScreen ? 22 : 26),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text('Admin Panel',
            style: TextStyle(
                color: Colors.white,
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: _showLogoutDialog,
              child: Icon(Icons.logout,
                  color: Colors.white,
                  size: isSmallScreen ? 18 : 22),
            ),
          ),
        ],
      ),

      // ── Drawer ──────────────────────────────────────────────────
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(gradient: Constants.redGradient),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.grey, width: 2.5),
                        ),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundImage:
                              widget.profile.startsWith('http')
                                  ? NetworkImage(widget.profile)
                                  : AssetImage(widget.profile)
                                      as ImageProvider,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(widget.username,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(widget.email,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 12)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.5)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified,
                                color: Colors.white, size: 12),
                            SizedBox(width: 4),
                            Text('Admin',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  AdminDrawerItem(
                    icon: Icons.dashboard_outlined,
                    title: 'Dashboard',
                    onTap: () => Navigator.pop(context),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  AdminDrawerItem(
                    icon: Icons.add_location_alt_outlined,
                    title: 'Add Destination',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => AddDestinationScreen(
                          userId: widget.userId,
                          email: widget.email,
                          username: widget.username,
                          profile: widget.profile,
                        ),
                      ));
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  AdminDrawerItem(
                    icon: Icons.list_alt_rounded,
                    title: 'All Destinations',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => FetchData(
                          userId: widget.userId,
                          email: widget.email,
                          username: widget.username,
                          profile: widget.profile,
                        ),
                      ));
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  AdminDrawerItem(
                    icon: Icons.location_city,
                    title: 'Cities',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => CitiesScreen(
                          userId: widget.userId,
                          email: widget.email,
                          username: widget.username,
                          profile: widget.profile,
                        ),
                      ));
                    },
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AdminDrawerItem(
                      icon: Icons.logout_rounded,
                      title: 'Logout',
                      onTap: () {
                        Navigator.pop(context);
                        _showLogoutDialog();
                      },
                      isRed: true,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text('Citi Guide v1.0',
                  style: TextStyle(
                      fontSize: 11, color: Colors.grey.shade400)),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // ── Header Banner ─────────────────────────────────────
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  isSmallScreen ? 16 : 22,
                  horizontalPadding,
                  isSmallScreen ? 20 : 30,
                ),
                decoration: BoxDecoration(
                  color: Constants.redColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white, width: 2.5),
                      ),
                      child: CircleAvatar(
                        radius: isSmallScreen ? 20 : 24,
                        backgroundImage:
                            widget.profile.startsWith('http')
                                ? NetworkImage(widget.profile)
                                : AssetImage(widget.profile)
                                    as ImageProvider,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 10 : 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_greeting,
                              style: TextStyle(
                                  color:
                                      Colors.white.withOpacity(0.85),
                                  fontSize: isSmallScreen ? 11 : 12)),
                          Text(widget.username,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmallScreen ? 15 : 17,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 8 : 10,
                        vertical: isSmallScreen ? 4 : 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.verified,
                              color: Colors.white,
                              size: isSmallScreen ? 10 : 12),
                          SizedBox(width: isSmallScreen ? 3 : 4),
                          Text('Admin',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmallScreen ? 10 : 11,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: isSmallScreen ? 14 : 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Stats ──────────────────────────────────────
                    Text('Overview',
                        style: TextStyle(
                            fontSize: isSmallScreen ? 13 : 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87)),
                    SizedBox(height: isSmallScreen ? 10 : 12),
                    Row(
                      children: [
                        _statCard(
                          label: 'Destinations',
                          icon: Icons.place_outlined,
                          color: Constants.OrangeColor,
                          stream: FirebaseFirestore.instance
                              .collection('destinationDetails')
                              .snapshots(),
                          isSmallScreen: isSmallScreen,
                        ),
                        SizedBox(width: isSmallScreen ? 8 : 10),
                        _statCard(
                          label: 'Users',
                          icon: Icons.people_outline,
                          color: const Color(0xFF4C8BF5),
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .snapshots(),
                          isSmallScreen: isSmallScreen,
                        ),
                        SizedBox(width: isSmallScreen ? 8 : 10),
                        _statCard(
                          label: 'Cities',
                          icon: Icons.location_city_outlined,
                          color: const Color(0xFF34C77B),
                          stream: FirebaseFirestore.instance
                              .collection('cities')
                              .snapshots(),
                          isSmallScreen: isSmallScreen,
                        ),
                      ],
                    ),

                    SizedBox(height: isSmallScreen ? 18 : 24),

                    // ── Quick Actions ───────────────────────────────
                    Text('Quick Actions',
                        style: TextStyle(
                            fontSize: isSmallScreen ? 13 : 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87)),
                    SizedBox(height: isSmallScreen ? 10 : 12),
                    _actionTile(
                      icon: Icons.add_location_alt_outlined,
                      title: 'Add New Destination',
                      subtitle: 'Upload a new place to the guide',
                      color: Constants.OrangeColor,
                      isSmallScreen: isSmallScreen,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddDestinationScreen(
                              userId: widget.userId,
                              email: widget.email,
                              username: widget.username,
                              profile: widget.profile,
                            ),
                          )),
                    ),
                    SizedBox(height: isSmallScreen ? 8 : 10),
                    _actionTile(
                      icon: Icons.list_alt_rounded,
                      title: 'Manage Destinations',
                      subtitle: 'View, edit or delete destinations',
                      color: const Color(0xFF4C8BF5),
                      isSmallScreen: isSmallScreen,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FetchData(
                              userId: widget.userId,
                              email: widget.email,
                              username: widget.username,
                              profile: widget.profile,
                            ),
                          )),
                    ),
                    SizedBox(height: isSmallScreen ? 8 : 10),
                    _actionTile(
                      icon: Icons.location_city_outlined,
                      title: 'Manage Cities',
                      subtitle: 'Add or update city details',
                      color: const Color(0xFF34C77B),
                      isSmallScreen: isSmallScreen,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CitiesScreen(
                              userId: widget.userId,
                              email: widget.email,
                              username: widget.username,
                              profile: widget.profile,
                            ),
                          )),
                    ),

                    SizedBox(height: isSmallScreen ? 18 : 24),

                    // ── Recent Destinations ─────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Recent Destinations',
                            style: TextStyle(
                                fontSize: isSmallScreen ? 13 : 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87)),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FetchData(
                                  userId: widget.userId,
                                  email: widget.email,
                                  username: widget.username,
                                  profile: widget.profile,
                                ),
                              )),
                          child: Text('See all',
                              style: TextStyle(
                                  fontSize: isSmallScreen ? 12 : 13,
                                  color: Constants.OrangeColor,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 10 : 12),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('destinationDetails')
                          .limit(5)
                          .snapshots(),
                      builder: (context, snap) {
                        if (snap.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (!snap.hasData || snap.data!.docs.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20),
                              child: Column(
                                children: [
                                  Icon(Icons.location_off,
                                      size: isSmallScreen ? 35 : 40,
                                      color: Colors.grey.shade300),
                                  SizedBox(
                                      height: isSmallScreen ? 6 : 8),
                                  Text('No destinations yet',
                                      style: TextStyle(
                                          color:
                                              Colors.grey.shade400,
                                          fontSize:
                                              isSmallScreen ? 12 : 13)),
                                ],
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: snap.data!.docs
                              .map((doc) =>
                                  _recentItem(doc, isSmallScreen))
                              .toList(),
                        );
                      },
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}