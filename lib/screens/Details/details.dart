import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/widgets/card.dart';
import 'package:citi_guide/widgets/transparentButton.dart';
import 'package:flutter/material.dart';

class DestinationDetails extends StatelessWidget {
  const DestinationDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Container(
              child: CityImgCard(
                  Widthcard: double.infinity,
                  ImgHeight: 270,
                  OpacityHeight: 70,
                  firstOpacityDivRow: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 6, left: 10),
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
                                    fontSize: 12,
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
                        padding: EdgeInsets.only(top: 6, right: 10),
                        child: TransparentButton(
                            OpacitySet: 0.1,
                            topBottomPadding: 3,
                            leftRightPadding: 7,
                            widget_: Row(
                              children: [
                                Text(
                                  "6.5 km",
                                  style: TextStyle(
                                    fontSize: 12,
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
                  secondOpacityDivRow: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 3),
                        child: Text(
                          "PC Hotel(Pearl Continental)",
                          style: TextStyle(
                            color: Constants.greyColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  OpacityAboveRemainingHeightForMargin: 200,
                  cityImg: 'assets/images/profile.jpeg'),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                "Pearl Continental (PC Hotel)",
                style: TextStyle(
                  color: Constants.darkBlueColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 10,bottom:10),
              child: Text(
                "CrossAxisAlignment is a property that often finds its relevance in Flutter’s Flex-based layout widgets, namely Column and Row. In text alignment, this property can be an essential tool for aligning text widgets vertically within a Column or horizontally within a Row.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Row(
              children: [
                //first column
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.route_sharp,
                          color: Constants.darkBlueColor,
                        ),
                        Text(
                          "Distance",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "3.2 km",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

          //second column
                Spacer(),
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_sharp,
                          color: Constants.darkBlueColor,
                        ),
                        Text(
                          "Opening Hours",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "24 hours",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            //Rating part row aaegi yahan

            Column(
              children: [
                Row(
                  children: [
                    Icon(
                          Icons.phone_in_talk_outlined,
                          color: Constants.darkBlueColor,
                        ),
                        Text(
                          "Contact Number",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                          "         021-321 654254",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
