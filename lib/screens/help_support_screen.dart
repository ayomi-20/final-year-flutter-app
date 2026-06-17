import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const Color green = Color(0xFF0F3B2E);

  Widget _contactCard(IconData icon, String title, String value) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Icon(icon, color: const Color(0xFF0F3B2E)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(value),
          ],
        )
      ],
    ),
  );
}

Widget _faqItem(String q, String a) {
  return ExpansionTile(
    iconColor: const Color(0xFF0F3B2E),
    title: Text(q),
    children: [
      Padding(
        padding: const EdgeInsets.all(12),
        child: Text(a),
      )
    ],
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.white,
        foregroundColor: green,
      ),
      body: SingleChildScrollView(
  padding: const EdgeInsets.all(20),
  child: Column(
    children: [

      // ── HEADER ─────────────────────────────
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1C5E4A), Color(0xFF0F3B2E)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          children: [
            Icon(Icons.support_agent, color: Colors.white, size: 60),
            SizedBox(height: 10),
            Text(
              "Help & Support",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 20),

      // ── CONTACT CARDS ───────────────────────
      _contactCard(Icons.email_outlined, "Email Support",
          "tourismapp753@gmail.com"),

      _contactCard(Icons.phone_outlined, "Phone Support",
          "+256 780 798 798"),

      const SizedBox(height: 20),

      // ── FAQ SECTION ─────────────────────────
      const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Frequently Asked Questions",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      const SizedBox(height: 10),

      _faqItem("How do I make a booking?",
          "Browse a service and tap Book Now."),

      _faqItem("How do I cancel a booking?",
          "Open My Bookings and select Cancel."),

      _faqItem("How do I become a provider?",
          "Go to Profile → Become a Service Provider."),
    ],
  ),
),
    );
  }
}