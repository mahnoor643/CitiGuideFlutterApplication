import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Cities/cities.dart';
import 'package:citi_guide/screens/Details/details.dart';
import 'package:citi_guide/screens/Saved/Saved.dart';
import 'package:citi_guide/screens/SearchScreen/searchScreen.dart';
import 'package:citi_guide/screens/profile/profile.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:citi_guide/widgets/card.dart';
import 'package:citi_guide/widgets/destinationCards.dart';
import 'package:citi_guide/widgets/greyButton.dart';
import 'package:citi_guide/widgets/transparentButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Dashboard extends StatefulWidget {
  final String userId;
  final String email;
  final String username;
  final String profile;
  const Dashboard({
    super.key,
    required this.userId,
    required this.email,
    required this.username,
    required this.profile,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;

  // ✅ User interests + city
  List<String> _userInterests = [];
  String _userCity = '';
  bool _userLoaded = false;

  final Map<String, bool> _expandedInterests = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ✅ Firestore se user ka city + interests fetch
  Future<void> _loadUserData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      if (!mounted) return;
      final data = doc.data() ?? {};
      setState(() {
        _userInterests = List<String>.from(data['interests'] ?? []);
        _userCity = (data['city'] ?? '').toString().trim();
        _userLoaded = true;
      });
      debugPrint('✅ City loaded: "$_userCity" (length: ${_userCity.length})');
      debugPrint('✅ Interests loaded: $_userInterests');
    } catch (e) {
      debugPrint('❌ Error loading user: $e');
      if (mounted) setState(() => _userLoaded = true);
    }
  }

  ImageProvider getImageProvider(String path) {
    if (path.startsWith('http')) return NetworkImage(path);
    return AssetImage(path);
  }

  Future<List<Widget>> fetchPC() async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection('destinationDetails')
        .doc("wWuqSjoeHtre6w8hegIN")
        .get();

    if (!docSnapshot.exists) return [];

    var data = docSnapshot.data();
    String dID = docSnapshot.id;
    String imagePath = data?['imagePath'] ?? 'assets/images/PC.png';

    return [
      GestureDetector(
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
        child: CityImgCard(
          Widthcard: double.infinity,
          ImgHeight: 300,
          OpacityHeight: 50,
          firstOpacityDivRow: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                child: Text(
                  data?['locationName'] ?? 'Unknown Location',
                  style: TextStyle(color: Constants.greyColor, fontSize: 12),
                ),
              ),
            ],
          ),
          secondOpacityDivRow: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TransparentButton(
                  OpacitySet: 0.1,
                  topBottomPadding: 2,
                  leftRightPadding: 7,
                  widget_: Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          color: Constants.greyColor, size: 10),
                      Text(
                        data?['city'] ?? 'Unknown City',
                        style:
                            TextStyle(fontSize: 10, color: Constants.greyColor),
                      ),
                    ],
                  ),
                  OntapFunction: () {},
                  topBottomMargin: 2,
                  leftRightMargin: 0,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TransparentButton(
                  OpacitySet: 0.1,
                  topBottomPadding: 2,
                  leftRightPadding: 7,
                  widget_: Text(
                    '${data?['distance'] ?? 'Unknown Distance'}',
                    style:
                        TextStyle(fontSize: 10, color: Constants.greyColor),
                  ),
                  OntapFunction: () {},
                  topBottomMargin: 2,
                  leftRightMargin: 0,
                ),
              ),
            ],
          ),
          OpacityAboveRemainingHeightForMargin: 250,
          cityImg: imagePath,
        ),
      ),
    ];
  }

  Widget _buildInterestRow(
      String interest, List<QueryDocumentSnapshot> allDocs) {
    final filtered = allDocs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return (data['category'] ?? '') == interest;
    }).toList();

    if (filtered.isEmpty) return const SizedBox.shrink();

    final isExpanded = _expandedInterests[interest] ?? true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                interest,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff1a1a1a),
                  letterSpacing: 0.2,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _expandedInterests[interest] = !isExpanded;
                  });
                },
                child: AnimatedRotation(
                  turns: isExpanded ? 0 : 0.5,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    color: Constants.OrangeColor,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isExpanded) ...[
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final double cardWidth = (constraints.maxWidth - 18) / 4;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filtered.asMap().entries.map((entry) {
                    final index = entry.key;
                    final doc = entry.value;
                    final data = doc.data() as Map<String, dynamic>;
                    final imagePath =
                        data['imagePath'] ?? 'assets/images/PC.png';

                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DestinationDetails(
                            destinationID: doc.id,
                            url: imagePath,
                            userId: widget.userId,
                          ),
                        ),
                      ),
                      child: Container(
                        width: cardWidth,
                        margin: EdgeInsets.only(
                          right: index < filtered.length - 1 ? 6 : 0,
                        ),
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
                          child: imagePath.startsWith('http')
                              ? Image.network(
                                  imagePath,
                                  height: cardWidth,
                                  width: cardWidth,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _cardFallback(cardWidth),
                                )
                              : Image.asset(
                                  imagePath,
                                  height: cardWidth,
                                  width: cardWidth,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _cardFallback(cardWidth),
                                ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _cardFallback(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(Icons.image_not_supported,
          color: Colors.grey.shade400, size: size * 0.4),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Constants.pageBackgroundColor,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: 0,
          ),
          child: ListView(
            children: [
              const SizedBox(height: 24),
              _buildProfileRow(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 14),
              
              // ✅ FIXED: Only show categories after _userCity is loaded
              if (_userLoaded && _userCity.isNotEmpty)
                _buildCityCategories()
              else if (_userLoaded)
                const SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      'No city selected',
                      style: TextStyle(color: Color(0xffaaaaaa)),
                    ),
                  ),
                )
              else
                const SizedBox(height: 50),

              const SizedBox(height: 16),
              _buildDestinationCards(),
              const SizedBox(height: 12),
              FutureBuilder<List<Widget>>(
                future: fetchPC(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  return Column(children: snapshot.data ?? []);
                },
              ),
              if (_userLoaded && _userInterests.isNotEmpty)
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('destinationDetails')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();

                    final allDocs = snapshot.data!.docs;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _userInterests.map((interest) {
                        final cityFiltered = _userCity.isNotEmpty
                            ? allDocs
                                .where((d) {
                                  final data =
                                      d.data() as Map<String, dynamic>;
                                  return (data['city'] ?? '')
                                          .toString()
                                          .toLowerCase() ==
                                      _userCity.toLowerCase();
                                })
                                .toList()
                            : allDocs;

                        return _buildInterestRow(interest, cityFiltered);
                      }).toList(),
                    );
                  },
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
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
                  textStyle: TextStyle(fontSize: 12, color: Colors.white,  fontWeight: FontWeight.w600),
                ),
                GButton(
                  icon: Icons.bookmark_rounded,
                  text: "Saved",
                  textStyle: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                ),
                GButton(
                  icon: Icons.search_rounded,
                  text: "Search",
                  textStyle: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                ),
                GButton(
                  icon: Icons.person_rounded,
                  text: "Profile",
                  textStyle: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              color: Constants.greyTextColor,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipOval(
  child: CircleAvatar(
    radius: 26,
    backgroundImage: getImageProvider(widget.profile),
    onBackgroundImageError: (exception, stackTrace) {
      debugPrint('Profile image error: $exception');
    },
    child: widget.profile.isEmpty || widget.profile == 'assets/images/profileDefaultImg.jpg'
        ? Icon(
            Icons.person_rounded,
            size: 30,
            color: Colors.grey.shade400,
          )
        : null,
  ),
),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello ${widget.username}",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Color(0xff888888),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Exploring $_userCity 👋",
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Color(0xff1a1a1a),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
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
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xffe5e5e5),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: const Color(0xffaaaaaa),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Search Destination',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xffaaaaaa),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            gradient: Constants.orangeGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Constants.OrangeColor.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
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
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.tune_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCityCategories() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('cities').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
            height: 50,
            child: Center(
              child: CircularProgressIndicator(
                color: Constants.OrangeColor,
              ),
            ),
          );
        }

        final cities = snapshot.data!.docs
            .map((doc) => (doc['city'] ?? '').toString().trim())
            .where((city) => city.isNotEmpty)
            .toList();

        debugPrint('📍 All Cities: $cities');
        debugPrint('👤 User City: "$_userCity" (trimmed, length: ${_userCity.length})');

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: cities.map((city) {
              final isUserCity = city.toLowerCase() == _userCity.toLowerCase();
              
              debugPrint('✅ "$city".toLowerCase() = "${city.toLowerCase()}"');
              debugPrint('✅ "$_userCity".toLowerCase() = "${_userCity.toLowerCase()}"');
              debugPrint('👉 Match? $isUserCity');

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    gradient: isUserCity ? Constants.orangeGradient : null,
                    color: isUserCity ? null : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: !isUserCity
                        ? Border.all(
                            color: const Color(0xffe5e5e5),
                            width: 1.2,
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: isUserCity
                            ? Constants.OrangeColor.withOpacity(0.2)
                            : Colors.black.withOpacity(0.04),
                        blurRadius: isUserCity ? 10 : 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        child: Text(
                          city,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isUserCity
                                ? Colors.white
                                : const Color(0xff999999),
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildDestinationCards() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('destinationDetails')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          var destinationData = snapshot.data?.docs ?? [];
          if (destinationData.isEmpty) {
            return const Center(child: Text('No destinations found.'));
          }

          Future<List<Widget>> fetchUrls() async {
            return Future.wait(destinationData.map((doc) async {
              var data = doc.data();
              String dID = doc.id;
              String imagePath =
                  data['imagePath'] ?? 'assets/images/PC.png';
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DestinationDetails(
                      destinationID: dID,
                      url: imagePath,
                      userId: widget.userId,
                    ),
                  ),
                ),
                child: DestinationCards(
                  imgPath: imagePath,
                  location: data['locationName'],
                  city: data['city'],
                  distance: data['distance'],
                ),
              );
            }).toList());
          }

          return FutureBuilder<List<Widget>>(
            future: fetchUrls(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return Row(children: snapshot.data!);
            },
          );
        },
      ),
    );
  }
}