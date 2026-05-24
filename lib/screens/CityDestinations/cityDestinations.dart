import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Details/details.dart';
import 'package:citi_guide/widgets/card.dart';
import 'package:citi_guide/widgets/transparentButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CityDestinations extends StatefulWidget {
    final String userId;
  final String cityFetch;
  const CityDestinations({super.key, required this.cityFetch, required this.userId});

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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('destinationDetails')
                    .where('city', isEqualTo: widget.cityFetch)
                    .snapshots(),
                builder: (context, snapshot) {
                  // Loading — kuch mat dikhao
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  // Sirf tab dikhao jab sach mein khaali ho
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No destinations found for ${widget.cityFetch}.');
                  }

                  var destinationData = snapshot.data!.docs;

                  return Column(
                    children: destinationData.map((doc) {
                      var data = doc.data() as Map<String, dynamic>;
                      // Firestore se imagePath seedha — Storage nahi
                      String imagePath =
                          data['imagePath'] ?? 'assets/images/PC.png';
                      String dID = doc.id;

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DestinationDetails(
                                    destinationID: dID,
                                    url: imagePath,
                                    userId: widget.userId,
                                  ),
                                ),
                              );
                            },
                            child: CityImgCard(
                              Widthcard: double.infinity,
                              ImgHeight: 270,
                              OpacityHeight: 70,
                              firstOpacityDivRow: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 6, left: 10),
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
                                            data['city'] ?? '',
                                            style: TextStyle(
                                              fontSize: 12,
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
                                    padding: const EdgeInsets.only(
                                        top: 6, right: 10),
                                    child: TransparentButton(
                                      OpacitySet: 0.1,
                                      topBottomPadding: 3,
                                      leftRightPadding: 7,
                                      widget_: Row(
                                        children: [
                                          Text(
                                            data['distance'] ?? '',
                                            style: TextStyle(
                                              fontSize: 12,
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
                              secondOpacityDivRow: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 3),
                                    child: Text(
                                      data['locationName'] ?? '',
                                      style: TextStyle(
                                        color: Constants.greyColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              OpacityAboveRemainingHeightForMargin: 200,
                              cityImg: imagePath,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
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