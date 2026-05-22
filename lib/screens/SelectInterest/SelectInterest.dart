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

class _SelectInterestPageState extends State<SelectInterestPage> {
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

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

      // ✅ Dashboard pe navigate karo
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(
            userId: widget.userId,
            email: widget.email,
            username: widget.username,
            profile: widget.profile,
          ),
        ),
        (route) => false,
      );
    } catch (e) {
      debugPrint('Error saving: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Something went wrong. Try again!'),
          backgroundColor: Constants.OrangeColor,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  // ─── Interest Card ────────────────────────────────────────────────────────
  Widget _buildCard(int index) {
    final item = _interests[index];
    final bool isSelected = item['selected'] as bool;
    final List<IconData> icons = List<IconData>.from(item['icons']);

    return GestureDetector(
      onTap: () => _toggleInterest(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected
              ? Constants.OrangeColor.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Constants.OrangeColor
                : Constants.OrangeColor.withOpacity(0.2),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Constants.OrangeColor.withOpacity(0.12)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
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
                  Row(
                    children: icons
                        .map((iconData) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                iconData,
                                size: 24,
                                color: isSelected
                                    ? Constants.OrangeColor
                                    : Colors.black.withOpacity(0.7),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['title'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Constants.OrangeColor : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['subtitle'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      color: !isSelected
                          ? Constants.greyTextColor
                          : const Color.fromARGB(255, 64, 64, 64),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            // Checkmark
            if (isSelected)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Constants.OrangeColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Scrollable content ──────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),

                      // ── Logo ──────────────────────────────────────
                      Image.asset(
                        'assets/images/citiGuideIcon.png',
                        height: screenHeight * 0.22,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 22),

                      // ── Heading ───────────────────────────────────
                      const Text(
                        "What's your vibe?",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Select 3 or more interests to build\nyour personalized guide.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── 2-column Grid ─────────────────────────────
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.35,
                        ),
                        itemCount: _interests.length,
                        itemBuilder: (_, i) => _buildCard(i),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // ─── Finish Button ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  gradient: Constants.orangeGradient,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: _selectedCount >= 3
                      ? [
                          BoxShadow(
                            color: Constants.OrangeColor.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: _onFinish,
                    child: const Center(
                      child: Text(
                        'Finish',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
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
