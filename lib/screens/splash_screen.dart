// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'onboarding_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

// @override
// State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
// @override
// void initState() {
// super.initState();

// // Move to Onboarding after 3 seconds
// Timer(Duration(seconds: 3), () {
// Navigator.pushReplacement(
// context,
// MaterialPageRoute(builder: (context) => OnboardingScreen()),
// );
// });
// }

// @override
// Widget build(BuildContext context) {
// return Scaffold(
// backgroundColor: const Color(0xFFE3EFE5),
// body: Center(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// // App logo or icon
// Image.asset('assets/images/logo.png', height: 100),
// SizedBox(height: 20),
// SizedBox(height: 40),
// CircularProgressIndicator(color: Colors.white),
// ],
// ),
// ),
// );
// }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _animController.forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Full-screen background image ──
          Image.asset(
            'assets/images/splash_bg.png',
            fit: BoxFit.cover,
          ),

          // ── Dark gradient overlay (bottom fade) ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0xCC0F3B2E),
                ],
                stops: [0.45, 1.0],
              ),
            ),
          ),

          // ── Content ──
          FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              children: [
                // Top: logo + app name
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo circle
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Twende\nUganda',
                        style: TextStyle(
                          fontFamily: 'IBMPlexSerif',
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Your ultimate travel companion',
                        style: TextStyle(
                          fontFamily: 'CormorantGaramond',
                          fontSize: 18,
                          color: Color(0xCCFFFFFF),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),

                // ── Bottom nav bar preview ──
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _NavItem(icon: Icons.home_rounded, label: 'Home'),
                      _NavItem(icon: Icons.explore_rounded, label: 'Explore'),
                      _NavItem(icon: Icons.bookmark_rounded, label: 'Saved'),
                      _NavItem(icon: Icons.person_rounded, label: 'Profile'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF0F3B2E), size: 24),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'IBMPlexSerif',
            fontSize: 10,
            color: Color(0xFF0F3B2E),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}