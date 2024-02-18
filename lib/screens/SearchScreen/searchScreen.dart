import 'dart:async';

import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Cities/cities.dart';
import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:citi_guide/screens/Details/details.dart';
import 'package:citi_guide/screens/profile/profile.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:citi_guide/widgets/searchSuggestions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class SearchScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String username;
  final String profile;
  const SearchScreen(
      {super.key,
      required this.userId,
      required this.email,
      required this.username,
      required this.profile});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
 StreamController<List<Widget>> _streamController =
      StreamController<List<Widget>>.broadcast();

  @override
  void initState() {
    super.initState();
    // Listen to changes in the searchController
    searchController.addListener(() {
      // Trigger a new search when the text changes
      _performSearch();
    });
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  // Function to perform the search based on the current text in searchController
void _performSearch() async {
  var snapshot = await FirebaseFirestore.instance
      .collection('destinationDetails')
      .get();

  var destinationData = snapshot.docs;

  List<Widget> destinationCards = await Future.wait(
    destinationData
        .where((doc) =>
            doc.data()['locationName']
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
        .map<Future<Widget>>((doc) async {
          var data = doc.data();
          String imageUrl = await FirebaseStorage.instance
              .ref()
              .child('locations/${doc.id}')
              .getDownloadURL();
          return GestureDetector(onTap: () {
            Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                     DestinationDetails(destinationID: doc.id,url: imageUrl,)));
          },child: SearchSuggestions(place: data['locationName'],city: data['city'],));
        })
        .toList(),
  );

  // Update the stream with the new search results
  _streamController.add(destinationCards);
}





  int selectedIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              // searchbar row //
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        cursorColor: Constants.greyTextColor,
                        controller: searchController,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3,
                                color: Colors.transparent), //<-- SEE HERE
                          ),
                          filled: true,
                          fillColor: Constants.greyColor,
                          hintText: 'Search Destination',
                          prefixIcon: Icon(Icons.search,
                              color: Constants
                                  .greyTextColor), // Add icon to the left
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Constants.buttonBorderRadius),
                              borderSide:
                                  BorderSide(color: Constants.greyColor)),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: Constants.searchBarButtonHeight),
                        ),
                        style: TextStyle(
                          color: Constants.greyTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     print("tapped");
                    //   },
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       color: Constants.darkBlueColor,
                    //       borderRadius:
                    //           BorderRadius.circular(Constants.buttonBorderRadius),
                    //     ),
                    //     child: Center(
                    //       child: Padding(
                    //         padding: EdgeInsets.symmetric(
                    //             vertical: Constants.searchBarButtonHeight,
                    //             horizontal: 10), // Adjust the padding as needed
                    //         child: Icon(Icons.storage_rounded,
                    //             color: Constants.whiteColor),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    BlueButton(
                      topBottomPadding: Constants.searchBarButtonHeight,
                      leftRightPadding: 10,
                      widget_: Icon(Icons.storage_rounded,
                          color: Constants.whiteColor),
                      OntapFunction: () {
                        print("tapped");
                      },
                      topBottomMargin: 0,
                      leftRightMargin: 0,
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),













StreamBuilder<List<Widget>>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text(" ");
            }

            // Display the search results
            List<Widget> destinationCards = snapshot.data!;
            return Column(
              children: destinationCards,
            );
          },
        ),









































//search suggestions
               
              // const SearchSuggestions(place: "Badshahi Masjid, Lahore"),
              // const SearchSuggestions(place: "Monal Restaurant, Islamabad"),
              // const SearchSuggestions(place: "Super Space, Karachi"),
            ],
          ),
        ),
      ),

// Navigation Bar
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Constants.whiteColor, // Set your border color
            width: 1.0, // Set your border width
          ),
          color: Constants.whiteColor,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 25)],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            backgroundColor: Constants.whiteColor,
            color: Constants.greyTextColor,
            activeColor: Constants.whiteColor,
            selectedIndex: selectedIndex,
            onTabChange: (index) {
              // Update the selected index
              setState(() {
                selectedIndex = index;
              });
              // Handle tab change
              if (index == 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Dashboard(
                            userId: widget.userId,
                            email: widget.email,
                            username: widget.username,
                            profile: widget.profile)));
              } else if (index == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CitiesScreen(
                            userId: widget.userId,
                            email: widget.email,
                            username: widget.username,
                            profile: widget.profile)));
              } else if (index == 2) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchScreen(
                            userId: widget.userId,
                            email: widget.email,
                            username: widget.username,
                            profile: widget.profile)));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                            userId: widget.userId,
                            email: widget.email,
                            username: widget.username,
                            profile: widget.profile)));
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
