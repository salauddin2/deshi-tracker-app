import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../providers/data_providers.dart';
import '../features/auth/providers/auth_provider.dart';
import '../data/models/user.dart';

class BusinessDashboardScreen extends ConsumerStatefulWidget {
  const BusinessDashboardScreen({super.key});
  @override
  ConsumerState<BusinessDashboardScreen> createState() => _BusinessDashboardScreenState();
}

class _BusinessDashboardScreenState extends ConsumerState<BusinessDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _activeSection = 'Dashboard';

  // Live stats
  int _pageViews = 0;
  int _contactClicks = 0;
  int _totalReviews = 0;
  List<dynamic> _notifications = [];
  bool _statsLoading = true;

  static const Color _navy = Color(0xFF1A3C5E);
  static const Color _accent = Color(0xFF2E6DA4);
  static const Color _bg = Color(0xFFF4F8FD);
  static const Color _sky = Color(0xFFEEF5FC);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBusiness();
      _loadStats();
    });
  }

  Future<void> _loadBusiness() async {
    final authState = ref.read(authProvider);
    if (authState.business != null) return;
    final userId = authState.user?.id ?? '';
    if (userId.isEmpty) return;
    try {
      final biz = await ref.read(businessRepositoryProvider).getBusinesses(query: userId);
      if (biz.isNotEmpty && mounted) {
        ref.read(authProvider.notifier).setCurrentBusiness(biz.first);
      }
    } catch (e) { 
      debugPrint('Dashboard: failed to load business — $e'); 
    }
    // After business loads, load stats
    if (mounted) _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _statsLoading = true);
    final authState = ref.read(authProvider);
    final businessId = authState.business?.id ?? '';

    if (businessId.isEmpty) {
      if (mounted) setState(() => _statsLoading = false);
      return;
    }

    try {
      final bizRepo = ref.read(businessRepositoryProvider);
      final notifRepo = ref.read(notificationRepositoryProvider);

      // Load each branch safely
      final Future<Map<String, dynamic>> analyticsFuture = bizRepo.fetchAnalytics(businessId).catchError((e) {
        debugPrint('Analytics error: $e');
        return <String, dynamic>{};
      });
      final Future<Map<String, dynamic>> contactFuture = bizRepo.fetchContactAnalytics(businessId).catchError((e) {
        debugPrint('Contact analytics error: $e');
        return <String, dynamic>{};
      });
      final Future<List<dynamic>> reviewsFuture = bizRepo.getReviews(businessId).catchError((e) {
        debugPrint('Reviews error: $e');
        return <dynamic>[];
      });
      final Future<Map<String, dynamic>> notifsFuture = notifRepo.fetchNotifications().catchError((e) {
        debugPrint('Notifications error: $e');
        return <String, dynamic>{'data': [], 'unread_count': 0};
      });

      final results = await Future.wait<dynamic>([
        analyticsFuture,
        contactFuture,
        reviewsFuture,
        notifsFuture,
      ]);

      if (!mounted) return;
      setState(() {
        // Analytics
        final analyticsData = results[0] as Map<String, dynamic>;
        _pageViews = (analyticsData['totalVisits'] ?? analyticsData['pageViews'] ?? analyticsData['views'] ?? 0) as int;

        // Contact analytics
        final contactData = results[1] as Map<String, dynamic>;
        _contactClicks = (contactData['totalClicks'] ?? contactData['clicks'] ?? 0) as int;

        // Reviews
        final reviewsList = results[2] as List;
        _totalReviews = reviewsList.length;

        // Notifications
        final notifData = results[3] as Map<String, dynamic>;
        _notifications = notifData['data'] as List? ?? [];
        _statsLoading = false;
      });
    } catch (e) {
      debugPrint('Overall stats load error: $e');
      if (mounted) setState(() => _statsLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: isDesktop ? null : _buildSidebar(context, user, theme),
      body: Row(
        children: [
          if (isDesktop) _buildSidebar(context, user, theme),
          Expanded(
            child: Column(
              children: [
                _buildHeader(context, user, !isDesktop),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadStats,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(24),
                      child: _buildMainContent(context, user),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, User? user, ThemeData theme) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: _navy,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 20)],
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.track_changes, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Text('DesiTracker', style: GoogleFonts.jost(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Business name
          if (ref.read(authProvider).business != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.07), borderRadius: BorderRadius.circular(8)),
                child: Text(
                  ref.read(authProvider).business!.businessName,
                  style: GoogleFonts.jost(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                _sideLabel('MAIN'),
                _navItem(Icons.dashboard_outlined, 'Dashboard'),
                _navItem(Icons.person_outline, 'Edit Profile'),
                _navItem(Icons.business_outlined, 'My Business'),
                const SizedBox(height: 16),
                _sideLabel('COMMERCE'),
                _navItem(Icons.inventory_2_outlined, 'Products'),
                _navItem(Icons.local_offer_outlined, 'Day Offers'),
                _navItem(Icons.receipt_long_outlined, 'Orders'),
                _navItem(Icons.point_of_sale_outlined, 'Take Order'),
                const SizedBox(height: 16),
                _sideLabel('TEAM'),
                _navItem(Icons.people_outline, 'Staff Management'),
                _navItem(Icons.access_time_outlined, 'Attendance'),
                const SizedBox(height: 16),
                _sideLabel('INSIGHTS'),
                _navItem(Icons.bar_chart_outlined, 'Analytics'),
                _navItem(Icons.qr_code_scanner_outlined, 'Verify Member'),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                _navItem(Icons.swap_horiz_outlined, 'Member Mode', isModeSwitch: true),
                _navItem(Icons.logout, 'Log Out', isLogout: true),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _sideLabel(String text) => Padding(
    padding: const EdgeInsets.only(left: 16, bottom: 6, top: 4),
    child: Text(text, style: GoogleFonts.jost(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
  );

  Widget _navItem(IconData icon, String label, {bool isLogout = false, bool isModeSwitch = false}) {
    final isActive = _activeSection == label && !isLogout && !isModeSwitch;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            if (isLogout) { ref.read(authProvider.notifier).logout(); context.go('/login'); return; }
            if (isModeSwitch) { context.go('/member-profile'); return; }
            setState(() => _activeSection = label);
            if (_scaffoldKey.currentState?.isDrawerOpen ?? false) Navigator.pop(context);
            switch (label) {
              case 'Edit Profile': context.push('/owner/profile'); break;
              case 'My Business': context.push('/owner/edit-business'); break;
              case 'Products': context.push('/owner/products'); break;
              case 'Day Offers': context.push('/owner/offers'); break;
              case 'Orders': context.push('/owner/orders'); break;
              case 'Take Order': context.push('/owner/take-order'); break;
              case 'Staff Management': context.push('/owner/staff'); break;
              case 'Attendance': context.push('/owner/attendance'); break;
              case 'Analytics': context.push('/owner/analytics'); break;
              case 'Verify Member': context.push('/owner/verify-member'); break;
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: isActive
                ? BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: const Border(left: BorderSide(color: Colors.white, width: 3)),
                  )
                : null,
            child: Row(
              children: [
                Icon(icon, color: isActive ? Colors.white : (isLogout ? Colors.red.shade200 : Colors.white60), size: 19),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(label,
                    style: GoogleFonts.jost(
                      color: isActive ? Colors.white : (isLogout ? Colors.red.shade200 : Colors.white60),
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w500, fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, User? user, bool showMenu) {
    final unread = _notifications.where((n) => n['read'] != true).length;
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)],
      ),
      child: Row(
        children: [
          if (showMenu) IconButton(icon: const Icon(Icons.menu_rounded), onPressed: () => _scaffoldKey.currentState?.openDrawer()),
          const Spacer(),
          // Notifications
          Stack(
            children: [
              IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.grey), onPressed: () => context.push('/owner/notifications')),
              if (unread > 0) Positioned(
                right: 6, top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Text('$unread', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Text(user?.name ?? 'Admin', style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 17,
            backgroundColor: _sky,
            backgroundImage: user?.profilePicUrl != null ? NetworkImage(user!.profilePicUrl!) : null,
            child: user?.profilePicUrl == null ? Text(
              (user?.name ?? 'A')[0].toUpperCase(),
              style: GoogleFonts.jost(color: _navy, fontWeight: FontWeight.bold, fontSize: 14),
            ) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, User? user) {
    final businessName = ref.read(authProvider).business?.businessName ?? '';
    final slug = ref.read(authProvider).business?.slug ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Welcome header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back! 👋', style: GoogleFonts.jost(fontSize: 22, fontWeight: FontWeight.bold)),
                if (businessName.isNotEmpty)
                  Text(businessName, style: GoogleFonts.jost(color: _accent, fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
            if (slug.isNotEmpty)
              ElevatedButton.icon(
                onPressed: () => context.push('/business/$slug'),
                icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
                label: Text('View Listing', style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _navy, foregroundColor: Colors.white, elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 24),
        // Stats grid
        _statsLoading
            ? const SizedBox(height: 100, child: Center(child: CircularProgressIndicator(color: _navy)))
            : LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 700;
                  return Wrap(
                    spacing: 16, runSpacing: 16,
                    children: [
                      _buildStatCard('Page Views', '$_pageViews', Icons.visibility_outlined, _accent, isWide ? (constraints.maxWidth - 48) / 3 : constraints.maxWidth),
                      _buildStatCard('Contact Clicks', '$_contactClicks', Icons.touch_app_outlined, const Color(0xFF15803D), isWide ? (constraints.maxWidth - 48) / 3 : constraints.maxWidth),
                      _buildStatCard('Total Reviews', '$_totalReviews', Icons.star_outline, Colors.amber.shade700, isWide ? (constraints.maxWidth - 48) / 3 : constraints.maxWidth),
                    ],
                  );
                },
              ),
        const SizedBox(height: 32),
        // Quick actions
        Text('Quick Actions', style: GoogleFonts.jost(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12, runSpacing: 12,
          children: [
            _quickAction(Icons.add_box_outlined, 'Add Product', () => context.push('/owner/products')),
            _quickAction(Icons.shopping_cart_outlined, 'Take Order', () => context.push('/owner/take-order')),
            _quickAction(Icons.people_outline, 'Manage Staff', () => context.push('/owner/staff')),
            _quickAction(Icons.edit_outlined, 'Edit Business', () => context.push('/owner/edit-business')),
          ],
        ),
        const SizedBox(height: 32),
        // Recent notifications
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Activity', style: GoogleFonts.jost(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => context.push('/owner/notifications'),
              child: Text('View All', style: GoogleFonts.jost(color: _accent, fontWeight: FontWeight.w600, fontSize: 13)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: _notifications.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Icon(Icons.notifications_none, size: 36, color: Colors.grey[300]),
                      const SizedBox(height: 8),
                      Text('No recent activity', style: GoogleFonts.jost(color: Colors.grey[400])),
                    ],
                  ),
                )
              : Column(
                  children: _notifications.take(5).map((n) {
                    final isRead = n['read'] == true;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: isRead ? Colors.grey.shade50 : _sky,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  n['type'] == 'reservation' ? Icons.table_restaurant : Icons.shopping_bag_outlined,
                                  size: 16, color: isRead ? Colors.grey : _accent,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(n['title'] ?? '', style: GoogleFonts.jost(fontWeight: isRead ? FontWeight.w500 : FontWeight.bold, fontSize: 13)),
                                    Text(n['message'] ?? '', style: GoogleFonts.jost(color: Colors.grey[500], fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                              if (!isRead)
                                Container(width: 8, height: 8, decoration: BoxDecoration(color: _accent, shape: BoxShape.circle)),
                            ],
                          ),
                        ),
                        if (_notifications.indexOf(n) < (_notifications.length > 5 ? 4 : _notifications.length - 1))
                          Divider(color: Colors.grey[100]),
                      ],
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.jost(color: Colors.grey[500], fontSize: 12)),
              const SizedBox(height: 2),
              Text(value, style: GoogleFonts.jost(fontSize: 26, fontWeight: FontWeight.bold, color: _navy)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickAction(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: _accent),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.jost(fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
