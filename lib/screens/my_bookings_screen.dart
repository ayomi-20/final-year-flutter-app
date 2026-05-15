import 'package:flutter/material.dart';
import '../services/booking_service.dart';
import '../services/review_service.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  final BookingService _bookingService = BookingService();
  late TabController _tabController;

  List<dynamic> _allBookings = [];
  bool _loading = true;

  static const Color _green = Color(0xFF0F3B2E);
  static const Color _lightGreen = Color(0xFFE3EFE5);

  // Status groups for each tab
  static const _tabs = ['All', 'Upcoming', 'Completed', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final result = await _bookingService.getMyBookings();
    setState(() {
      _allBookings = (result['data'] as List?) ?? [];
      _loading = false;
    });
  }

  List<dynamic> _filteredBookings(int tabIndex) {
    switch (tabIndex) {
      case 1: // Upcoming
        return _allBookings
            .where((b) =>
                b['status'] == 'pending' || b['status'] == 'confirmed')
            .toList();
      case 2: // Completed
        return _allBookings
            .where((b) => b['status'] == 'completed')
            .toList();
      case 3: // Cancelled
        return _allBookings
            .where((b) =>
                (b['status'] as String? ?? '').contains('cancelled') ||
                b['status'] == 'rejected')
            .toList();
      default:
        return _allBookings;
    }
  }

  // ── Status chip style ──────────────────────────────────────────────────
  Color _statusColor(String status) {
    switch (status) {
      case 'confirmed':   return Colors.green;
      case 'pending':     return Colors.orange;
      case 'completed':   return Colors.blue;
      case 'in_progress': return Colors.purple;
      case 'rejected':    return Colors.red;
      default:            return Colors.grey; // cancelled
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pending':              return 'Pending';
      case 'confirmed':            return 'Confirmed';
      case 'in_progress':          return 'In Progress';
      case 'completed':            return 'Completed';
      case 'cancelled_by_tourist': return 'Cancelled';
      case 'cancelled_by_provider':return 'Cancelled by Provider';
      case 'rejected':             return 'Rejected';
      default:                     return status;
    }
  }

  // ── Cancel booking dialog ──────────────────────────────────────────────
  Future<void> _cancelBooking(Map<String, dynamic> booking) async {
    final reasonCtrl = TextEditingController();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Cancel Booking',
          style: TextStyle(
            fontFamily: 'IBMPlexSerif',
            fontWeight: FontWeight.w700,
            color: _green,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Are you sure you want to cancel this booking?',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: reasonCtrl,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Reason (optional)',
                filled: true,
                fillColor: _lightGreen,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cancel Booking',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final res = await _bookingService.cancelBooking(
      booking['id'],
      reason: reasonCtrl.text.trim().isNotEmpty ? reasonCtrl.text.trim() : null,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['message'] ?? 'Done')),
    );
    _load();
  }

  // ── Leave review dialog ────────────────────────────────────────────────
  Future<void> _leaveReview(Map<String, dynamic> booking) async {
    int rating = 5;
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    final reviewService = ReviewService();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
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
                  'Leave a Review',
                  style: TextStyle(
                    fontFamily: 'IBMPlexSerif',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  booking['service']?['title'] ?? '',
                  style: const TextStyle(
                      fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                // Star rating
                const Text('Rating',
                    style: TextStyle(
                        fontFamily: 'IBMPlexSerif',
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: _green)),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(
                    5,
                    (i) => GestureDetector(
                      onTap: () => setModal(() => rating = i + 1),
                      child: Icon(
                        Icons.star_rounded,
                        size: 36,
                        color: i < rating
                            ? Colors.amber
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Title
                const Text('Title (optional)',
                    style: TextStyle(
                        fontFamily: 'IBMPlexSerif',
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: _green)),
                const SizedBox(height: 6),
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    hintText: 'Summarise your experience',
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                    filled: true,
                    fillColor: _lightGreen,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),

                // Body
                const Text('Your Review',
                    style: TextStyle(
                        fontFamily: 'IBMPlexSerif',
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: _green)),
                const SizedBox(height: 6),
                TextField(
                  controller: bodyCtrl,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Tell others about your experience...',
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                    filled: true,
                    fillColor: _lightGreen,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      if (bodyCtrl.text.trim().length < 10) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Please write at least 10 characters.')),
                        );
                        return;
                      }
                      final res = await reviewService.submitReview({
                        'booking_id': booking['id'].toString(),
                        'rating': rating.toString(),
                        'title': titleCtrl.text.trim(),
                        'body': bodyCtrl.text.trim(),
                      });
                      if (!ctx.mounted) return;
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                res['message'] ?? 'Review submitted!')),
                      );
                      _load();
                    },
                    child: const Text(
                      'Submit Review',
                      style: TextStyle(
                        fontFamily: 'IBMPlexSerif',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
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
          'My Bookings',
          style: TextStyle(
            fontFamily: 'IBMPlexSerif',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _green,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: _green,
          unselectedLabelColor: Colors.grey,
          indicatorColor: _green,
          indicatorWeight: 2.5,
          labelStyle: const TextStyle(
            fontFamily: 'IBMPlexSerif',
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'IBMPlexSerif',
            fontSize: 13,
          ),
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _green))
          : TabBarView(
              controller: _tabController,
              children: List.generate(
                _tabs.length,
                (i) => _BookingList(
                  bookings: _filteredBookings(i),
                  onRefresh: _load,
                  onCancel: _cancelBooking,
                  onReview: _leaveReview,
                  statusColor: _statusColor,
                  statusLabel: _statusLabel,
                ),
              ),
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Booking List tab content
// ─────────────────────────────────────────────────────────────────────────────
class _BookingList extends StatelessWidget {
  final List<dynamic> bookings;
  final Future<void> Function() onRefresh;
  final Future<void> Function(Map<String, dynamic>) onCancel;
  final Future<void> Function(Map<String, dynamic>) onReview;
  final Color Function(String) statusColor;
  final String Function(String) statusLabel;

  static const Color _green = Color(0xFF0F3B2E);
  static const Color _lightGreen = Color(0xFFE3EFE5);

  const _BookingList({
    required this.bookings,
    required this.onRefresh,
    required this.onCancel,
    required this.onReview,
    required this.statusColor,
    required this.statusLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 56, color: _green.withOpacity(0.25)),
            const SizedBox(height: 16),
            const Text(
              'No bookings here',
              style: TextStyle(
                fontFamily: 'IBMPlexSerif',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _green,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your bookings will appear here',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: _green,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (_, i) {
          final booking = bookings[i] as Map<String, dynamic>;
          final service = booking['service'] as Map<String, dynamic>? ?? {};
          final status = booking['status'] as String? ?? '';
          final hasReview = booking['review'] != null;
          final canCancel =
              status == 'pending' || status == 'confirmed';
          final canReview = status == 'completed' && !hasReview;

          // Thumbnail
          final imgs = service['images'];
          final imageUrl = (imgs is List && imgs.isNotEmpty)
              ? 'http://10.0.2.2:8000/storage/${imgs[0]}'
              : '';

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
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
                // ── Service row ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 72,
                          height: 72,
                          child: imageUrl.isNotEmpty
                              ? Image.network(imageUrl, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _imgPlaceholder())
                              : _imgPlaceholder(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service['title'] as String? ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'IBMPlexSerif',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _green,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.grey, size: 12),
                                Expanded(
                                  child: Text(
                                    service['location'] as String? ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            // Status chip
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: statusColor(status).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                statusLabel(status),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: statusColor(status),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Booking details ──────────────────────────────────────
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _lightGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _DetailItem(
                        icon: Icons.confirmation_number_outlined,
                        label: 'Ref',
                        value: booking['booking_reference'] as String? ?? '',
                      ),
                      _DetailItem(
                        icon: Icons.calendar_today_outlined,
                        label: 'Date',
                        value: _formatDate(booking['booking_date'] as String?),
                      ),
                      _DetailItem(
                        icon: Icons.people_outline,
                        label: 'People',
                        value: '${booking['number_of_people'] ?? 1}',
                      ),
                      _DetailItem(
                        icon: Icons.attach_money,
                        label: 'Total',
                        value: 'UGX ${booking['total_amount'] ?? 0}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ── Actions ──────────────────────────────────────────────
                if (canCancel || canReview)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                    child: Row(
                      children: [
                        if (canCancel)
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () => onCancel(booking),
                              child: const Text('Cancel',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 13)),
                            ),
                          ),
                        if (canCancel && canReview)
                          const SizedBox(width: 10),
                        if (canReview)
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () => onReview(booking),
                              child: const Text('Leave Review',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13)),
                            ),
                          ),
                      ],
                    ),
                  )
                else
                  const SizedBox(height: 4),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _imgPlaceholder() {
    return Container(
      color: _lightGreen,
      child: const Center(
        child: Icon(Icons.image_outlined, color: _green, size: 28),
      ),
    );
  }

  String _formatDate(String? raw) {
    if (raw == null) return '—';
    try {
      final d = DateTime.parse(raw);
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return raw;
    }
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  static const Color _green = Color(0xFF0F3B2E);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: _green, size: 16),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 9, color: Colors.grey),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: _green,
          ),
        ),
      ],
    );
  }
}