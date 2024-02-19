import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Login/login.dart';
import 'package:citi_guide/widgets/whiteButton.dart';
import 'package:flutter/material.dart';

class SignUp1 extends StatefulWidget {
  const SignUp1({super.key});

  @override
  State<SignUp1> createState() => _SignUp1State();
}

class _SignUp1State extends State<SignUp1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(19),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                  color: Constants.lightBlueColor,
                  child: Column(
                    children: [
                      Container(
                          height: 150,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: Image.asset(Constants.appLogo)),
                      const Text(
                        "Explore the app",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.only(top: 5, bottom: 5),
                        child: const Text(
                          "Now your finances are in one place and always under control",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w200,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
          const SizedBox(height: 15,),
                      //First Button
                      whiteButton(
                          topBottomPadding: 10,
                          leftRightPadding: 15,
                          widget_: Row(
                            children: [
                              Image.asset(
                                'assets/images/googleIcon.png',
                                height: 20,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Continue with Google",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          OntapFunction: () {
                            print("navigation button");
                          },
                          topBottomMargin: 2,
                          leftRightMargin: 0),
                      const SizedBox(
                        height: 10,
                      ),
          
                      //Second Button
                      whiteButton(
                          topBottomPadding: 10,
                          leftRightPadding: 15,
                          widget_: const Row(
                            children: [
                              Icon(
                                Icons.apple,
                                color: Colors.black,
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Continue with Apple",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          OntapFunction: () {
                            print("navigation button");
                          },
                          topBottomMargin: 2,
                          leftRightMargin: 0),
                      const SizedBox(
                        height: 10,
                      ),
          
                      //Third button
                      whiteButton(
                          topBottomPadding: 10,
                          leftRightPadding: 15,
                          widget_: const Row(
                            children: [
                              Icon(
                                Icons.email,
                                color: Colors.black,
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Continue with Email",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          OntapFunction: () {
                            print("navigation button");
                          },
                          topBottomMargin: 2,
                          leftRightMargin: 0),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(top:10,bottom:20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
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
                        Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Login()));
                      },
                      child: const Text(
                      "Log in",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                      
                    ),
                    )
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }
}
