import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Details/details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FetchData extends StatefulWidget {
  const FetchData({super.key});

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.whiteColor,
        appBar: AppBar(
          backgroundColor: Constants.OrangeColor,
          title: Text(
            "Locations",
            style: TextStyle(color: Constants.whiteColor,fontWeight: FontWeight.w700),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('destinationDetails')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Text('No data available');
            }

            var destinationData = snapshot.data!.docs;

            return ListView.builder(
              itemCount: destinationData.length,
              itemBuilder: (context, index) {
                var doc = destinationData[index];

                return FutureBuilder<String>(
                  future: FirebaseStorage.instance
                      .ref()
                      .child('locations/${doc.id}')
                      .getDownloadURL(),
                  builder: (context, urlSnapshot) {
                    if (urlSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (urlSnapshot.hasError) {
                      return Text(
                          'Error fetching image URL: ${urlSnapshot.error}');
                    }

                    var url = urlSnapshot.data;

                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Constants.greyColor.withOpacity(0.3),
                          width: 3,
                        ),
                      ),
                      child: ListTile(
                        leading: GestureDetector(onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DestinationDetails(
                                            destinationID: '${doc.id}',
                                            url: '$url',
                                          )));
                            },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage('$url'),
                          ),
                        ),
                        title: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DestinationDetails(
                                            destinationID: '${doc.id}',
                                            url: '$url',
                                          )));
                            },
                            child: Text(
                              doc['locationName'],
                              style: TextStyle(fontWeight: FontWeight.w700),
                            )),
                        subtitle: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: Constants.greyTextColor,
                              size: 13,
                            ),
                            Text(
                              doc['city'],
                              style: TextStyle(
                                fontSize: 13,
                                color: Constants.greyTextColor,
                              ),
                            ),
                          ],
                        ),
                        trailing: Container(
  width: 90, // Adjust the width based on your needs
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      IconButton(
        onPressed: () {
          // Assuming 'doc' is the document you want to delete
        String documentId = doc.id;

        // Delete document from Firestore
        FirebaseFirestore.instance
            .collection('destinationDetails')
            .doc(documentId)
            .delete()
            .then((_) {
          print('Document deleted successfully from Firestore');
        }).catchError((error) {
          print('Error deleting document: $error');
        });

        // Create a reference to the file to delete in Firebase Storage
        Reference storageReference =
            FirebaseStorage.instance.ref().child('locations/$documentId');

        // Delete the file from Firebase Storage
        storageReference.delete().then((_) {
          print('File deleted successfully from Firebase Storage');
        }).catchError((error) {
          print('Error deleting file: $error');
        });
      
        },
        icon: Icon(Icons.delete),
      ),
      // IconButton(
      //   onPressed: () {},
      //   icon: Icon(Icons.edit),
      // ),
    ],
  ),
),
                      ),
                    );
                  },
                );
              },
            );
          },
        ));
  }
}
