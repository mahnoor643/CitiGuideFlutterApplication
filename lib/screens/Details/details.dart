import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/map/map_page.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:citi_guide/widgets/card.dart';
import 'package:citi_guide/widgets/transparentButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DestinationDetails extends StatelessWidget {
  final String destinationID;
  final String url;
  const DestinationDetails(
      {super.key, required this.destinationID, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('destinationDetails')
              .doc(destinationID)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            var doc = snapshot.data!;
            var data = doc.data();
            String docId = doc.id;
            String locationString = data!['location'];
            List<String> latLngList = locationString.split(',');
              double latitude = double.parse(latLngList[0]);
              double longitude = double.parse(latLngList[1]);
            
            return Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
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
                                          data['city'],
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
                              const Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 6, right: 10),
                                child: TransparentButton(
                                    OpacitySet: 0.1,
                                    topBottomPadding: 3,
                                    leftRightPadding: 7,
                                    widget_: Row(
                                      children: [
                                        Text(
                                          data['distance'],
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
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 3),
                                child: Text(
                                  data['locationName'],
                                  style: TextStyle(
                                    color: Constants.greyColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          OpacityAboveRemainingHeightForMargin: 200,
                          cityImg: url),
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        data['locationName'],
                        style: TextStyle(
                          color: Constants.OrangeColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        data['description'],
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
                                  color: Constants.OrangeColor,
                                ),
                                const Text(
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
                                  data['distance'],
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
                        const Spacer(),
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_sharp,
                                  color: Constants.OrangeColor,
                                ),
                                const Text(
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
                                  data['timings'],
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
                              color: Constants.OrangeColor,
                            ),
                            const Text(
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
                              "         ${data['distance']}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),

                    //map
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MapPage(longitudeDetected: longitude, latitudeDetected: latitude)));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 2)
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Container(
                            child: Image.asset(
                              'assets/images/map.png',
                              fit: BoxFit.cover,
                            ),
                            decoration: BoxDecoration(
                              color: Constants.greyColor,
                            ),
                          ),
                        ),
                      ),
                    ),

                    BlueButton(
                        topBottomPadding: 10,
                        leftRightPadding: 30,
                        widget_: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Let's Go",
                              style: TextStyle(
                                color: Constants.whiteColor,
                              ),
                            ),
                            Icon(
                              Icons.arrow_outward_rounded,
                              color: Constants.whiteColor,
                            ),
                          ],
                        ),
                        OntapFunction: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapPage(
                                      longitudeDetected: longitude, latitudeDetected: latitude)));
                        },
                        topBottomMargin: 10,
                        leftRightMargin: 90)
                  ],
                ),
              ),
            );
          },
        ));
  }
}
