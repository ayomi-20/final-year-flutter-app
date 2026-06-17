import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';
import 'package:flutter/material.dart';
import 'authentication_screen.dart';
import 'provider_signup_screen.dart';
// import '../services/dashboard_service.dart';
import 'notifications_screen.dart';
import 'help_support_screen.dart';
import 'privacy_policy_screen.dart';
import 'about_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _auth = AuthService();
  Map<String, dynamic>? _user;
  bool _loading = true;
  String? _providerStatus;
  Map<String, dynamic>? _providerData;

  static const Color _green = Color(0xFF0F3B2E);
  static const Color _lightGreen = Color(0xFFE3EFE5);

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _auth.getUser();
    setState(() {
      _user = user;
    });

    // Fetch fresh user data including provider status from API
    try {
      final token = await _auth.getToken();
      if (token != null) {
        final response = await http.get(
          Uri.parse('${AuthService.baseUrl}/user'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode == 200) {
          final fresh = json.decode(response.body) as Map<String, dynamic>;
          await _auth.saveUser(fresh);
          setState(() {
            _user = fresh;
            _providerData = fresh['provider'] as Map<String, dynamic>?;
            _providerStatus = _providerData?['status'] as String?;
            _loading = false;
          });
          return;
        }
      }
    } catch (_) {}

    setState(() {
      _providerData = user?['provider'] as Map<String, dynamic>?;
      _providerStatus = _providerData?['status'] as String?;
      _loading = false;
    });
  }

  String get _fullName {
    if (_user == null) return 'User';
    return '${_user!['first_name'] ?? ''} ${_user!['last_name'] ?? ''}'.trim();
  }

  String get _initials {
    if (_user == null) return 'U';
    final f = (_user!['first_name'] as String? ?? '');
    final l = (_user!['last_name'] as String? ?? '');
    return '${f.isNotEmpty ? f[0] : ''}${l.isNotEmpty ? l[0] : ''}'
        .toUpperCase();
  }

  String get _roleLabel {
    final role = _user?['role'];
    if (role == null) return 'Tourist';
    // If role is an object with display_name
    if (role is Map) {
      return (role['display_name'] as String?) ?? 'Tourist';
    }
    // If role is a plain string
    if (role is String) {
      switch (role) {
        case 'provider':
          return 'Provider';
        case 'admin':
          return 'Admin';
        default:
          return 'Tourist';
      }
    }
    return 'Tourist';
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Log Out',
          style: TextStyle(
            fontFamily: 'IBMPlexSerif',
            fontWeight: FontWeight.w700,
            color: _green,
          ),
        ),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _green),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await _auth.logout();
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthenticationScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightGreen,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: _green),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontFamily: 'IBMPlexSerif',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _green,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _green))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // ── Avatar + name card ───────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 28,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: _green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: Text(
                            _initials,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _fullName,
                          style: const TextStyle(
                            fontFamily: 'IBMPlexSerif',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _user?['email'] as String? ?? '',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _roleLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Account section ──────────────────────────────────
                  _SectionCard(
                    title: 'Account',
                    items: [
                      _ProfileItem(
                        icon: Icons.person_outline,
                        label: 'Full Name',
                        value: _fullName,
                      ),
                      _ProfileItem(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: _user?['email'] as String? ?? '—',
                      ),
                      _ProfileItem(
                        icon: Icons.phone_outlined,
                        label: 'Contact',
                        value: '+256 ${_user?['contact'] ?? '—'}',
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Become a provider CTA (only for tourists) ────────
                  // Replace the existing CTA section with this:
                  if (_roleLabel == 'Tourist' ||
                      _providerStatus == 'rejected') ...[
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProviderSignupScreen(
                              existingProvider: _providerStatus == 'rejected'
                                  ? _providerData
                                  : null,
                            ),
                          ),
                        );
                        _loadUser();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _providerStatus == 'rejected'
                                ? [
                                    const Color(0xFF8B0000),
                                    const Color(0xFF5C0000),
                                  ]
                                : [
                                    const Color(0xFF1C5E4A),
                                    const Color(0xFF0F3B2E),
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _providerStatus == 'rejected'
                                    ? Icons.refresh
                                    : Icons.storefront_outlined,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _providerStatus == 'rejected'
                                        ? 'Reapply as Service Provider'
                                        : 'Become a Service Provider',
                                    style: const TextStyle(
                                      fontFamily: 'IBMPlexSerif',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    _providerStatus == 'rejected'
                                        ? 'Your previous application was rejected. Tap to update and resubmit.'
                                        : 'List your services and reach thousands of tourists',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white70,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Show pending status message
                  if (_providerStatus == 'pending') ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.hourglass_top,
                            color: Colors.orange.shade700,
                            size: 24,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Application Under Review',
                                  style: TextStyle(
                                    fontFamily: 'IBMPlexSerif',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.orange.shade700,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                const Text(
                                  'Your provider application is being reviewed by our team.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (_roleLabel == 'Tourist') const SizedBox(height: 16),

                  // ── App section ──────────────────────────────────────
                  _SectionCard(
                    title: 'App',
                    items: [
                      _TileItem(
                        icon: Icons.notifications_outlined,
                        label: 'Notifications',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotificationsScreen(),
                            ),
                          );
                        },
                      ),
                      _TileItem(
                        icon: Icons.help_outline,
                        label: 'Help & Support',
                        onTap: () {
                          print('HELP TAPPED');

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HelpSupportScreen(),
                            ),
                          );
                        },
                      ),
                      _TileItem(
                        icon: Icons.privacy_tip_outlined,
                        label: 'Privacy Policy',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PrivacyPolicyScreen(),
                            ),
                          );
                        },
                      ),
                      _TileItem(
                        icon: Icons.info_outline,
                        label: 'About Twende Uganda',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AboutScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Logout ───────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _logout,
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text(
                        'Log Out',
                        style: TextStyle(
                          fontFamily: 'IBMPlexSerif',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section card wrapper
// ─────────────────────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _SectionCard({required this.title, required this.items});

  static const Color _green = Color(0xFF0F3B2E);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'IBMPlexSerif',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.grey,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: items
                .asMap()
                .entries
                .map(
                  (e) => Column(
                    children: [
                      e.value,
                      if (e.key < items.length - 1)
                        const Divider(
                          height: 1,
                          indent: 54,
                          color: Color(0xFFF0F0F0),
                        ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Read-only info row
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  static const Color _green = Color(0xFF0F3B2E);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: _green, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'IBMPlexSerif',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _green,
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

// ─────────────────────────────────────────────────────────────────────────────
// Tappable tile row
// ─────────────────────────────────────────────────────────────────────────────
class _TileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _TileItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  static const Color _green = Color(0xFF0F3B2E);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Icon(icon, color: _green, size: 20),
      title: Text(
        label,
        style: const TextStyle(
          fontFamily: 'IBMPlexSerif',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _green,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
        size: 14,
      ),
      onTap: onTap,
    );
  }
}
