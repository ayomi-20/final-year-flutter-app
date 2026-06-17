import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const Color green = Color(0xFF0F3B2E);

  Widget _infoCard({
  required IconData icon,
  required String title,
  required String text,
}) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
        )
      ],
    ),
    child: Column(
      children: [
        Icon(icon, color: const Color(0xFF0F3B2E), size: 30),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black87),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Twende Uganda'),
        backgroundColor: Colors.white,
        foregroundColor: green,
      ),
      body: SingleChildScrollView(
  padding: const EdgeInsets.all(20),
  child: Column(
    children: [

      // ── HERO CARD ─────────────────────────────
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1C5E4A), Color(0xFF0F3B2E)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          children: [
            Icon(Icons.travel_explore, color: Colors.white, size: 60),
            SizedBox(height: 10),
            Text(
              'Twende Uganda',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'IBMPlexSerif',
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Discover Uganda with ease',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),

      const SizedBox(height: 20),

      // ── DESCRIPTION CARD ─────────────────────
      _infoCard(
        icon: Icons.flag,
        title: "Our Mission",
        text:
            "To connect travelers with trusted tourism service providers across Uganda.",
      ),

      const SizedBox(height: 12),

      _infoCard(
        icon: Icons.public,
        title: "What We Do",
        text:
            "We bring accommodations, tour guides, restaurants, transport and attractions into one platform.",
      ),

      const SizedBox(height: 20),

      // ── VERSION CARD ─────────────────────────
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, color: Color(0xFF0F3B2E)),
            SizedBox(width: 8),
            Text(
              'Version 1.0.0',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ],
  ),
),
    );
  }
}