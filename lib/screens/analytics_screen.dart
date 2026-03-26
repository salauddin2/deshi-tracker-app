import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/data_providers.dart';
import '../features/auth/providers/auth_provider.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});
  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  bool _loading = true;
  Map<String, dynamic> _analytics = {};
  Map<String, dynamic> _contactAnalytics = {};
  List<dynamic> _reviews = [];

  static const Color _navy = Color(0xFF1A3C5E);
  static const Color _accent = Color(0xFF2E6DA4);
  static const Color _bg = Color(0xFFF4F8FD);
  static const Color _green = Color(0xFF15803D);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAll();
    });
  }

  String get _businessId => ref.read(authProvider).business?.id ?? '';

  Future<void> _loadAll() async {
    if (_businessId.isEmpty) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    setState(() => _loading = true);
    await Future.wait([_loadAnalytics(), _loadContactAnalytics(), _loadReviews()]);
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _loadAnalytics() async {
    try {
      final res = await ref.read(businessRepositoryProvider).fetchAnalytics(_businessId);
      if (mounted) setState(() => _analytics = res);
    } catch (e) { debugPrint('Analytics load: $e'); }
  }

  Future<void> _loadContactAnalytics() async {
    try {
      final res = await ref.read(businessRepositoryProvider).fetchContactAnalytics(_businessId);
      if (mounted) setState(() => _contactAnalytics = res);
    } catch (e) { debugPrint('Contact analytics: $e'); }
  }

  Future<void> _loadReviews() async {
    try {
      final res = await ref.read(businessRepositoryProvider).getReviews(_businessId);
      if (mounted) setState(() => _reviews = res);
    } catch (e) { debugPrint('Reviews load: $e'); }
  }

  @override
  Widget build(BuildContext context) {
    final data = _analytics['data'] ?? _analytics;
    final contactData = _contactAnalytics['data'] ?? _contactAnalytics;
    final pageViews = data['totalVisits'] ?? data['pageViews'] ?? data['views'] ?? data['totalCount'] ?? 0;
    final contactClicks = contactData['totalClicks'] ?? contactData['clicks'] ?? data['contactClicks'] ?? contactData['lifetimeContactCount'] ?? 0;
    final totalReviews = _reviews.length;
    final avgRating = _reviews.isNotEmpty
        ? (_reviews.fold<double>(0, (sum, r) => sum + ((r['rating'] ?? 0) as num).toDouble()) / _reviews.length)
        : 0.0;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: Text('Business Analytics', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh_outlined), onPressed: _loadAll),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _navy))
          : RefreshIndicator(
              onRefresh: _loadAll,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats grid
                    _buildStatsGrid(pageViews, contactClicks, totalReviews, avgRating),
                    const SizedBox(height: 28),

                    // Visitor chart placeholder
                    _buildChartCard('Visitor Traffic', Icons.trending_up, _accent, data),
                    const SizedBox(height: 20),

                    // Contact clicks chart
                    _buildChartCard('Contact Clicks', Icons.touch_app_outlined, _green, contactData),
                    const SizedBox(height: 28),

                    // Reviews section
                    Row(
                      children: [
                        Text('Recent Reviews', style: GoogleFonts.jost(fontSize: 18, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text('$totalReviews total', style: GoogleFonts.jost(color: Colors.grey[500], fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ..._reviews.take(5).map((r) => _buildReviewCard(r)),
                    if (_reviews.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                        child: Column(
                          children: [
                            Icon(Icons.rate_review_outlined, size: 40, color: Colors.grey[300]),
                            const SizedBox(height: 8),
                            Text('No reviews yet', style: GoogleFonts.jost(color: Colors.grey[500])),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatsGrid(int pageViews, int contactClicks, int totalReviews, double avgRating) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.6,
      children: [
        _statCard('Page Views', '$pageViews', Icons.visibility_outlined, _accent),
        _statCard('Contact Clicks', '$contactClicks', Icons.touch_app_outlined, _green),
        _statCard('Total Reviews', '$totalReviews', Icons.star_outline, Colors.amber.shade700),
        _statCard('Avg Rating', avgRating > 0 ? avgRating.toStringAsFixed(1) : '—', Icons.star, Colors.orange),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, size: 18, color: color),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: GoogleFonts.jost(fontSize: 24, fontWeight: FontWeight.bold, color: _navy)),
              Text(label, style: GoogleFonts.jost(color: Colors.grey[500], fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(String title, IconData icon, Color color, Map<String, dynamic> chartData) {
    // Extract weekly/monthly data if available
    final weekly = chartData['monthly'] ?? chartData['monthlyCount'] ?? chartData['weekly'] ?? chartData['dailyVisits'] as List? ?? [];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 20),
          // Simple bar chart
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (i) {
                final value = (i < weekly.length ? (weekly[i] is Map ? weekly[i]['count'] ?? 0 : weekly[i]) : 0).toDouble();
                final maxVal = weekly.isNotEmpty
                    ? weekly.fold<double>(1, (max, v) => ((v is Map ? v['count'] ?? 0 : v) as num).toDouble() > max ? ((v is Map ? v['count'] ?? 0 : v) as num).toDouble() : max)
                    : 1.0;
                final height = maxVal > 0 ? (value / maxVal * 90).clamp(4.0, 90.0) : 4.0;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (value > 0) Text('${value.toInt()}', style: GoogleFonts.jost(fontSize: 9, color: Colors.grey[400])),
                        const SizedBox(height: 4),
                        Container(
                          height: height,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.7),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(days[i], style: GoogleFonts.jost(fontSize: 10, color: Colors.grey[500])),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(dynamic review) {
    final rating = (review['rating'] ?? 0) as num;
    final comment = review['comment'] ?? review['text'] ?? '';
    final authorName = review['user']?['name'] ?? review['authorName'] ?? 'Anonymous';
    final createdAt = review['createdAt'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: _navy.withValues(alpha: 0.08),
                radius: 16,
                child: Text(authorName[0].toUpperCase(), style: GoogleFonts.jost(color: _navy, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(authorName, style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 14))),
              Row(
                children: List.generate(5, (i) => Icon(
                  i < rating.toInt() ? Icons.star : Icons.star_border,
                  size: 14, color: Colors.amber,
                )),
              ),
            ],
          ),
          if (comment.toString().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(comment, style: GoogleFonts.jost(color: Colors.grey[600], fontSize: 13)),
          ],
          if (createdAt != null) ...[
            const SizedBox(height: 6),
            Text(_timeAgo(createdAt), style: GoogleFonts.jost(color: Colors.grey[400], fontSize: 11)),
          ],
        ],
      ),
    );
  }

  String _timeAgo(dynamic ts) {
    if (ts == null) return '';
    try {
      final dt = DateTime.parse(ts.toString()).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (_) { return ''; }
  }
}
