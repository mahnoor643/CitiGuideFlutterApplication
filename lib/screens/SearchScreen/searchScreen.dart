import 'dart:async';
import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Cities/cities.dart';
import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:citi_guide/screens/Details/details.dart';
import 'package:citi_guide/screens/Saved/Saved.dart';
import 'package:citi_guide/screens/profile/profile.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:citi_guide/widgets/searchSuggestions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class SearchScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String username;
  final String profile;
  const SearchScreen({
    super.key,
    required this.userId,
    required this.email,
    required this.username,
    required this.profile,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final StreamController<List<Widget>> _streamController =
      StreamController<List<Widget>>.broadcast();

  int selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    searchController.removeListener(_performSearch);
    searchController.dispose();
    _streamController.close();
    super.dispose();
  }

  // Search — sirf Firestore imagePath, Firebase Storage nahi
  void _performSearch() async {
    final query = searchController.text.toLowerCase();

    var snapshot =
        await FirebaseFirestore.instance.collection('destinationDetails').get();

    var filtered = snapshot.docs.where((doc) {
      final name = (doc.data()['locationName'] ?? '').toLowerCase();
      return name.contains(query);
    }).toList();

    List<Widget> cards = filtered.map((doc) {
      var data = doc.data();
      String imagePath = data['imagePath'] ?? 'assets/images/PC.png';

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DestinationDetails(
                destinationID: doc.id,
                url: imagePath,
                userId: widget.userId,
              ),
            ),
          );
        },
        child: SearchSuggestions(
          place: data['locationName'] ?? '',
          city: data['city'] ?? '',
        ),
      );
    }).toList();

    if (!_streamController.isClosed) {
      _streamController.add(cards);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xfffbf8f3),
      body: Container(
        margin: EdgeInsets.only(
          top: 20,
          left: size.width * 0.05,
          right: size.width * 0.05,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12),

              // ── Search Bar ──
              Row(
                children: [
                  Expanded(
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
                      child: TextField(
                        cursorColor: Constants.OrangeColor,
                        controller: searchController,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                          hintText: 'Search Destination',
                          hintStyle: const TextStyle(
                            color: Color(0xffaaaaaa),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 12, right: 8),
                            child: Icon(
                              Icons.search_rounded,
                              color: const Color(0xffaaaaaa),
                              size: 20,
                            ),
                          ),
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 0, minHeight: 0),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 0,
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xff1a1a1a),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
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
                        onTap: () {},
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
              ),

              const SizedBox(height: 18),

              // ── Search Results ──
              StreamBuilder<List<Widget>>(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  // Kuch type nahi hua abhi — khaali raho
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }

                  List<Widget> cards = snapshot.data!;

                  // Sirf tab dikhao jab results sach mein khaali hon
                  if (cards.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'No results found.',
                        style: TextStyle(
                          color: const Color(0xffaaaaaa),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }

                  return Column(children: cards);
                },
              ),
            ],
          ),
        ),
      ),

      // ── Bottom Navigation Bar ──
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
}