import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/SignUpPages/signUp1.dart';
import 'package:flutter/material.dart';

class FifthSplashScreen extends StatefulWidget {
  const FifthSplashScreen({super.key});

  @override
  State<FifthSplashScreen> createState() => _FifthSplashScreenState();
}

class _FifthSplashScreenState extends State<FifthSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _contentController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _contentSlide;
  late Animation<double> _contentOpacity;

  @override
  void initState() {
    super.initState();

    // ── Logo Animation ──
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutQuad),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    // ── Content Animation ──
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _contentSlide = Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOutQuad),
    );

    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeInOut),
    );

    // ── Start animations sequentially ──
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 600), () {
      _contentController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Scaffold(
      backgroundColor: Constants.splashScreenPageColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ── Top Spacing ──
            SizedBox(height: size.height * 0.08),

            // ── Logo Section ──
            FadeTransition(
              opacity: _logoOpacity,
              child: ScaleTransition(
                scale: _logoScale,
                child: Image.asset(
                  Constants.mainLogo,
                  height: isSmallScreen ? 140 : 180,
                  width: isSmallScreen ? 140 : 180,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // ── Content Section (Welcome Text + Button) ──
            SlideTransition(
              position: _contentSlide,
              child: FadeTransition(
                opacity: _contentOpacity,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.08,
                  ),
                  child: Column(
                    children: [
                      // ── Welcome Title ──
                      Text(
                        'Welcome to CityGuide',
                        style: TextStyle(
                          color: const Color(0xff1a1a1a),
                          fontSize: isSmallScreen ? 26 : 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: isSmallScreen ? 12 : 16),

                      // ── Subtitle ──
                      Text(
                        'Discover amazing destinations and explore local favorites',
                        style: TextStyle(
                          color: const Color(0xff999999),
                          fontSize: isSmallScreen ? 12 : 14,
                          fontWeight: FontWeight.w500,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: isSmallScreen ? 32 : 48),

                      // ── Get Started Button ──
                      _buildGetStartedButton(isSmallScreen),
                    ],
                  ),
                ),
              ),
            ),

            // ── Bottom Spacing ──
            SizedBox(height: size.height * 0.06),
          ],
        ),
      ),
    );
  }

  // ── Clean Get Started Button ──
  Widget _buildGetStartedButton(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: Constants.orangeGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Constants.OrangeColor.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUp1()),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: isSmallScreen ? 14 : 16,
              horizontal: 24,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}