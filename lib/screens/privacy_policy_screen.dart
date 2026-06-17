import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const Color green = Color(0xFF0F3B2E);

  Widget _policyCard(IconData icon, String title, String text) {
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(text),
            ],
          ),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.white,
        foregroundColor: green,
      ),
      body: SingleChildScrollView(
  padding: const EdgeInsets.all(20),
  child: Column(
    children: [

      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1C5E4A), Color(0xFF0F3B2E)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.verified_user,
            color: Colors.white, size: 60),
      ),

      const SizedBox(height: 20),

      _policyCard(
        Icons.person_outline,
        "Information We Collect",
        "Name, email address and contact number.",
      ),

      _policyCard(
        Icons.settings,
        "How We Use Data",
        "To manage bookings and improve services.",
      ),

      _policyCard(
        Icons.security,
        "Data Protection",
        "We do not sell your personal data.",
      ),

      _policyCard(
        Icons.check_circle,
        "Consent",
        "Using the app means you accept this policy.",
      ),
    ],
  ),
),
    );
  }
}