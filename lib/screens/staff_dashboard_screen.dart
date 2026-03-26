import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/data_providers.dart';
import '../features/auth/providers/auth_provider.dart';

class StaffDashboardScreen extends ConsumerStatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  ConsumerState<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends ConsumerState<StaffDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isClockedIn = false;
  dynamic _activeSession;
  bool _loading = true;
  List<dynamic> _myShifts = [];

  static const Color navy = Color(0xFF1A3C5E);
  static const Color bg = Color(0xFFF4F8FD);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSession();
      _loadShifts();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _checkSession() async {
    setState(() => _loading = true);
    try {
      final authState = ref.read(authProvider);
      final staffId = authState.user?.id ?? '';
      final businessId = authState.business?.id ?? ''; // Assuming business is where staff works
      if (staffId.isEmpty || businessId.isEmpty) return;

      final data = await ref.read(staffRepositoryProvider).getActiveSession(staffId, businessId);
      if (!mounted) return;
      setState(() {
        _activeSession = data['data'];
        _isClockedIn = _activeSession != null;
      });
    } catch (e) {
      debugPrint('Check session: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadShifts() async {
    try {
      final data = await ref.read(staffRepositoryProvider).fetchRotaShifts();
      if (mounted) setState(() => _myShifts = data);
    } catch (e) {
      debugPrint('Load shifts: $e');
    }
  }

  Future<void> _clockIn() async {
    final authState = ref.read(authProvider);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(staffRepositoryProvider).clockIn(authState.user?.id ?? '', authState.business?.id ?? '');
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text('✅ Clocked in successfully!'), backgroundColor: Colors.green),
        );
        await _checkSession();
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Clock in failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _clockOut() async {
    final authState = ref.read(authProvider);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(staffRepositoryProvider).clockOut(authState.user?.id ?? '', authState.business?.id ?? '');
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text('👋 Clocked out. Great work!'), backgroundColor: Colors.blue),
        );
        setState(() { _isClockedIn = false; _activeSession = null; });
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Clock out failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text('Staff Dashboard', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (!context.mounted) return;
              context.go('/');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: navy,
          unselectedLabelColor: Colors.grey,
          indicatorColor: navy,
          tabs: const [
            Tab(icon: Icon(Icons.access_time), text: 'Clock In/Out'),
            Tab(icon: Icon(Icons.calendar_today_outlined), text: 'My Schedule'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildClockTab(authState),
                _buildScheduleTab(),
              ],
            ),
    );
  }

  bool get _isForgottenSession {
    if (!_isClockedIn || _activeSession == null) return false;
    try {
      final clockIn = DateTime.parse(_activeSession['clock_in'].toString()).toLocal();
      return DateTime.now().difference(clockIn).inHours >= 12;
    } catch (_) { return false; }
  }

  Widget _buildClockTab(dynamic authState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Forgot to clock out warning
          if (_isForgottenSession)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.orange.shade200, width: 1.5),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Forgot to clock out?', style: GoogleFonts.jost(fontWeight: FontWeight.bold, color: Colors.orange.shade800)),
                        const SizedBox(height: 2),
                        Text('You\'ve been clocked in for over 12 hours. Please clock out if your shift is over.',
                          style: GoogleFonts.jost(fontSize: 12, color: Colors.orange.shade700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          // Greeting
          Text(
            'Hello, ${authState.user?.name ?? 'Staff Member'} 👋',
            style: GoogleFonts.jost(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _isClockedIn ? 'You are currently clocked in' : 'You are not clocked in',
            style: GoogleFonts.jost(color: _isClockedIn ? Colors.green : Colors.grey[600], fontSize: 16),
          ),
          const SizedBox(height: 40),
          // Clock status card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: _isClockedIn ? Colors.green.shade50 : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _isClockedIn ? Colors.green.shade200 : Colors.grey.shade200, width: 2),
            ),
            child: Column(
              children: [
                Icon(
                  _isClockedIn ? Icons.check_circle_outline : Icons.radio_button_unchecked,
                  size: 80,
                  color: _isClockedIn ? Colors.green : Colors.grey,
                ),
                const SizedBox(height: 16),
                if (_isClockedIn && _activeSession != null) ...[
                  Text(
                    'Clocked in at',
                    style: GoogleFonts.jost(color: Colors.grey[600]),
                  ),
                  Text(
                    _formatTime(_activeSession['clock_in']),
                    style: GoogleFonts.jost(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Action button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _isClockedIn ? _clockOut : _clockIn,
              icon: Icon(_isClockedIn ? Icons.logout : Icons.login),
              label: Text(
                _isClockedIn ? 'Clock Out' : 'Clock In',
                style: GoogleFonts.jost(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isClockedIn ? Colors.red.shade600 : Colors.green.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          ),
          if (_isClockedIn) ...[
            const SizedBox(height: 16),
            Text(
              'Remember to clock out at the end of your shift!',
              style: GoogleFonts.jost(color: Colors.orange[700], fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScheduleTab() {
    return _myShifts.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text('No shifts scheduled', style: GoogleFonts.jost(fontSize: 18, color: Colors.grey[600])),
                const SizedBox(height: 8),
                Text('Your manager will assign shifts soon', style: GoogleFonts.jost(color: Colors.grey[400])),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _myShifts.length,
            itemBuilder: (context, i) {
              final shift = _myShifts[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
                  border: Border.all(color: const Color(0xFF2E6DA4).withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: navy.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.schedule, color: navy, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_formatDate(shift['date']), style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(
                            '${shift['start_time'] ?? ''} — ${shift['end_time'] ?? ''}',
                            style: GoogleFonts.jost(color: const Color(0xFF2E6DA4), fontWeight: FontWeight.w600),
                          ),
                          if ((shift['notes'] ?? '').isNotEmpty)
                            Text(shift['notes'], style: GoogleFonts.jost(color: Colors.grey[600], fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }

  String _formatTime(dynamic timeStr) {
    if (timeStr == null) return '';
    try {
      final dt = DateTime.parse(timeStr.toString()).toLocal();
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return timeStr.toString();
    }
  }

  String _formatDate(dynamic dateStr) {
    if (dateStr == null) return '';
    try {
      final dt = DateTime.parse(dateStr.toString());
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return dateStr.toString();
    }
  }
}
