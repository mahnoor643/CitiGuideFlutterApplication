import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/SignUpPages/signUp1.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:flutter/material.dart';

class FifthSplashScreen extends StatefulWidget {
  const FifthSplashScreen({super.key});

  @override
  State<FifthSplashScreen> createState() => _FifthSplashScreenState();
}

class _FifthSplashScreenState extends State<FifthSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Create AnimationController
    _animationController = AnimationController(
      vsync:
          this, // Pass 'this' since _FifthSplashScreenState mixes in TickerProviderStateMixin
      duration: Duration(seconds: 1),
    );

    // Create a curved animation
    CurvedAnimation curve =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    // Create a Tween to define the begin and end values for the animation
    Tween<Offset> tween = Tween(begin: Offset(1.0, 0.0), end: Offset.zero);

    // Apply the tween and the curved animation to get the final animation
    _slideAnimation = tween.animate(curve);

    // Start the animation after 4 seconds
    Future.delayed(Duration(seconds: 2), () {
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.splashScreenPageColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(Constants.appLogo),
          ),
          SizedBox(
            height: 60,
          ),
          SlideTransition(
            position: _slideAnimation,
            child: BlueButton(
              topBottomPadding: 10,
              leftRightPadding: 20,
              widget_: Text(
                "Get Started",
                style: TextStyle(
                  color: Constants.whiteColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w200,
                ),
              ),
              OntapFunction: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUp1()));
              },
              topBottomMargin: 0,
              leftRightMargin: 20,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
