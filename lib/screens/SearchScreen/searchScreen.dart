import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Cities/cities.dart';
import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:citi_guide/screens/profile/profile.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:citi_guide/widgets/searchSuggestions.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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

//search suggestions
const SearchSuggestions(place: "Pearl Continental Hotel, Karachi"),
const SearchSuggestions(place: "Badshahi Masjid, Lahore"),
const SearchSuggestions(place: "Monal Restaurant, Islamabad"),
const SearchSuggestions(place: "Super Space, Karachi"),
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
            onTabChange: (index) {
              // Update the selected index
            setState(() {
              selectedIndex = index;
            });
              // Handle tab change
              if (index == 0) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Dashboard()));
              } else if (index == 1) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CitiesScreen()));
              } else if (index == 2) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SearchScreen()));
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()));
              }
            },
                        tabBackgroundGradient: Constants.orangeGradient,
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
