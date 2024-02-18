import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/CityDestinations/cityDestinations.dart';
import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:citi_guide/screens/SearchScreen/searchScreen.dart';
import 'package:citi_guide/screens/profile/profile.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:citi_guide/widgets/card.dart';
import 'package:citi_guide/widgets/transparentButton.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CitiesScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String username;
  final String profile;
  const CitiesScreen({super.key, required this.userId, required this.email, required this.username, required this.profile});

  @override
  State<CitiesScreen> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
  int selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: Column(
          children: [
            // searchbar row //
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
  readOnly: true, // Set readOnly to true to prevent typing
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
  cursorColor: Constants.greyTextColor,
  decoration: InputDecoration(
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        width: 3,
        color: Colors.transparent,
      ),
    ),
    filled: true,
    fillColor: Constants.greyColor,
    hintText: 'Search Destination',
    prefixIcon: Icon(
      Icons.search,
      color: Constants.greyTextColor,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Constants.buttonBorderRadius),
      borderSide: BorderSide(color: Constants.greyColor),
    ),
    contentPadding: EdgeInsets.symmetric(
      vertical: Constants.searchBarButtonHeight,
    ),
  ),
  style: TextStyle(
    color: Constants.greyTextColor,
  ),
)

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

//City Cards
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  CityDestinations(cityFetch: "Karachi")));
                        },
                        child: CityImgCard(
                            Widthcard: 150,
                            ImgHeight: 150,
                            OpacityHeight: 50,
                            firstOpacityDivRow: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 5),
                                  child: Text(
                                    "Karachi",
                                    style: TextStyle(
                                      color: Constants.greyColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            secondOpacityDivRow: Row(
                              children: [
                                TransparentButton(
                                    OpacitySet: 0.1,
                                    topBottomPadding: 2,
                                    leftRightPadding: 7,
                                    widget_: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: Constants.greyColor,
                                          size: 10,
                                        ),
                                        Text(
                                          "Location",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Constants.greyColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    OntapFunction: () {
                                      print("navigation button");
                                    },
                                    topBottomMargin: 2,
                                    leftRightMargin: 0),
                              ],
                            ),
                            OpacityAboveRemainingHeightForMargin: 100,
                            cityImg: 'assets/images/Karachi.jpg'),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                           Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  CityDestinations(cityFetch: "Lahore")));
                        },
                        child: CityImgCard(
                            Widthcard: 150,
                            ImgHeight: 150,
                            OpacityHeight: 50,
                            firstOpacityDivRow: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 5),
                                  child: Text(
                                    "Lahore",
                                    style: TextStyle(
                                      color: Constants.greyColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            secondOpacityDivRow: Row(
                              children: [
                                TransparentButton(
                                    OpacitySet: 0.1,
                                    topBottomPadding: 2,
                                    leftRightPadding: 7,
                                    widget_: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: Constants.greyColor,
                                          size: 10,
                                        ),
                                        Text(
                                          "Location",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Constants.greyColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    OntapFunction: () {
                                      print("navigation button");
                                    },
                                    topBottomMargin: 2,
                                    leftRightMargin: 0),
                              ],
                            ),
                            OpacityAboveRemainingHeightForMargin: 100,
                            cityImg: 'assets/images/Lahore.jpg'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                           Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  CityDestinations(cityFetch: "Quetta")));
                        },
                        child: CityImgCard(
                            Widthcard: 150,
                            ImgHeight: 150,
                            OpacityHeight: 50,
                            firstOpacityDivRow: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 5),
                                  child: Text(
                                    "Quetta",
                                    style: TextStyle(
                                      color: Constants.greyColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            secondOpacityDivRow: Row(
                              children: [
                                TransparentButton(
                                    OpacitySet: 0.1,
                                    topBottomPadding: 2,
                                    leftRightPadding: 7,
                                    widget_: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: Constants.greyColor,
                                          size: 10,
                                        ),
                                        Text(
                                          "Location",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Constants.greyColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    OntapFunction: () {
                                      print("navigation button");
                                    },
                                    topBottomMargin: 2,
                                    leftRightMargin: 0),
                              ],
                            ),
                            OpacityAboveRemainingHeightForMargin: 100,
                            cityImg: 'assets/images/Quetta.jpg'),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                           Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  CityDestinations(cityFetch: "Peshawar")));
                        },
                        child: CityImgCard(
                            Widthcard: 150,
                            ImgHeight: 150,
                            OpacityHeight: 50,
                            firstOpacityDivRow: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 5),
                                  child: Text(
                                    "Peshawar",
                                    style: TextStyle(
                                      color: Constants.greyColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            secondOpacityDivRow: Row(
                              children: [
                                TransparentButton(
                                    OpacitySet: 0.1,
                                    topBottomPadding: 2,
                                    leftRightPadding: 7,
                                    widget_: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: Constants.greyColor,
                                          size: 10,
                                        ),
                                        Text(
                                          "Location",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Constants.greyColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    OntapFunction: () {
                                      print("navigation button");
                                    },
                                    topBottomMargin: 2,
                                    leftRightMargin: 0),
                              ],
                            ),
                            OpacityAboveRemainingHeightForMargin: 100,
                            cityImg: 'assets/images/Peshawar.jpg'),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
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
            tabBackgroundColor: Constants.OrangeColor,
                        selectedIndex: selectedIndex,
            onTabChange: (index) {
              // Update the selected index
            setState(() {
              selectedIndex = index;
            });
              // Handle tab change
              if (index == 0) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  Dashboard(userId: widget.userId, email: widget.email, username: widget.username, profile: widget.profile)));
              } else if (index == 1) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  CitiesScreen(userId: widget.userId, email: widget.email, username: widget.username, profile: widget.profile)));
              } else if (index == 2) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  SearchScreen(userId: widget.userId, email: widget.email, username: widget.username, profile: widget.profile)));
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen(userId: widget.userId, email: widget.email, username: widget.username, profile: widget.profile)));
              }
            },
            gap: 8,
            padding: EdgeInsets.all(11),
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
