import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:citi_guide/widgets/greyButton.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.only(left: 20, right: 20),
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
                  child: TextField(
                    cursorColor: Constants.greyTextColor,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Constants.greyColor,
                      hintText: 'Search Destination',
                      prefixIcon: Icon(Icons.search,
                          color:
                              Constants.greyTextColor), // Add icon to the left
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              Constants.buttonBorderRadius),
                          borderSide: BorderSide(color: Constants.greyColor)),
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
                  widget_:
                      Icon(Icons.storage_rounded, color: Constants.whiteColor),
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
                    print("tapped");
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













          //Destination cards
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SafeArea(
          top: true,
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: Colors.grey,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://picsum.photos/seed/127/600',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Opacity(
                  opacity: 0.8,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 200,
                      height: 109,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
