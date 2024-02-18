import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Details/details.dart';
import 'package:citi_guide/widgets/card.dart';
import 'package:citi_guide/widgets/transparentButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CityDestinations extends StatefulWidget {
  final String cityFetch;
  const CityDestinations({super.key, required this.cityFetch});

  @override
  State<CityDestinations> createState() => _CityDestinationsState();
}

class _CityDestinationsState extends State<CityDestinations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.whiteColor,
      appBar: AppBar(
        title: Text(widget.cityFetch),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('destinationDetails')
                    .where('city', isEqualTo: widget.cityFetch)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Data is still loading
                    return const Text(" ");
                  }

                  if (snapshot.hasError) {
                    // Error fetching data
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    // No data available
                    return Text('No data available for ${widget.cityFetch}');
                  }

                  // Data has been successfully loaded
                  var destinationData = snapshot.data!.docs;
                  return Column(
                    children: destinationData.map((doc) {
                      var locationName = doc['locationName'];
                      return FutureBuilder(
                        future: FirebaseStorage.instance
                            .ref()
                            .child('locations/${doc.id}')
                            .getDownloadURL(),
                        builder: (context, urlSnapshot) {
                          if (urlSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            // URL is still loading
                            return const Text(" ");
                          }

                          if (urlSnapshot.hasError) {
                            // Error fetching URL
                            return Text('Error: ${urlSnapshot.error}');
                          }

                          var url = urlSnapshot.data as String;
                          String dID = doc.id;
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DestinationDetails(
                                                destinationID: dID,
                                                url: url,
                                              )));
                                },
                                child: CityImgCard(
                                  Widthcard: double.infinity,
                                  ImgHeight: 270,
                                  OpacityHeight: 70,
                                  firstOpacityDivRow: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 6, left: 10),
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
                                                  doc['city'],
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
                                        padding: const EdgeInsets.only(
                                            top: 6, right: 10),
                                        child: TransparentButton(
                                            OpacitySet: 0.1,
                                            topBottomPadding: 3,
                                            leftRightPadding: 7,
                                            widget_: Row(
                                              children: [
                                                Text(
                                                  doc['distance'],
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
                                          doc['locationName'],
                                          style: TextStyle(
                                            color: Constants.greyColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  OpacityAboveRemainingHeightForMargin: 200,
                                  cityImg: url,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
