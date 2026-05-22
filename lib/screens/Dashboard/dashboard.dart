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

  // Asset ya network image decide karo
  ImageProvider getImageProvider(String path) {
    if (path.startsWith('http')) {
      return NetworkImage(path);
    } else {
      return AssetImage(path);
    }
  }

  // Featured destination card — Firestore se
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
          cityImg: imagePath,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: ListView(
          children: [
            const SizedBox(height: 30),

            // Profile Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(19)),
                    border: Border.all(color: Constants.greyColor),
                  ),
                  margin: const EdgeInsets.only(right: 20, bottom: 5, top: 5),
                  child: ClipOval(
                    
                    child: CircleAvatar(
                      radius: 26,
                      backgroundImage: getImageProvider(widget.profile),
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
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),

            // Search bar row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
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
                  widget_:
                      Icon(Icons.storage_rounded, color: Constants.whiteColor),
                  OntapFunction: () {
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
                  topBottomMargin: 0,
                  leftRightMargin: 0,
                ),
              ],
            ),

            const SizedBox(height: 7),

            // City Categories row
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
                    OntapFunction: () {},
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
                    OntapFunction: () {},
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
                    OntapFunction: () {},
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
                    OntapFunction: () {},
                    topBottomMargin: 0,
                    leftRightMargin: 5,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 7),

            // Destination Cards — Firestore se, sirf tab "no data" jab sach mein khaali ho
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('destinationDetails')
                    .snapshots(),
                builder: (context, snapshot) {
                  // Loading — kuch mat dikhao
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }

                  var destinationData = snapshot.data?.docs ?? [];

                  // Sirf tab dikhao jab data actually khaali ho
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DestinationDetails(
                                destinationID: dID,
                                url: imagePath,
                              ),
                            ),
                          );
                        },
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
                      // Loading — kuch mat dikhao
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
            ),

            // Featured Card
            FutureBuilder<List<Widget>>(
              future: fetchPC(),
              builder: (context, snapshot) {
                // Loading — kuch mat dikhao
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                // Sirf tab dikhao jab data actually khaali ho
                // if (!snapshot.hasData || snapshot.data!.isEmpty) {
                //   return const Center(child: Text('No featured destination.'));
                // }
                return Column(children: snapshot.data!);
              },
            ),
          ],
        ),
      ),

      // Navigation Bar
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Constants.whiteColor, width: 1.0),
          color: Constants.whiteColor,
boxShadow: [
  BoxShadow(
    color: Colors.black.withOpacity(0.50), // Opacity ko 12% se badha kar 25% kar diya (Bright/Dark look)
    blurRadius: 22,                       // Shadow ko thoda crisp rakhne ke liye blur kam kiya
    offset: const Offset(0, 10),           // Shadow ko thoda neeche push kiya taake floating effect aaye
    spreadRadius: 1,                      // Shadow ko thoda phailane ke liye
  ),
],        ),
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