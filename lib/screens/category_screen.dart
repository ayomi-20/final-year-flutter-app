import 'package:flutter/material.dart';
import '../services/dashboard_service.dart';
import 'service_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String? categorySlug;
  final String categoryName;
  final String? searchQuery;

  const CategoryScreen({
    super.key,
    required this.categorySlug,
    required this.categoryName,
    this.searchQuery,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final DashboardService _dashboard = DashboardService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<dynamic> _services = [];
  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  String _sort = 'popular';
  String _searchQuery = '';

  static const Color _green = Color(0xFF0F3B2E);
  static const Color _lightGreen = Color(0xFFE3EFE5);

  final List<Map<String, String>> _sortOptions = [
    {'value': 'popular',    'label': 'Most Popular'},
    {'value': 'rating',     'label': 'Top Rated'},
    {'value': 'price_asc',  'label': 'Price: Low to High'},
    {'value': 'price_desc', 'label': 'Price: High to Low'},
    {'value': 'newest',     'label': 'Newest'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.searchQuery != null) {
      _searchQuery = widget.searchQuery!;
      _searchController.text = _searchQuery;
    }
    _load();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_loadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _load({bool reset = false}) async {
    setState(() {
      _loading = true;
      if (reset) {
        _services = [];
        _page = 1;
        _hasMore = true;
      }
    });

    final result = await _dashboard.getServices(
      category: widget.categorySlug,
      search: _searchQuery.isNotEmpty ? _searchQuery : null,
      sort: _sort,
      page: 1,
    );

    final items = (result['data'] as List?) ?? [];
    final lastPage = (result['last_page'] as num?)?.toInt() ?? 1;

    setState(() {
      _services = items;
      _page = 1;
      _hasMore = 1 < lastPage;
      _loading = false;
    });
  }

  Future<void> _loadMore() async {
    if (_loadingMore || !_hasMore) return;
    setState(() => _loadingMore = true);

    final nextPage = _page + 1;
    final result = await _dashboard.getServices(
      category: widget.categorySlug,
      search: _searchQuery.isNotEmpty ? _searchQuery : null,
      sort: _sort,
      page: nextPage,
    );

    final items = (result['data'] as List?) ?? [];
    final lastPage = (result['last_page'] as num?)?.toInt() ?? 1;

    setState(() {
      _services.addAll(items);
      _page = nextPage;
      _hasMore = nextPage < lastPage;
      _loadingMore = false;
    });
  }

  String _getFirstImage(dynamic service) {
    final imgs = service['images'];
    if (imgs is List && imgs.isNotEmpty) {
      return 'http://10.0.2.2:8000/storage/${imgs[0]}';
    }
    return '';
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
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            fontFamily: 'IBMPlexSerif',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _green,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: _showSortSheet,
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _lightGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.sort, color: _green, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    _sortOptions.firstWhere(
                        (s) => s['value'] == _sort,
                        orElse: () => _sortOptions.first)['label']!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: _green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search bar ────────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              onSubmitted: (_) => _load(reset: true),
              style: const TextStyle(color: _green, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search in ${widget.categoryName}...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                          _load(reset: true);
                        },
                        child: const Icon(Icons.clear, color: Colors.grey, size: 18),
                      )
                    : null,
                filled: true,
                fillColor: _lightGreen,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // ── Service list ──────────────────────────────────────────────
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: _green))
                : _services.isEmpty
                    ? _buildEmpty()
                    : RefreshIndicator(
                        onRefresh: () => _load(reset: true),
                        color: _green,
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _services.length + (_loadingMore ? 1 : 0),
                          itemBuilder: (_, i) {
                            if (i == _services.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(color: _green),
                                ),
                              );
                            }
                            final service = _services[i];
                            return _ServiceListCard(
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
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: _green.withOpacity(0.25)),
          const SizedBox(height: 16),
          const Text(
            'No services found',
            style: TextStyle(
              fontFamily: 'IBMPlexSerif',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _green,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your search or filters',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              _searchController.clear();
              setState(() => _searchQuery = '');
              _load(reset: true);
            },
            child: const Text('Clear search',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sort by',
                style: TextStyle(
                  fontFamily: 'IBMPlexSerif',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _green,
                ),
              ),
              const SizedBox(height: 8),
              ..._sortOptions.map(
                (option) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Radio<String>(
                    value: option['value']!,
                    groupValue: _sort,
                    activeColor: _green,
                    onChanged: (v) {
                      setState(() => _sort = v!);
                      Navigator.pop(context);
                      _load(reset: true);
                    },
                  ),
                  title: Text(
                    option['label']!,
                    style: TextStyle(
                      fontFamily: 'IBMPlexSerif',
                      fontSize: 14,
                      fontWeight: _sort == option['value']
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: _sort == option['value']
                          ? _green
                          : Colors.black87,
                    ),
                  ),
                  onTap: () {
                    setState(() => _sort = option['value']!);
                    Navigator.pop(context);
                    _load(reset: true);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Service List Card
// ─────────────────────────────────────────────────────────────────────────────
class _ServiceListCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final String imageUrl;
  final VoidCallback onTap;

  const _ServiceListCard({
    required this.service,
    required this.imageUrl,
    required this.onTap,
  });

  static const Color _green = Color(0xFF0F3B2E);

  @override
  Widget build(BuildContext context) {
    final category = service['category'] as Map<String, dynamic>? ?? {};

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ───────────────────────────────────────────────────
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              child: SizedBox(
                height: 160,
                width: double.infinity,
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
            ),

            // ── Details ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  if ((category['name'] as String?)?.isNotEmpty == true)
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3EFE5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category['name'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          color: _green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                  Text(
                    service['title'] as String? ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'IBMPlexSerif',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _green,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.grey, size: 13),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          '${service['location'] ?? ''}, ${service['region'] ?? ''}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Price + rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'UGX ${service['price'] ?? 0}',
                            style: const TextStyle(
                              fontFamily: 'IBMPlexSerif',
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: _green,
                            ),
                          ),
                          Text(
                            service['price_unit'] as String? ?? 'per person',
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.amber, size: 15),
                          const SizedBox(width: 3),
                          Text(
                            '${service['average_rating'] ?? '0.0'}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _green,
                            ),
                          ),
                          Text(
                            '  (${service['total_reviews'] ?? 0})',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFE3EFE5),
      child: const Center(
        child: Icon(Icons.image_outlined, color: _green, size: 40),
      ),
    );
  }
}