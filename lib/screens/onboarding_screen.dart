import 'package:flutter/material.dart';
import 'authentication_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardData(
      image: 'assets/images/onboard1.png',
      title: 'All in one\nTourism Guide',
      description: '',
      isBulleted: true,
      useWhiteOverlay: false,
      splitTitleAt: -1,
      centerText: false,
      topSpacerFlex: 2,
      iconItems: [
        _IconItem(icon: 'assets/images/vehicles_for_hire_icon.png',       label: 'Vehicles for hire'),
        _IconItem(icon: 'assets/images/accomodations_icon.png',           label: 'Accommodations'),
        _IconItem(icon: 'assets/images/restaurants_and_cuisine_icon.png', label: 'Restaurants and\n cuisine'),
        _IconItem(icon: 'assets/images/tourist_destinations_icon.png',    label: 'Tourist Destinations'),
        _IconItem(icon: 'assets/images/certified_tour_guides_icon.png',   label: 'Certified Tour\n Guides'),
      ],
    ),
    _OnboardData(
      image: 'assets/images/onboard2.png',
      title: 'Discover the Pearl of Africa',
      description:
          'Explore Uganda\'s wildlife, culture,\ndestinations and travel services,\nall in one app.',
      isBulleted: false,
      useWhiteOverlay: true,
      splitTitleAt: 13,
      centerText: true,
      topSpacerFlex: 12,
      iconItems: [],
    ),
    _OnboardData(
      image: 'assets/images/onboard3.png',
      title: 'Plan Your\nAdventure with\nEaze',
      description:
          'Find Trusted Guides, Comfortable\nAccommodations, Reliable Vehicles,\nand Explore destinations by region\neffortlessly.',
      isBulleted: false,
      useWhiteOverlay: false,
      splitTitleAt: -1,
      centerText: true,
      topSpacerFlex: 2,
      iconItems: [],
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthenticationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (i) => setState(() => _currentPage = i),
        itemCount: _pages.length,
        itemBuilder: (_, i) => _OnboardPage(
          data: _pages[i],
          currentPage: _currentPage,
          totalPages: _pages.length,
          isLast: i == _pages.length - 1,
          onNext: _next,
        ),
      ),
    );
  }
}

// ── Data models ──
class _IconItem {
  final String icon;
  final String label;
  const _IconItem({required this.icon, required this.label});
}

class _OnboardData {
  final String image;
  final String title;
  final String description;
  final bool isBulleted;
  final bool useWhiteOverlay;
  final int splitTitleAt;
  final bool centerText;
  final int topSpacerFlex;
  final List<_IconItem> iconItems;

  const _OnboardData({
    required this.image,
    required this.title,
    required this.description,
    required this.isBulleted,
    required this.useWhiteOverlay,
    required this.splitTitleAt,
    required this.centerText,
    required this.topSpacerFlex,
    required this.iconItems,
  });
}

// ── Single onboarding page ──
class _OnboardPage extends StatelessWidget {
  final _OnboardData data;
  final int currentPage;
  final int totalPages;
  final bool isLast;
  final VoidCallback onNext;

  const _OnboardPage({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.isLast,
    required this.onNext,
  });

  Widget _buildTitle(double fontSize) {
    final align = data.centerText ? TextAlign.center : TextAlign.left;

    if (data.splitTitleAt < 0) {
      return Text(
        data.title,
        textAlign: align,
        style: TextStyle(
          fontFamily: 'IBMPlexSerif',
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          height: 1.15,
        ),
      );
    }

    final blackPart = data.title.substring(0, data.splitTitleAt);
    final greenPart = data.title.substring(data.splitTitleAt);

    return RichText(
      textAlign: align,
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'IBMPlexSerif',
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          height: 1.15,
        ),
        children: [
          TextSpan(
            text: blackPart,
            style: const TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: greenPart,
            style: const TextStyle(color: Color(0xFF1C5E4A)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = (screenWidth * 0.072).clamp(22.0, 38.0);

    final align = data.centerText
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;
    final textAlign =
        data.centerText ? TextAlign.center : TextAlign.left;

    final cardColor = data.useWhiteOverlay
        ? Colors.white.withOpacity(0.65)
        : Colors.black.withOpacity(0.45);
    final cardBorder = data.useWhiteOverlay
        ? Colors.white
        : Colors.white.withOpacity(0.25);
    final descColor = data.useWhiteOverlay
        ? const Color(0xFF333333)
        : const Color(0xDDFFFFFF);

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Background image ──
        Image.asset(data.image, fit: BoxFit.cover),

        // ── Content ──
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Spacer(flex: data.topSpacerFlex),

                // ── Content card ──
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 32),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: cardBorder, width: 1),
                  ),
                  child: Column(
  crossAxisAlignment: align,
  children: [
    // ── Curated icon (ONLY for screen 3) ──
    if (data.title.contains('Plan Your'))
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Center(
          child: Container(
  width: 60,
  height: 60,
  padding: const EdgeInsets.all(10),
  decoration: const BoxDecoration(
    color: Colors.white,
    shape: BoxShape.circle,
  ),
  child: Image.asset(
    'assets/images/curated_icon.png',
    fit: BoxFit.contain,
  ),
),
        ),
      ),

    _buildTitle(titleFontSize),
    const SizedBox(height: 14),

                      if (data.isBulleted && data.iconItems.isNotEmpty)
                        _IconList(items: data.iconItems)
                      else
                        Text(
                          data.description,
                          textAlign: textAlign,
                          style: TextStyle(
                            fontFamily: 'CormorantGaramond',
                            fontSize: 20,
                            color: descColor,
                            fontWeight: FontWeight.w700,
                            height: 1.6,
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ── Dots ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    totalPages,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: currentPage == i ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: currentPage == i
                            ? const Color(0xFF0F3B2E)
                            : Colors.white.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Button ──
                GestureDetector(
                  onTap: onNext,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F3B2E),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLast ? 'Get Started' : 'Next',
                          style: const TextStyle(
                            fontFamily: 'IBMPlexSerif',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Icon list widget ──
const String _kTickIcon = 'assets/images/tick_icon.png';

class _IconList extends StatelessWidget {
  final List<_IconItem> items;
  const _IconList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    padding: const EdgeInsets.all(7),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(item.icon, fit: BoxFit.contain),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.label,
                      style: const TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 20,
                        color: Color(0xDDFFFFFF),
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                  ),
                  Image.asset(
                    _kTickIcon,
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}