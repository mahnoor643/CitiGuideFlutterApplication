import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:flutter/material.dart';

class ResetPwd extends StatefulWidget {
  const ResetPwd({super.key});

  @override
  State<ResetPwd> createState() => _ResetPwdState();
}

class _ResetPwdState extends State<ResetPwd> {
    bool _isObscured = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            padding: EdgeInsets.only(right: 20,top:30),
            child: Image.asset(
                    'assets/images/googleIcon.png',
                    height: 40,
                  ),
          ),
        ], 
      ),
      body: Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                        child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.centerLeft,
              child: Text(
                "Reset password?",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'myfonts',
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                  "Please type something you’ll remember",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'myfonts',
                    fontSize: 13,
                    fontWeight: FontWeight.w200,
                  ),
                ),
            ),
              SizedBox(height: 20,),
              
//pwd TextField
            Container(
              margin: EdgeInsets.only(bottom: 10, top: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                "New password",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'myfonts',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            
            TextField(
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 3,
                    color: Colors.transparent,
                  ),
                ),
                filled: true,
                fillColor: Constants.greyColor,
                hintText: 'must be 8 characters',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                ),
              ),
              style: TextStyle(
                color: Colors.grey,
              ),
              obscureText: _isObscured,
            ),
                 
//pwd TextField
            Container(
              margin: EdgeInsets.only(bottom: 10, top: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                "Confirm new password",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'myfonts',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            
            TextField(
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 3,
                    color: Colors.transparent,
                  ),
                ),
                filled: true,
                fillColor: Constants.greyColor,
                hintText: 'repeat password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                ),
              ),
              style: TextStyle(
                color: Colors.grey,
              ),
              obscureText: _isObscured,
            ),
            SizedBox(
              height: 30,
            ),
            //login in  button
            BlueButton(
              topBottomPadding: Constants.searchBarButtonHeight,
              leftRightPadding: 10,
              widget_: Text(
                "Reset password",
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

            //bottom div
            Spacer(),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: () {
                      print("object");
                    },
                    child: Text(
                      " Log in",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
                        ],),
      ),
    );
  }
}