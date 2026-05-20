import 'dart:async';
import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Cities/cities.dart';
import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:citi_guide/screens/Details/details.dart';
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

    var snapshot = await FirebaseFirestore.instance
        .collection('destinationDetails')
        .get();

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
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Search Bar ──
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      cursorColor: Constants.greyTextColor,
                      controller: searchController,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 3, color: Colors.transparent),
                        ),
                        filled: true,
                        fillColor: Constants.greyColor,
                        hintText: 'Search Destination',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Constants.greyTextColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              Constants.buttonBorderRadius),
                          borderSide: BorderSide(color: Constants.greyColor),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: Constants.searchBarButtonHeight,
                        ),
                      ),
                      style: TextStyle(color: Constants.greyTextColor),
                    ),
                  ),
                  const SizedBox(width: 7),
                  BlueButton(
                    topBottomPadding: Constants.searchBarButtonHeight,
                    leftRightPadding: 10,
                    widget_: Icon(
                      Icons.storage_rounded,
                      color: Constants.whiteColor,
                    ),
                    OntapFunction: () {},
                    topBottomMargin: 0,
                    leftRightMargin: 0,
                  ),
                ],
              ),

              const SizedBox(height: 10),

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
                        style: TextStyle(color: Constants.greyTextColor),
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

      // ── Bottom Nav Bar ──
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Constants.whiteColor, width: 1.0),
          color: Constants.whiteColor,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 25)],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            backgroundColor: Constants.whiteColor,
            color: Constants.greyTextColor,
            activeColor: Constants.whiteColor,
            selectedIndex: selectedIndex,
            onTabChange: (index) {
              setState(() {
                selectedIndex = index;
              });
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
                    builder: (context) => CitiesScreen(
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
            padding: const EdgeInsets.all(11),
            tabs: const [
              GButton(icon: Icons.home, text: "Home"),
              GButton(icon: Icons.language, text: "Cities"),
              GButton(icon: Icons.search, text: "Search"),
              GButton(
                  icon: Icons.supervised_user_circle_sharp, text: "Profile"),
            ],
          ),
        ),
      ),
    );
  }
}