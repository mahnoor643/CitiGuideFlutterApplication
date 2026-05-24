import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SelectInterestPage extends StatefulWidget {
  final String userId;
  final String email;
  final String username;
  final String profile;
  final String city; // ✅ city SelectCity se aayega

  const SelectInterestPage({
    super.key,
    required this.userId,
    required this.email,
    required this.username,
    required this.profile,
    required this.city,
  });

  @override
  State<SelectInterestPage> createState() => _SelectInterestPageState();
}

class _SelectInterestPageState extends State<SelectInterestPage>
    with SingleTickerProviderStateMixin {
  // ─── Interest data ────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _interests = [
    {
      'title': 'Foodie Finds',
      'subtitle': 'Hidden cafes, street eats\n& iconic restaurants',
      'icons': [Icons.local_cafe, Icons.fastfood],
      'selected': false,
    },
    {
      'title': 'Peaceful Corners',
      'subtitle': 'Libraries, parks &\nquiet little escapes',
      'icons': [Icons.menu_book, Icons.nature],
      'selected': false,
    },
    {
      'title': 'Insta Worthy',
      'subtitle': 'Scenic views, aesthetic\nspots & street art',
      'icons': [Icons.camera_alt, Icons.location_city],
      'selected': false,
    },
    {
      'title': 'Geek Haven',
      'subtitle': 'Arcades, fandom spots\n& themed hangouts',
      'icons': [Icons.sports_esports, Icons.terminal],
      'selected': false,
    },
    {
      'title': 'City Beats',
      'subtitle': 'Concerts, open mics\n& live music vibes',
      'icons': [Icons.music_note, Icons.mic],
      'selected': false,
    },
    {
      'title': 'Culture Trails',
      'subtitle': 'Museums, galleries &\nhistoric landmarks',
      'icons': [Icons.theater_comedy, Icons.account_balance],
      'selected': false,
    },
  ];

  late AnimationController _animationController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int get _selectedCount =>
      _interests.where((i) => i['selected'] == true).length;

  void _toggleInterest(int index) {
    setState(() {
      _interests[index]['selected'] = !_interests[index]['selected'];
    });
  }

  // ✅ Firestore mein interests aur city save karo
  Future<void> _onFinish() async {
    if (_selectedCount < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least 3 interests'),
          backgroundColor: Constants.OrangeColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    // Selected interests ki list
    final List<String> selectedInterests = _interests
        .where((i) => i['selected'] == true)
        .map((i) => i['title'] as String)
        .toList();

    try {
      // ✅ Firestore mein userId ke doc mein interests aur city update karo
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
        'interests': selectedInterests, // ✅ interests list
        'city': widget.city, // ✅ selected city
      });

      debugPrint('Saved interests: $selectedInterests');
      debugPrint('Saved city: ${widget.city}');

      if (!mounted) return;

      // ✅ Dashboard pe navigate karo
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => Dashboard(
            userId: widget.userId,
            email: widget.email,
            username: widget.username,
            profile: widget.profile,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
        (route) => false,
      );
    } catch (e) {
      debugPrint('Error saving: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Something went wrong. Try again!'),
            backgroundColor: Constants.OrangeColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ─── Interest Card ────────────────────────────────────────────────────────
  Widget _buildCard(int index) {
    final item = _interests[index];
    final bool isSelected = item['selected'] as bool;
    final List<IconData> icons = List<IconData>.from(item['icons']);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 50)),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 20),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => _toggleInterest(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected
                ? Constants.OrangeColor.withOpacity(0.08)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? Constants.OrangeColor
                  : const Color(0xffe5e5e5),
              width: isSelected ? 2 : 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? Constants.OrangeColor.withOpacity(0.12)
                    : Colors.black.withOpacity(0.04),
                blurRadius: isSelected ? 10 : 6,
                offset: Offset(0, isSelected ? 3 : 2),
                spreadRadius: isSelected ? 0.5 : 0,
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ── Icons row ──────────────────────────────────
                    Row(
                      children: icons
                          .map((iconData) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Icon(
                                  iconData,
                                  size: 24,
                                  color: isSelected
                                      ? Constants.OrangeColor
                                      : const Color(0xff888888),
                                ),
                              ))
                          .toList(),
                    ),

                    const SizedBox(height: 8),

                    // ── Title ──────────────────────────────────────
                    Text(
                      item['title'] as String,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Constants.OrangeColor
                            : const Color(0xff2a2a2a),
                        letterSpacing: 0.1,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // ── Subtitle ───────────────────────────────────
                    Text(
                      item['subtitle'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? const Color(0xff777777)
                            : const Color(0xffaaaaaa),
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Checkmark ──────────────────────────────────────
              if (isSelected)
                Positioned(
                  top: 10,
                  right: 10,
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 200),
                    scale: isSelected ? 1.0 : 0.0,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        gradient: Constants.orangeGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Constants.OrangeColor.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Constants.pageBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Scrollable content ──────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    // ── Logo with shadow ──────────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.11),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        Constants.mainLogo,
                        height: 190,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.map_outlined,
                          size: 190,
                          color: Constants.OrangeColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Heading ───────────────────────────────────────
                    Text(
                      "What's your vibe?",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xff1a1a1a),
                        letterSpacing: -0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    // ── Subtitle ───────────────────────────────────────
                    Text(
                      'Select 3 or more interests to build\nyour personalized guide.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xff888888),
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 26),

                    // ── 2-column Grid ──────────────────────────────────
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemCount: _interests.length,
                      itemBuilder: (_, i) => _buildCard(i),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ─── Finish Button ─────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                size.width * 0.05,
                12,
                size.width * 0.05,
                size.height * 0.03,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: _selectedCount >= 3
                      ? Constants.orangeGradient
                      : LinearGradient(
                          colors: [
                            const Color(0xffdddddd),
                            const Color(0xffd0d0d0),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: _selectedCount >= 3
                      ? [
                          BoxShadow(
                            color: Constants.OrangeColor.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : [],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(26),
                    onTap: _isSaving ? null : _onFinish,
                    child: Center(
                      child: _isSaving
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              'Finish',
                              style: TextStyle(
                                color: _selectedCount >= 3
                                    ? Colors.white
                                    : const Color(0xff999999),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}