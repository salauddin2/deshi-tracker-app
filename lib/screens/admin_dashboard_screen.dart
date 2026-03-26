import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../providers/data_providers.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  static const _navy = Color(0xFF1A3C5E);
  Map _stats = {};
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final data = await ref.read(analyticsRepositoryProvider).getAdminStats();
      if (mounted) setState(() { _stats = data; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthly = (_stats['monthlyData'] as List?) ?? [];
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FD),
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: Text('Admin Dashboard', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Stats Row
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _statCard('Businesses', '${_stats['totalBusinessCount'] ?? 0}', Icons.store, Colors.blue),
                      _statCard('Users', '${_stats['totalUserCount'] ?? 0}', Icons.people, Colors.green),
                      _statCard('Countries', '${_stats['uniqueCountries'] ?? 0}', Icons.public, Colors.orange),
                      _statCard('Avg Rating', '${(_stats['averageRating'] ?? 0.0).toStringAsFixed(1)}', Icons.star, Colors.amber),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (monthly.isNotEmpty) ...[
                    Text('Monthly Growth', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: _navy)),
                    const SizedBox(height: 12),
                    Container(
                      height: 200,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
                      child: BarChart(BarChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(monthly.length, (i) => BarChartGroupData(
                          x: i,
                          barRods: [BarChartRodData(
                            toY: (monthly[i]['count'] as num?)?.toDouble() ?? 0,
                            color: _navy,
                            width: 16,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                          )],
                        )),
                      )),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text('Quick Actions', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: _navy)),
                  const SizedBox(height: 12),
                  Wrap(spacing: 12, runSpacing: 12, children: [
                    _actionBtn('Businesses', Icons.store, '/admin/businesses'),
                    _actionBtn('Users', Icons.people, '/admin/users'),
                    _actionBtn('Members', Icons.card_membership, '/admin/members'),
                    _actionBtn('Reviews', Icons.star, '/admin/reviews'),
                    _actionBtn('Categories', Icons.category, '/admin/categories'),
                    _actionBtn('Settings', Icons.settings, '/admin/settings'),
                  ]),
                ],
              ),
            ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon, color: color, size: 28),
      const SizedBox(height: 8),
      Text(value, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: _navy)),
      Text(label, style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
    ],
  );

  Widget _actionBtn(String label, IconData icon, String route) => InkWell(
    onTap: () => context.push(route),
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: _navy, size: 18),
        const SizedBox(width: 8),
        Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: _navy)),
      ]),
    ),
  );
}

