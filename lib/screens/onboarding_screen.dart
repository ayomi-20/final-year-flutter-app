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
      iconItems: [
        _IconItem(icon: 'assets/images/vehicles_for_hire_icon.png', label: 'Vehicles for hire'),
        _IconItem(icon: 'assets/images/accomodations_icon.png', label: 'Accommodations'),
        _IconItem(icon: 'assets/images/restaurants_and_cuisine_icon.png', label: 'Restaurants and\n cuisine'),
        _IconItem(icon: 'assets/images/tourist_destinations_icon.png', label: 'Tourist Destinations'),
        _IconItem(icon: 'assets/images/certified_tour_guides_icon.png', label: 'Certified Tour\n Guides'),
      ],
    ),
    _OnboardData(
      image: 'assets/images/onboard2.png',
      title: 'Discover the\nPearl of Africa',
      description:
          'Explore Uganda\'s wildlife, culture,\ndestinations and travel services,\nall in one app.',
      isBulleted: false,
      iconItems: [],
    ),
    _OnboardData(
      image: 'assets/images/onboard3.png',
      title: 'Plan Your\nAdventure with\nEaze',
      description:
          'Find Trusted Guides, Comfortable\nAccommodations, Reliable Vehicles,\nand Explore destinations by region\neffortlessly.',
      isBulleted: false,
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
  final List<_IconItem> iconItems;

  const _OnboardData({
    required this.image,
    required this.title,
    required this.description,
    required this.isBulleted,
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image.asset(data.image, fit: BoxFit.cover),

        // ✅ UPDATED GRADIENT (fix)
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x66071F14), // light tint at top
                Color(0xE6071F14), // strong tint at bottom
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ),

        // ── Overlay content ──
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // ── Content card ──
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title,
                        style: const TextStyle(
                          fontFamily: 'IBMPlexSerif',
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 14),

                      if (data.isBulleted && data.iconItems.isNotEmpty)
                        _IconList(items: data.iconItems)
                      else
                        Text(
                          data.description,
                          style: const TextStyle(
                            fontFamily: 'CormorantGaramond',
                            fontSize: 18,
                            color: Color(0xDDFFFFFF),
                            fontWeight: FontWeight.w300,
                            height: 1.4,
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
                            ? Colors.white
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
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F3B2E),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
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
                    child: Image.asset(
                      item.icon,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      item.label,
                      style: const TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 18,
                        color: Color(0xDDFFFFFF),
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                      ),
                    ),
                  ),

                  Image.asset(
                    _kTickIcon,
                    width: 22,
                    height: 22,
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