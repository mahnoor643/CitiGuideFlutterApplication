// import 'dart:html';

import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Cities/cities.dart';
import 'package:citi_guide/screens/Details/details.dart';
import 'package:citi_guide/screens/SearchScreen/searchScreen.dart';
import 'package:citi_guide/screens/profile/profile.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:citi_guide/widgets/card.dart';
import 'package:citi_guide/widgets/destinationCards.dart';
import 'package:citi_guide/widgets/greyButton.dart';
import 'package:citi_guide/widgets/transparentButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Dashboard extends StatefulWidget {
  final String userId;
  final String email;
  final String username;
  final String profile;
  const Dashboard({super.key, required this.userId, required this.email, required this.username, required this.profile});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;





 // Asynchronous function to fetch URLs
                Future<List<Widget>> fetchPC() async {
                  // Fetching document data from Firestore
    var docSnapshot = await FirebaseFirestore.instance.collection('destinationDetails').doc("wWuqSjoeHtre6w8hegIN").get();
    
    if (!docSnapshot.exists) {
      return []; // Return empty list if document doesn't exist
    }

    var data = docSnapshot.data();
    String dID = docSnapshot.id;

    // Fetching image URL from Firebase Storage
    final ref = FirebaseStorage.instance.ref().child('locations/$dID');
    var url = await ref.getDownloadURL();

    return [
      GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                       DestinationDetails(destinationID: dID, url: url)));
        },
        child: CityImgCard(
          Widthcard: double.infinity,
          ImgHeight: 300,
          OpacityHeight: 50,
          firstOpacityDivRow: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                child: Text(
                  data?['locationName'] ?? 'Unknown Location',
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
                padding: const EdgeInsets.only(left: 10),
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
                        data?['city'] ?? 'Unknown City',
                        style: TextStyle(
                          fontSize: 10,
                          color: Constants.greyColor,
                        ),
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
                  widget_: Row(
                    children: [
                      Text(
                        '${data?['distance'] ?? 'Unknown Distance'}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Constants.greyColor,
                        ),
                      ),
                    ],
                  ),
                  OntapFunction: () {},
                  topBottomMargin: 2,
                  leftRightMargin: 0,
                ),
              ),
            ],
          ),
          OpacityAboveRemainingHeightForMargin: 250,
          cityImg: url,
        ),
      ),
    ];
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Navigation Bar

      body: Container(
        margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: ListView(children: [
          const SizedBox(height: 30),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(19)),
                  border: Border.all(
                    color: Constants.greyColor,
                  ),
                ),
                margin: const EdgeInsets.only(right: 20, bottom: 5, top: 5),
                child: ClipOval(
                  child: CircleAvatar(
                    radius: 26,
                    child: Image(
                      image: NetworkImage(widget.profile),
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
                    widget.username,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                    textAlign: TextAlign.left,
                  ),
                  const Text(
                    "Good Morning",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
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
                  child:TextField(
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
                  widget_:
                      Icon(Icons.storage_rounded, color: Constants.whiteColor),
                  OntapFunction: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  SearchScreen(userId: widget.userId, email: widget.email, username: widget.username, profile: widget.profile)));
                  },
                  topBottomMargin: 0,
                  leftRightMargin: 0,
                ),
              ],
            ),
          ),

          const SizedBox(
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
                  widget_: const Text(
                    "Karachi",
                    style: TextStyle(color: Colors.white),
                  ),
                  OntapFunction: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const DestinationDetails()));
                  },
                  topBottomMargin: 0,
                  leftRightMargin: 0,
                ),
                GreyButton(
                  topBottomPadding: 10,
                  leftRightPadding: 30,
                  widget_: const Text(
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
                  widget_: const Text(
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
                  widget_: const Text(
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

          const SizedBox(
            height: 7,
          ),

          //Destination cards
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child:
                // StreamBuilder(
                //   stream: FirebaseFirestore.instance
                //       .collection('destinationDetails')
                //       .snapshots(),
                //   builder: (context, snapshot) {
                //     if (!snapshot.hasData) {
                //       return CircularProgressIndicator(); // Display loading indicator while data is being fetched
                //     }
                //     var destinationData = snapshot.data?.docs ?? [];
                //     return ListView.builder(
                //         shrinkWrap: true,
                //         physics: NeverScrollableScrollPhysics(),
                //         itemCount: destinationData.length,
                //         itemBuilder: (context, index) {
                //           var data = destinationData[index].data();
                //           return DestinationCards(
                //               imgPath: 'assets/images/PC.png',
                //               location: data['locationName'],
                //               city: data['city'],
                //               distance: data['distance']);
                //         });
                //   },
                // ),
                StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('destinationDetails')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text(" ");
                }

                var destinationData = snapshot.data?.docs ?? [];

                // Asynchronous function to fetch URLs
                Future<List<Widget>> fetchUrls() async {
                  return Future.wait(destinationData.map((doc) async {
                    final ref = FirebaseStorage.instance
                        .ref()
                        .child('locations/${doc.id}');
                    var url = await ref.getDownloadURL();
                    var data = doc.data();
                    String dID = doc.id;
                    print("Image URL: $url");
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                     DestinationDetails(destinationID: dID,url: url,)));
                      },
                      child: DestinationCards(
                        imgPath: '$url',
                        location: data['locationName'],
                        city: data['city'],
                        distance: data['distance'],
                      ),
                    );
                  }).toList());
                }

                // Use FutureBuilder to handle the asynchronous operation
                return FutureBuilder<List<Widget>>(
                  future: fetchUrls(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(" ");
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    // Display the cards once the data is available
                    List<Widget> destinationCards = snapshot.data!;
                    return Row(
                      children: destinationCards,
                    );
                  },
                );
              },
            ),

            // DestinationCards(
            //     imgPath: 'assets/images/clockTower.png',
            //     location: 'Clock Tower',
            //     city: 'Karachi',
            //     distance: '6.2 Km'),
            // DestinationCards(
            //     imgPath: 'assets/images/superSpace.png',
            //     location: 'Super Space',
            //     city: 'Karachi',
            //     distance: '3.2 Km'),
            // DestinationCards(
            //     imgPath: 'assets/images/PC.png',
            //     location: 'PC Hotel',
            //     city: 'Karachi',
            //     distance: '3.2 Km'),
          ),



          Column(
            children: [
              FutureBuilder<List<Widget>>(
        future: fetchPC(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          return Column(
            children: snapshot.data!,
          );
        },
      ),
            ],
          )
        ]),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  Dashboard(userId: widget.userId, email: widget.email, username: widget.username, profile: widget.profile)));
              } else if (index == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  CitiesScreen(userId: widget.userId, email: widget.email, username: widget.username, profile: widget.profile)));
              } else if (index == 2) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  SearchScreen(userId: widget.userId, email: widget.email, username: widget.username, profile: widget.profile)));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  ProfileScreen(userId: widget.userId, email: widget.email, username: widget.username, profile: widget.profile)));
              }
            },
            tabBackgroundColor: Constants.OrangeColor,
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
