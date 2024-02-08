import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Cities/cities.dart';
import 'package:citi_guide/screens/Details/details.dart';
import 'package:citi_guide/screens/Login/login.dart';
import 'package:citi_guide/screens/SearchScreen/searchScreen.dart';
import 'package:citi_guide/screens/profile/profile.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:citi_guide/widgets/card.dart';
import 'package:citi_guide/widgets/destinationCards.dart';
import 'package:citi_guide/widgets/greyButton.dart';
import 'package:citi_guide/widgets/transparentButton.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Navigation Bar

      body: Container(
        margin: EdgeInsets.only(top: 10, left: 20, right: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(height: 30),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(19)),
                      border: Border.all(
                        color: Constants.greyColor,
                      ),
                    ),
                    margin: EdgeInsets.only(right: 20, bottom: 5, top: 5),
                    child: ClipOval(
                      child: CircleAvatar(
                        radius: 26,
                        child: Image(
                          image: AssetImage(Constants.dashboardProfileImg),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Constants.profileName,
                        style: TextStyle(fontWeight: FontWeight.w400),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "Good Morning",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 20),
                      )
                    ],
                  )
                ],
              ),

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
                    SizedBox(
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

              SizedBox(
                height: 7,
              ),

              //City Categories row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    BlueButton(
                      topBottomPadding: 10,
                      leftRightPadding: 30,
                      widget_: Text(
                        "Karachi",
                        style: TextStyle(color: Colors.white),
                      ),
                      OntapFunction: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DestinationDetails()));
                      },
                      topBottomMargin: 0,
                      leftRightMargin: 0,
                    ),
                    GreyButton(
                      topBottomPadding: 10,
                      leftRightPadding: 30,
                      widget_: Text(
                        "Islamabad",
                        style: TextStyle(color: Color(0xff000000)),
                      ),
                      OntapFunction: () {
                        print("tapped");
                      },
                      topBottomMargin: 0,
                      leftRightMargin: 5,
                    ),
                    GreyButton(
                      topBottomPadding: 10,
                      leftRightPadding: 30,
                      widget_: Text(
                        "Lahore",
                        style: TextStyle(color: Color(0xff000000)),
                      ),
                      OntapFunction: () {
                        print("tapped");
                      },
                      topBottomMargin: 0,
                      leftRightMargin: 5,
                    ),
                    GreyButton(
                      topBottomPadding: 10,
                      leftRightPadding: 30,
                      widget_: Text(
                        "Multan",
                        style: TextStyle(color: Color(0xff000000)),
                      ),
                      OntapFunction: () {
                        print("tapped");
                      },
                      topBottomMargin: 0,
                      leftRightMargin: 5,
                    ),
                  ],
                ),
              ),

              // Card(
              //             clipBehavior: Clip.antiAliasWithSaveLayer,
              //             color: Colors.grey,
              //             elevation: 4,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(20),
              //             ),
              //             child: Stack(
              //               children: [
              //                 ClipRRect(
              //                   borderRadius: BorderRadius.circular(8),
              //                   child: Image.network(
              //                     'https://picsum.photos/seed/127/600',
              //                     width: 200,
              //                     height: 200,
              //                     fit: BoxFit.cover,
              //                   ),
              //                 ),
              //                 Opacity(
              //                   opacity: 0.8,
              //                   child: Align(
              //                     alignment: Alignment.bottomCenter,
              //                     child: Container(
              //                       width: 200,
              //                       height: 109,
              //                       decoration: BoxDecoration(
              //                         color: Colors.white,
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),

              SizedBox(
                height: 7,
              ),

              //Destination cards
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    DestinationCards(
                        imgPath: 'assets/images/PC.png',
                        location: 'PC Hotel',
                        city: 'Karachi',
                        distance: '3.2 Km'),
                    DestinationCards(
                        imgPath: 'assets/images/clockTower.png',
                        location: 'Clock Tower',
                        city: 'Karachi',
                        distance: '6.2 Km'),
                    DestinationCards(
                        imgPath: 'assets/images/superSpace.png',
                        location: 'Super Space',
                        city: 'Karachi',
                        distance: '3.2 Km'),
                    DestinationCards(
                        imgPath: 'assets/images/PC.png',
                        location: 'PC Hotel',
                        city: 'Karachi',
                        distance: '3.2 Km'),
                  ],
                ),
              ),

              Column(
                children: [
                  Container(
                    child: CityImgCard(
                        Widthcard: double.infinity,
                        ImgHeight: 300,
                        OpacityHeight: 50,
                        firstOpacityDivRow: Row(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 10, right: 10, top: 5),
                              child: Text(
                                "PC Hotel(Pearl Continental)",
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
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: TransparentButton(
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
                                        "Karachi",
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
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: TransparentButton(
                                  OpacitySet: 0.1,
                                  topBottomPadding: 2,
                                  leftRightPadding: 7,
                                  widget_: Row(
                                    children: [
                                      Text(
                                        "6.5 km",
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
                            ),
                          ],
                        ),
                        OpacityAboveRemainingHeightForMargin: 250,
                        cityImg: 'assets/images/PC.png'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),

      // Navigation Bar
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
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
                    MaterialPageRoute(builder: (context) => Dashboard()));
              } else if (index == 1) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CitiesScreen()));
              } else if (index == 2) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              }
            },
                        tabBackgroundGradient: Constants.orangeGradient,
            gap: 8,
            padding: EdgeInsets.all(11),
            tabs: [
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
