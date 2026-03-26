import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/data_providers.dart';
import '../features/auth/providers/auth_provider.dart';
import '../core/providers/permission_provider.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  List<dynamic> _records = [];
  bool _loading = true;
  int _selectedFilter = 7; // days

  static const Color navy = Color(0xFF1A3C5E);
  static const Color bg = Color(0xFFF4F8FD);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecords();
    });
  }

  Future<void> _loadRecords() async {
    setState(() => _loading = true);
    try {
      final authState = ref.read(authProvider);
      final businessId = authState.business?.id ?? '';
      if (businessId.isEmpty) return;

      final from = DateTime.now().subtract(Duration(days: _selectedFilter));
      final fromStr = from.toIso8601String().split('T')[0];

      final data = await ref.read(staffRepositoryProvider).fetchAttendance(businessId, from: fromStr);
      if (mounted) {
        setState(() => _records = data['data'] ?? (data is List ? data : []));
      }
    } catch (e) {
      debugPrint('Load attendance: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text('Staff Attendance', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter row
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text('Show: ', style: GoogleFonts.jost(color: Colors.grey[600])),
                const SizedBox(width: 8),
                for (final days in [7, 15, 30])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text('Last $days days'),
                      selected: _selectedFilter == days,
                      selectedColor: navy,
                      labelStyle: GoogleFonts.jost(
                        color: _selectedFilter == days ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) {
                        setState(() => _selectedFilter = days);
                        _loadRecords();
                      },
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Summary
          if (!_loading)
            Container(
              color: const Color(0xFFEEF5FC),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _summaryCard('Total Records', '${_records.length}'),
                  _summaryCard('Open Sessions', '${_records.where((r) => r['clock_out'] == null).length}'),
                  _summaryCard('Flagged', '${_records.where((r) => r['flagged'] == true).length}'),
                ],
              ),
            ),
          // Table
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _records.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history, size: 64, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text('No attendance records', style: GoogleFonts.jost(fontSize: 18, color: Colors.grey[600])),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _records.length,
                        itemBuilder: (context, i) => _buildRecordCard(_records[i]),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCard(dynamic record) {
    final staff = record['staff_id'];
    final clockIn = _parseTime(record['clock_in']);
    final clockOut = record['clock_out'] != null ? _parseTime(record['clock_out']) : null;
    final flagged = record['flagged'] == true;
    final isOpen = clockOut == null;

    double? hours;
    if (clockOut != null) {
      hours = clockOut.difference(clockIn).inMinutes / 60.0;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: flagged ? Colors.orange.shade200 : (isOpen ? Colors.blue.shade200 : Colors.transparent),
        ),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: navy.withValues(alpha: 0.08),
                  child: Text(
                    ((staff is Map ? (staff['firstName'] ?? 'S') : 'S') as String)[0].toUpperCase(),
                    style: const TextStyle(color: navy, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        staff is Map ? '${staff['firstName'] ?? ''} ${staff['lastName'] ?? ''}' : 'Staff',
                        style: GoogleFonts.jost(fontWeight: FontWeight.bold),
                      ),
                      Text(staff is Map ? (staff['email'] ?? '') : '', style: GoogleFonts.jost(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                ),
                if (flagged)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(12)),
                    child: Text('FLAGGED', style: GoogleFonts.jost(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                  )
                else if (isOpen)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                    child: Text('ACTIVE', style: GoogleFonts.jost(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)),
                  )
                else
                  Text(
                    '${hours!.toStringAsFixed(1)}h',
                    style: GoogleFonts.jost(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _timeCell('Clock In', _formatDateTime(clockIn)),
                const SizedBox(width: 16),
                _timeCell('Clock Out', clockOut != null ? _formatDateTime(clockOut) : 'Still active'),
                const Spacer(),
                if (ref.watch(permissionProvider).canEditAttendance)
                  TextButton.icon(
                    onPressed: () => _showEditDialog(record),
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit'),
                    style: TextButton.styleFrom(foregroundColor: const Color(0xFF2E6DA4)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(dynamic record) {
    final clockInCtrl = TextEditingController(text: record['clock_in']?.toString().replaceAll('Z', '') ?? '');
    final clockOutCtrl = TextEditingController(text: record['clock_out']?.toString().replaceAll('Z', '') ?? '');
    final notesCtrl = TextEditingController(text: record['notes'] ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit Attendance Record', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: clockInCtrl, decoration: _inputDeco('Clock In (ISO 8601)')),
            const SizedBox(height: 12),
            TextField(controller: clockOutCtrl, decoration: _inputDeco('Clock Out (ISO 8601)')),
            const SizedBox(height: 12),
            TextField(controller: notesCtrl, decoration: _inputDeco('Notes')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final authState = ref.read(authProvider);
              final businessId = authState.business?.id ?? '';
              await ref.read(staffRepositoryProvider).editAttendanceRecord(record['_id'], businessId, {
                if (clockInCtrl.text.isNotEmpty) 'clock_in': clockInCtrl.text,
                if (clockOutCtrl.text.isNotEmpty) 'clock_out': clockOutCtrl.text,
                if (notesCtrl.text.isNotEmpty) 'notes': notesCtrl.text,
              });
              await _loadRecords();
            },
            style: ElevatedButton.styleFrom(backgroundColor: navy, foregroundColor: Colors.white),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _timeCell(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.jost(color: Colors.grey[500], fontSize: 11)),
        Text(value, style: GoogleFonts.jost(fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }

  Widget _summaryCard(String label, String value) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.jost(fontSize: 24, fontWeight: FontWeight.bold, color: navy)),
        Text(label, style: GoogleFonts.jost(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  DateTime _parseTime(dynamic s) {
    try { return DateTime.parse(s.toString()).toLocal(); } catch (_) { return DateTime.now(); }
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}  ${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}';
  }

  InputDecoration _inputDeco(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  );
}
