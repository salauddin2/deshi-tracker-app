import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../providers/data_providers.dart';

class MemberVerificationScreen extends ConsumerStatefulWidget {
  const MemberVerificationScreen({super.key});
  @override
  ConsumerState<MemberVerificationScreen> createState() => _MemberVerificationScreenState();
}

class _MemberVerificationScreenState extends ConsumerState<MemberVerificationScreen> {
  bool _isScanning = true;
  bool _isLoading = false;
  dynamic _memberData;
  String? _error;

  final _serialCtrl = TextEditingController();
  final MobileScannerController _scannerController = MobileScannerController();

  static const Color _navy = Color(0xFF1A3C5E);
  static const Color _accent = Color(0xFF2E6DA4);
  static const Color _green = Color(0xFF15803D);

  @override
  void dispose() { 
    _serialCtrl.dispose(); 
    _scannerController.dispose();
    super.dispose(); 
  }

  Future<void> _lookupMember(String serial) async {
    if (serial.isEmpty) return;
    setState(() { _isLoading = true; _error = null; _isScanning = false; });
    try {
      final data = await ref.read(staffRepositoryProvider).lookupMember(serial);
      if (!mounted) return;
      
      setState(() {
        _memberData = data['data'] ?? data;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Member lookup failed: $e';
          _memberData = null;
          _isLoading = false;
        });
      }
    }
  }

  void _resetScanner() {
    setState(() { _isScanning = true; _memberData = null; _error = null; _serialCtrl.clear(); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1929),
      appBar: AppBar(
        title: Text('Member Verification', style: GoogleFonts.jost(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent, elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _isScanning
              ? _buildScannerMode()
              : _buildResultMode(),
    );
  }

  Widget _buildScannerMode() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // QR Scanner area (simulated — tap to look up)
            Container(
              width: 280, height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _accent.withValues(alpha: 0.5), width: 2),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                   MobileScanner(
                    controller: _scannerController,
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      if (barcodes.isNotEmpty) {
                        final String? code = barcodes.first.rawValue;
                        if (code != null) {
                          _lookupMember(code);
                        }
                      }
                    },
                  ),
                  // Overlay/Brackets
                  Positioned(top: 0, left: 0, child: _corner(true, true)),
                  Positioned(top: 0, right: 0, child: _corner(true, false)),
                  Positioned(bottom: 0, left: 0, child: _corner(false, true)),
                  Positioned(bottom: 0, right: 0, child: _corner(false, false)),
                  
                  // Scanning line animation
                  Center(
                    child: Container(
                      width: 240,
                      height: 2,
                      color: _accent.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Divider
            Row(
              children: [
                Expanded(child: Divider(color: Colors.white24)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('OR ENTER SERIAL', style: GoogleFonts.jost(color: Colors.white38, fontSize: 11, letterSpacing: 2)),
                ),
                Expanded(child: Divider(color: Colors.white24)),
              ],
            ),
            const SizedBox(height: 24),
            // Manual serial input
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _serialCtrl,
                      style: GoogleFonts.jost(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'e.g. DT-928421',
                        hintStyle: GoogleFonts.jost(color: Colors.white30),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onSubmitted: _lookupMember,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(2),
                    child: ElevatedButton(
                      onPressed: () => _lookupMember(_serialCtrl.text.trim()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        elevation: 0,
                      ),
                      child: Text('VERIFY', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultMode() {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cancel_outlined, color: Colors.red.shade400, size: 72),
                const SizedBox(height: 20),
                Text('Not Found', style: GoogleFonts.jost(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(_error!, textAlign: TextAlign.center, style: GoogleFonts.jost(color: Colors.grey[600], fontSize: 14)),
                const SizedBox(height: 28),
                _actionButton('TRY AGAIN', Icons.refresh, _resetScanner),
              ],
            ),
          ),
        ),
      );
    }

    final member = _memberData;
    final name = member?['name'] ?? '${member?['firstName'] ?? ''} ${member?['lastName'] ?? ''}'.trim();
    final serial = member?['serialNumber'] ?? member?['serial'] ?? member?['memberSerial'] ?? '';
    final email = member?['email'] ?? '';
    final phone = member?['phone'] ?? '';
    final status = member?['status'] ?? 'active';
    final memberSince = member?['createdAt'] ?? member?['joinedAt'];
    final isActive = status.toString().toLowerCase() == 'active';

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Status icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isActive ? _green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isActive ? Icons.check_circle : Icons.warning_amber_rounded,
                  color: isActive ? _green : Colors.red,
                  size: 56,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isActive ? 'Verified Member' : 'Inactive Member',
                style: GoogleFonts.jost(fontSize: 22, fontWeight: FontWeight.bold, color: isActive ? _green : Colors.red),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive ? _green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(status.toString().toUpperCase(), style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 11, color: isActive ? _green : Colors.red)),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              // Member info
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: _navy.withValues(alpha: 0.08),
                    radius: 24,
                    child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'M', style: GoogleFonts.jost(color: _navy, fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name.isNotEmpty ? name : 'Member', style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('ID: $serial', style: GoogleFonts.jost(color: Colors.grey[500], fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (email.toString().isNotEmpty) _infoRow(Icons.email_outlined, email.toString()),
              if (phone.toString().isNotEmpty) _infoRow(Icons.phone_outlined, phone.toString()),
              if (memberSince != null) _infoRow(Icons.calendar_today_outlined, 'Since ${_fmtDate(memberSince)}'),
              const SizedBox(height: 24),
              _actionButton('SCAN NEXT', Icons.qr_code_scanner, _resetScanner),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Icon(icon, size: 16, color: Colors.grey[400]),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: GoogleFonts.jost(fontSize: 13, color: Colors.grey[600]))),
    ]),
  );

  Widget _actionButton(String label, IconData icon, VoidCallback onTap) => SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label, style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: _navy, foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    ),
  );

  Widget _corner(bool isTop, bool isLeft) => SizedBox(
    width: 30, height: 30,
    child: CustomPaint(painter: _CornerPainter(isTop: isTop, isLeft: isLeft, color: _accent)),
  );

  String _fmtDate(dynamic s) {
    if (s == null) return '';
    try { final d = DateTime.parse(s.toString()); return '${d.day}/${d.month}/${d.year}'; } catch (_) { return s.toString(); }
  }
}

class _CornerPainter extends CustomPainter {
  final bool isTop, isLeft;
  final Color color;
  _CornerPainter({required this.isTop, required this.isLeft, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final path = Path();
    if (isTop && isLeft) {
      path.moveTo(0, size.height); path.lineTo(0, 0); path.lineTo(size.width, 0);
    } else if (isTop && !isLeft) {
      path.moveTo(0, 0); path.lineTo(size.width, 0); path.lineTo(size.width, size.height);
    } else if (!isTop && isLeft) {
      path.moveTo(0, 0); path.lineTo(0, size.height); path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, size.height); path.lineTo(size.width, size.height); path.lineTo(size.width, 0);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
