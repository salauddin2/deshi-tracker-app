import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/data_providers.dart';
import '../features/auth/providers/auth_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  List<dynamic> _notifications = [];
  bool _loading = true;
  int _unread = 0;

  static const Color navy = Color(0xFF1A3C5E);
  static const Color bg = Color(0xFFF4F8FD);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final authState = ref.read(authProvider);
      final ownerId = authState.user?.id ?? '';
      if (ownerId.isEmpty) return;
      
      final data = await ref.read(notificationRepositoryProvider).fetchNotifications();
      if (mounted) {
        setState(() {
          _notifications = data['data'] as List? ?? [];
          _unread = int.tryParse(data['unread_count']?.toString() ?? '0') ?? 0;
        });
      }
    } catch (e) {
      debugPrint('Notifications load: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _markAllRead() async {
    final ownerId = ref.read(authProvider).user?.id ?? '';
    if (ownerId.isEmpty) return;
    await ref.read(notificationRepositoryProvider).markAllRead();
    await _load();
  }

  Future<void> _markRead(String id) async {
    final ownerId = ref.read(authProvider).user?.id ?? '';
    if (ownerId.isEmpty) return;
    await ref.read(notificationRepositoryProvider).markRead(id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Row(
          children: [
            Text('Notifications', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
            if (_unread > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                child: Text('$_unread', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (_unread > 0)
            TextButton(
              onPressed: _markAllRead,
              child: Text('Mark all read', style: GoogleFonts.jost(color: navy)),
            ),
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: _load,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_none, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text('No notifications yet', style: GoogleFonts.jost(fontSize: 18, color: Colors.grey[600])),
                      const SizedBox(height: 8),
                      Text('Reservations and new orders will appear here', style: GoogleFonts.jost(color: Colors.grey[400])),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notifications.length,
                    itemBuilder: (context, i) => _buildNotifCard(_notifications[i]),
                  ),
                ),
    );
  }

  Widget _buildNotifCard(dynamic notif) {
    final isRead = notif['read'] == true;
    final type = notif['type'] ?? 'order';
    final isReservation = type == 'reservation';

    return InkWell(
      onTap: () => _markRead(notif['_id']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : const Color(0xFFEEF5FC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isRead ? Colors.transparent : const Color(0xFF2E6DA4).withValues(alpha: 0.3)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isReservation ? Colors.purple.shade50 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isReservation ? Icons.table_restaurant_outlined : Icons.shopping_bag_outlined,
                  color: isReservation ? Colors.purple : Colors.green,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notif['title'] ?? '',
                            style: GoogleFonts.jost(fontWeight: isRead ? FontWeight.w500 : FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(color: Color(0xFF2E6DA4), shape: BoxShape.circle),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notif['message'] ?? '',
                      style: GoogleFonts.jost(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _timeAgo(notif['createdAt']),
                      style: GoogleFonts.jost(color: Colors.grey[400], fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _timeAgo(dynamic ts) {
    if (ts == null) return '';
    try {
      final dt = DateTime.parse(ts.toString()).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (_) { return ''; }
  }
}
