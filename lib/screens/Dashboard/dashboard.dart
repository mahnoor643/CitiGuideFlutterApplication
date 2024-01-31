import 'package:citi_guide/Constants/constants.dart';
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
          SizedBox(height: 20),

          // searchbar row
         Container(
  decoration: BoxDecoration(
    color: Constants.greyColor,
    borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
  ),
  child: Row(
    children: [
      Container(
        margin: EdgeInsets.all(4),
        child: Icon(Icons.search, color: Constants.greyTextColor),
      ),
      Expanded(
        child: TextField(
          cursorColor: Constants.greyTextColor,
          decoration: InputDecoration(
            filled: true,
            fillColor: Constants.greyColor,
            hintText: 'Search Destination',
          ),
          style: TextStyle(
            color: Constants.greyTextColor,
          ),
        ),
      ),









      //will continue from hereeeeeeeeeeeeee
      ElevatedButton(onPressed: (){
        //
      }, child: Text("hello ji"))
    ],
  ),
)

        ],
      ),
    ));
  }
}
