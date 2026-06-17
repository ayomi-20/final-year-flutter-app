import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/dashboard_service.dart';
import 'service_detail_screen.dart';
import 'my_bookings_screen.dart';
import 'category_screen.dart';
import 'profile_screen.dart';
import '../constants.dart';
import '../services/notification_service.dart';
import 'notifications_screen.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DashboardService _dashboard = DashboardService();
  final AuthService _auth = AuthService();
  final TextEditingController _searchController = TextEditingController();
  final NotificationService _notifService = NotificationService();
  int _unreadCount = 0;

  Map<String, dynamic> _homeData = {};
  Map<String, dynamic>? _currentUser;
  bool _loading = true;
  String _searchQuery = '';

  static const Color _green = Color(0xFF0F3B2E);
  static const Color _lightGreen = Color(0xFFE3EFE5);

  @override
  void initState() {
    super.initState();
    _loadData();

    _loadUnreadCount();
    Timer.periodic(const Duration(seconds: 30), (_) => _loadUnreadCount());
  }

  Future<void> _loadUnreadCount() async {
  final count = await _notifService.getUnreadCount();
  if (mounted) setState(() => _unreadCount = count);
}

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final results = await Future.wait([
      _dashboard.getHomeData(),
      _auth.getUser(),
    ]);
    
    setState(() {
      _homeData  = results[0] as Map<String, dynamic>;
      _currentUser = results[1] as Map<String, dynamic>?;
      _loading   = false;
    });
  }

  List<dynamic> get _categories => _homeData['categories'] ?? [];
  List<dynamic> get _featured   => _homeData['featured']   ?? [];
  List<dynamic> get _topExp     => _homeData['top_experiences'] ?? [];
  List<dynamic> get _reviews    => _homeData['recent_reviews']  ?? [];

  String _getFirstImage(dynamic service) {
  final imgs = service['images'];
  if (imgs is List && imgs.isNotEmpty) {
    return '$kBaseUrl/images/${imgs[0]}';
  }
  return '';
}

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightGreen,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _green))
          : RefreshIndicator(
              onRefresh: _loadData,
              color: _green,
              child: CustomScrollView(
                slivers: [
                  _buildAppBar(),
                  SliverToBoxAdapter(child: _buildSearchBar()),
                  SliverToBoxAdapter(child: _buildCategories()),
                  SliverToBoxAdapter(child: _buildFeatured()),
                  SliverToBoxAdapter(child: _buildTopExperiences()),
                  SliverToBoxAdapter(child: _buildRecentReviews()),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                ],
              ),
            ),
    );
  }

  // ── App Bar ────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    final firstName = _currentUser?['first_name'] ?? 'Explorer';

    return SliverAppBar(
      expandedHeight: 100,
      floating: true,
      snap: true,
      elevation: 0,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Hello, $firstName 👋',
                      style: const TextStyle(
                        fontFamily: 'IBMPlexSerif',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _green,
                      ),
                    ),
                    const Text(
                      'Where to today?',
                      style: TextStyle(
                        fontFamily: 'IBMPlexSerif',
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Notifications bell
                    Stack(
  children: [
    IconButton(
      icon: const Icon(Icons.notifications_outlined, color: _green),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NotificationsScreen()),
        );
        _loadUnreadCount();
      },
    ),
    if (_unreadCount > 0)
      Positioned(
        right: 6,
        top: 6,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
          child: Text(
            _unreadCount > 9 ? '9+' : '$_unreadCount',
            style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
  ],
),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        );
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: _lightGreen,
                        child: Text(
                          (_currentUser?['first_name'] ?? 'U')[0].toUpperCase(),
                          style: const TextStyle(
                            color: _green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Search ─────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              onSubmitted: (_) => _doSearch(),
              style: const TextStyle(color: _green, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search destinations, experiences...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _doSearch,
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: _green,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.tune, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _doSearch() {
    if (_searchQuery.trim().isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryScreen(
          categorySlug: null,
          categoryName: 'Search: "$_searchQuery"',
          searchQuery: _searchQuery,
        ),
      ),
    );
  }

  // ── Categories ─────────────────────────────────────────────────────────
  Widget _buildCategories() {
    if (_categories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Categories', onSeeAll: null),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (_, i) {
              final cat = _categories[i];
const color = Color(0xFF0F3B2E);
              return GestureDetector(
             onTap: () => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => CategoryScreen(
      categorySlug: cat['slug'] as String?,
      categoryName: (cat['name'] ?? 'Category') as String,
    ),
  ),
),
                child: Container(
                width: 90,
                margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(_categoryIcon((cat['slug'] ?? '') as String), color: color, size: 28),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cat['name'] ?? '',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'IBMPlexSerif',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _green,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Featured Destinations ──────────────────────────────────────────────
  Widget _buildFeatured() {
    if (_featured.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Featured Destinations', onSeeAll: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CategoryScreen(
                categorySlug: null,
                categoryName: 'All Featured',
              ),
            ),
          );
        }),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _featured.length,
            itemBuilder: (_, i) {
              final service = _featured[i];
              return _FeaturedCard(
                service: service,
                imageUrl: _getFirstImage(service),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ServiceDetailScreen(
                      serviceSlug: service['slug'],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Top Experiences ────────────────────────────────────────────────────
  Widget _buildTopExperiences() {
    if (_topExp.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Top Experiences'),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _topExp.length,
          itemBuilder: (_, i) {
            final service = _topExp[i];
            return _ExperienceCard(
              service: service,
              imageUrl: _getFirstImage(service),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ServiceDetailScreen(serviceSlug: service['slug']),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ── Recent Reviews ─────────────────────────────────────────────────────
  Widget _buildRecentReviews() {
    if (_reviews.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('What Travelers Say'),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _reviews.length,
            itemBuilder: (_, i) {
              final review = _reviews[i];
              return _ReviewCard(review: review);
            },
          ),
        ),
      ],
    );
  }

  // ── Section header helper ──────────────────────────────────────────────
  Widget _sectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'IBMPlexSerif',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _green,
            ),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: const Text(
                'See all',
                style: TextStyle(
                  fontFamily: 'IBMPlexSerif',
                  fontSize: 13,
                  color: _green,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Icon mapper ────────────────────────────────────────────────────────
  IconData _categoryIcon(String icon) {
  switch (icon) {
    case 'accommodations':      return Icons.hotel_rounded;
    case 'vehicles-for-hire':   return Icons.directions_car_rounded;
    case 'restaurants':         return Icons.restaurant_rounded;
    case 'tour-guides':         return Icons.badge_rounded;
    case 'tourist-destinations': return Icons.landscape_rounded;
    default:                    return Icons.category_rounded;
  }
}
}

// ── Featured Service Card ──────────────────────────────────────────────────
class _FeaturedCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final String imageUrl;
  final VoidCallback onTap;

  const _FeaturedCard({
    required this.service,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholderImage(),
                    )
                  : _placeholderImage(),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.75)],
                    stops: const [0.45, 1.0],
                  ),
                ),
              ),

              // Info
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service['title'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'IBMPlexSerif',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white70, size: 12),
                          Expanded(
                            child: Text(
                              service['location'] ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'UGX ${service['price'] ?? 0}',
                            style: const TextStyle(
                              fontFamily: 'IBMPlexSerif',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF7BEB9C),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 12),
                              Text(
                                '${service['average_rating'] ?? 0}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Featured badge
              if (service['is_featured'] == true)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F3B2E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '⭐ Featured',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
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

  Widget _placeholderImage() {
    return Container(
      color: const Color(0xFFE3EFE5),
      child: const Center(
        child: Icon(Icons.image_outlined, color: Color(0xFF0F3B2E), size: 40),
      ),
    );
  }
}

// ── Experience Row Card ────────────────────────────────────────────────────
class _ExperienceCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final String imageUrl;
  final VoidCallback onTap;

  const _ExperienceCard({
    required this.service,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: SizedBox(
                width: 100,
                height: 100,
                child: imageUrl.isNotEmpty
                    ? Image.network(imageUrl, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFE3EFE5),
                          child: const Icon(Icons.image_outlined,
                              color: Color(0xFF0F3B2E)),
                        ))
                    : Container(
                        color: const Color(0xFFE3EFE5),
                        child: const Icon(Icons.image_outlined,
                            color: Color(0xFF0F3B2E)),
                      ),
              ),
            ),
            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      service['title'] ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'IBMPlexSerif',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F3B2E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.grey, size: 12),
                        Expanded(
                          child: Text(
                            service['location'] ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'UGX ${service['price'] ?? 0}',
                          style: const TextStyle(
                            fontFamily: 'IBMPlexSerif',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F3B2E),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 2),
                            Text(
                              '${service['average_rating'] ?? '0.0'}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0F3B2E),
                              ),
                            ),
                            Text(
                              ' (${service['total_reviews'] ?? 0})',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Review Card ────────────────────────────────────────────────────────────
class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final tourist = review['tourist'] ?? {};
    final name = '${tourist['first_name'] ?? ''} ${tourist['last_name'] ?? ''}'.trim();
    final service = review['service'] ?? {};

    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFFE3EFE5),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: Color(0xFF0F3B2E),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'IBMPlexSerif',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F3B2E),
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          Icons.star,
                          size: 11,
                          color: i < (review['rating'] ?? 0)
                              ? Colors.amber
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review['body'] ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.4),
          ),
          const Spacer(),
          Text(
            service['title'] ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF0F3B2E),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}