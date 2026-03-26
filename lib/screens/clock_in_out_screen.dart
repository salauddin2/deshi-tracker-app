import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/data_providers.dart';

class ClockInOutScreen extends ConsumerStatefulWidget {
  const ClockInOutScreen({super.key});
  @override
  ConsumerState<ClockInOutScreen> createState() => _ClockInOutScreenState();
}

class _ClockInOutScreenState extends ConsumerState<ClockInOutScreen> {
  static const _navy = Color(0xFF1A3C5E);
  static const _green = Color(0xFF15803D);
  bool _loading = true;
  bool _isClockedIn = false;
  bool _hasOpenSession = false;
  Map? _session;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    setState(() => _loading = true);
    try {
      final data = await ref.read(attendanceRepositoryProvider).getActiveSession();
      if (mounted) {
        setState(() {
          _hasOpenSession = data['hasOpenSession'] == true;
          _session = data['session'];
          _isClockedIn = _hasOpenSession;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _clockIn() async {
    setState(() => _loading = true);
    try {
      await ref.read(attendanceRepositoryProvider).clockIn();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Clocked in successfully!'), backgroundColor: Colors.green),
        );
        _checkSession();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _clockOut() async {
    setState(() => _loading = true);
    try {
      final result = await ref.read(attendanceRepositoryProvider).clockOut();
      if (mounted) {
        final hours = result['data']?['totalMinutes'] ?? 0;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Clocked out! Total: ${(hours / 60).toStringAsFixed(1)} hours'), backgroundColor: Colors.blue),
        );
        _checkSession();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FD),
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: Text('Clock In / Out', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Status Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _isClockedIn ? const Color(0xFFDCFCE7) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: _isClockedIn ? _green : Colors.grey.shade300),
                    ),
                    child: Column(children: [
                      Icon(
                        _isClockedIn ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: _isClockedIn ? _green : Colors.grey,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _isClockedIn ? 'You are Clocked In' : 'You are Clocked Out',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _isClockedIn ? _green : Colors.grey[700],
                        ),
                      ),
                      if (_isClockedIn && _session != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Since: ${_session!['clockIn'] ?? ''}',
                          style: GoogleFonts.inter(color: Colors.grey[600]),
                        ),
                      ],
                    ]),
                  ),
                  const SizedBox(height: 32),
                  // Clock In / Out Button
                  SizedBox(
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: _isClockedIn ? _clockOut : _clockIn,
                      icon: Icon(_isClockedIn ? Icons.logout : Icons.login),
                      label: Text(
                        _isClockedIn ? 'CLOCK OUT' : 'CLOCK IN',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isClockedIn ? Colors.red[600] : _green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                      ),
                    ),
                  ),
                  if (_hasOpenSession) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.amber.shade300),
                      ),
                      child: Row(children: [
                        const Icon(Icons.warning_amber, color: Colors.amber),
                        const SizedBox(width: 12),
                        Expanded(child: Text(
                          'You have an unclosed session. Please clock out properly.',
                          style: GoogleFonts.inter(color: Colors.orange[800]),
                        )),
                        TextButton(
                          onPressed: () async {
                            await ref.read(attendanceRepositoryProvider).endPreviousSession();
                            _checkSession();
                          },
                          child: const Text('End Session'),
                        ),
                      ]),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
