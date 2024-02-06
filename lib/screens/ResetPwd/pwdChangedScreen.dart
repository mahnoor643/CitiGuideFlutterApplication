import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:flutter/material.dart';

class PwdChangedScreen extends StatefulWidget {
  const PwdChangedScreen({super.key});

  @override
  State<PwdChangedScreen> createState() => _PwdChangedScreenState();
}

class _PwdChangedScreenState extends State<PwdChangedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 250,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: Image.asset('assets/images/profile.jpeg')),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                child: Text(
                  "Password changed",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'myfonts',
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                                alignment: Alignment.center,

                child: Text(
                    "Your password has been changed  successfully",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ),
              SizedBox(height: 30,),
              //login in  button
              BlueButton(
                topBottomPadding: Constants.searchBarButtonHeight,
                leftRightPadding: 10,
                widget_: Text(
                  "Back to login",
                  style: TextStyle(
                    color: Constants.greyColor,
                    fontFamily: 'myfonts',
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                OntapFunction: () {
                  print("tapped");
                },
                topBottomMargin: 0,
                leftRightMargin: 0,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
