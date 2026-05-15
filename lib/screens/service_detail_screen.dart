import 'package:flutter/material.dart';
import '../services/dashboard_service.dart';
import '../services/auth_service.dart';
import './booking_screen.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String serviceSlug;
  const ServiceDetailScreen({super.key, required this.serviceSlug});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final DashboardService _dashboard = DashboardService();
  final AuthService _auth = AuthService();

  Map<String, dynamic>? _service;
  bool _loading = true;
  int _currentImageIndex = 0;

  static const Color _green = Color(0xFF0F3B2E);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await _dashboard.getService(widget.serviceSlug);
    setState(() { _service = s; _loading = false; });
  }

  List<dynamic> get _images => _service?['images'] ?? [];
  List<dynamic> get _reviews => _service?['reviews'] ?? [];
  List<dynamic> get _amenities => _service?['amenities'] ?? [];

  String _imageUrl(String path) => 'http://10.0.2.2:8000/storage/$path';

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFE3EFE5),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF0F3B2E))),
      );
    }

    if (_service == null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
        body: const Center(child: Text('Service not found.')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildImageCarousel(),
          SliverToBoxAdapter(child: _buildBody()),
        ],
      ),
      bottomNavigationBar: _buildBookButton(),
    );
  }

  Widget _buildImageCarousel() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: _green,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: _green),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: _images.isEmpty
            ? Container(
                color: const Color(0xFFE3EFE5),
                child: const Center(
                  child: Icon(Icons.image_outlined, color: _green, size: 60),
                ),
              )
            : Stack(
                children: [
                  PageView.builder(
                    itemCount: _images.length,
                    onPageChanged: (i) => setState(() => _currentImageIndex = i),
                    itemBuilder: (_, i) => Image.network(
                      _imageUrl(_images[i]),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFE3EFE5),
                        child: const Center(
                          child: Icon(Icons.image_outlined, color: _green, size: 60),
                        ),
                      ),
                    ),
                  ),
                  if (_images.length > 1)
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _images.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: i == _currentImageIndex ? 20 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: i == _currentImageIndex
                                  ? Colors.white
                                  : Colors.white54,
                              borderRadius: BorderRadius.circular(3),
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

  Widget _buildBody() {
    final category = _service!['category'] ?? {};
    final provider = _service!['provider'] ?? {};
    final provProfile = provider['provider_profile'] ?? {};

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE3EFE5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              category['name'] ?? '',
              style: const TextStyle(
                fontSize: 12,
                color: _green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Title
          Text(
            _service!['title'] ?? '',
            style: const TextStyle(
              fontFamily: 'IBMPlexSerif',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: _green,
            ),
          ),
          const SizedBox(height: 8),

          // Location & rating row
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.grey, size: 16),
              Expanded(
                child: Text(
                  '${_service!['location'] ?? ''}, ${_service!['region'] ?? ''}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
              const Icon(Icons.star, color: Colors.amber, size: 16),
              Text(
                ' ${_service!['average_rating'] ?? 0} (${_service!['total_reviews'] ?? 0} reviews)',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Price
          Row(
            children: [
              Text(
                'UGX ${_service!['price'] ?? 0}',
                style: const TextStyle(
                  fontFamily: 'IBMPlexSerif',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: _green,
                ),
              ),
              Text(
                ' / ${_service!['price_unit'] ?? 'per person'}',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),

          const Divider(height: 30),

          // Description
          const Text(
            'About',
            style: TextStyle(
              fontFamily: 'IBMPlexSerif',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _service!['description'] ?? '',
            style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.6),
          ),

          // Amenities
          if (_amenities.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text(
              'What\'s Included',
              style: TextStyle(
                fontFamily: 'IBMPlexSerif',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _green,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _amenities.map<Widget>((a) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3EFE5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  a.toString(),
                  style: const TextStyle(fontSize: 12, color: _green),
                ),
              )).toList(),
            ),
          ],

          // Provider info
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          const Text(
            'Service Provider',
            style: TextStyle(
              fontFamily: 'IBMPlexSerif',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _green,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFE3EFE5),
                child: Text(
                  (provider['first_name'] ?? 'P')[0].toUpperCase(),
                  style: const TextStyle(
                    color: _green,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provProfile['business_name'] ??
                        '${provider['first_name'] ?? ''} ${provider['last_name'] ?? ''}'.trim(),
                    style: const TextStyle(
                      fontFamily: 'IBMPlexSerif',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _green,
                    ),
                  ),
                  if (provProfile['verification_status'] == 'verified')
                    const Row(
                      children: [
                        Icon(Icons.verified, color: Colors.blue, size: 14),
                        SizedBox(width: 4),
                        Text('Verified Provider',
                            style: TextStyle(fontSize: 12, color: Colors.blue)),
                      ],
                    ),
                ],
              ),
            ],
          ),

          // Reviews section
          if (_reviews.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Reviews',
                  style: TextStyle(
                    fontFamily: 'IBMPlexSerif',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _green,
                  ),
                ),
                Text(
                  '${_service!['total_reviews'] ?? 0} total',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._reviews.map((r) => _ReviewTile(review: r)),
          ],

          const SizedBox(height: 80), // Space for bottom button
        ],
      ),
    );
  }

  Widget _buildBookButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: () async {
            final isLoggedIn = await _auth.isLoggedIn();
            if (!mounted) return;

            if (!isLoggedIn) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please log in to book this service.')),
              );
              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookingScreen(service: _service!),
              ),
            );
          },
          child: const Text(
            'Book Now',
            style: TextStyle(
              fontFamily: 'IBMPlexSerif',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final Map<String, dynamic> review;
  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    final tourist = review['tourist'] ?? {};
    final name = '${tourist['first_name'] ?? ''} ${tourist['last_name'] ?? ''}'.trim();

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
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
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'IBMPlexSerif',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F3B2E),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        Icons.star,
                        size: 12,
                        color: i < (review['rating'] ?? 0)
                            ? Colors.amber
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (review['title'] != null)
            Text(
              review['title'],
              style: const TextStyle(
                fontFamily: 'IBMPlexSerif',
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Color(0xFF0F3B2E),
              ),
            ),
          Text(
            review['body'] ?? '',
            style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.5),
          ),
          const Divider(height: 20),
        ],
      ),
    );
  }
}