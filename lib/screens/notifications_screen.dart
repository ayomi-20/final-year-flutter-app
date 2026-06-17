import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _service = NotificationService();
  List<dynamic> _notifications = [];
  bool _loading = true;
  String _filter = 'all';

  static const Color _green = Color(0xFF0F3B2E);
  static const Color _lightGreen = Color(0xFFE3EFE5);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final res = await _service.getNotifications(filter: _filter);
    setState(() {
      _notifications = res['data'] ?? [];
      _loading = false;
    });
  }

  Future<void> _onTapNotification(Map<String, dynamic> n) async {
    if (n['is_read'] == false) {
      await _service.markRead(n['id']);
      _load();
    }
  }

  Future<void> _onDelete(int id) async {
    await _service.deleteNotification(id);
    _load();
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'welcome':       return Icons.celebration_outlined;
      case 'new_user':      return Icons.person_add_outlined;
      case 'booking':       return Icons.calendar_today_outlined;
      case 'review':        return Icons.star_outline;
      case 'provider':      return Icons.storefront_outlined;
      case 'service':       return Icons.map_outlined;
      default:               return Icons.notifications_outlined;
    }
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
          'Notifications',
          style: TextStyle(
            fontFamily: 'IBMPlexSerif',
            fontWeight: FontWeight.w700,
            color: _green,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _service.markAllRead();
              _load();
            },
            child: const Text('Mark all read', style: TextStyle(color: _green)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _filterChip('All', 'all'),
                const SizedBox(width: 8),
                _filterChip('Unread', 'unread'),
                const SizedBox(width: 8),
                _filterChip('Read', 'read'),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: _green))
                : _notifications.isEmpty
                    ? const Center(
                        child: Text('No notifications yet',
                            style: TextStyle(color: Colors.grey)))
                    : RefreshIndicator(
                        onRefresh: _load,
                        color: _green,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _notifications.length,
                          itemBuilder: (_, i) {
                            final n = _notifications[i];
                            final bool isRead = n['is_read'] == true;
                            return Dismissible(
                              key: Key(n['id'].toString()),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) => _onDelete(n['id']),
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              child: GestureDetector(
                                onTap: () => _onTapNotification(n),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: isRead
                                        ? null
                                        : Border.all(color: _green.withOpacity(0.3)),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: isRead
                                              ? Colors.grey.shade100
                                              : _lightGreen,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          _iconForType(n['type'] ?? ''),
                                          color: isRead ? Colors.grey : _green,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              n['title'] ?? '',
                                              style: TextStyle(
                                                fontFamily: 'IBMPlexSerif',
                                                fontWeight: isRead
                                                    ? FontWeight.w500
                                                    : FontWeight.w700,
                                                fontSize: 14,
                                                color: _green,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              n['body'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (!isRead)
                                        Container(
                                          width: 8,
                                          height: 8,
                                          margin: const EdgeInsets.only(top: 4),
                                          decoration: const BoxDecoration(
                                            color: _green,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
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

  Widget _filterChip(String label, String value) {
    final bool selected = _filter == value;
    return GestureDetector(
      onTap: () {
        setState(() => _filter = value);
        _load();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? _green : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? _green : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}