import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/data_providers.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final String businessId;
  final String businessName;
  final String ownerId;
  const BookingScreen({super.key, required this.businessId, required this.businessName, required this.ownerId});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  static const _navy = Color(0xFF1A3C5E);
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  int _partySize = 2;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 19, minute: 0);
  bool _loading = false;

  @override
  void dispose() { _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose(); super.dispose(); }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (d != null) setState(() => _selectedDate = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: _selectedTime);
    if (t != null) setState(() => _selectedTime = t);
  }

  Future<void> _submit() async {
    if (_nameCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your name.')));
      return;
    }
    setState(() => _loading = true);
    try {
      await ref.read(memberRepositoryProvider).createBooking(
        businessId: widget.businessId,
        ownerId: widget.ownerId,
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        partySize: _partySize,
        date: _selectedDate.toIso8601String(),
        time: '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking confirmed! 🎉'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
        setState(() => _loading = false);
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Book a Table', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(widget.businessName, style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionTitle('Your Details'),
          _field(_nameCtrl, 'Full Name', Icons.person_outline),
          const SizedBox(height: 12),
          _field(_emailCtrl, 'Email (optional)', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 12),
          _field(_phoneCtrl, 'Phone (optional)', Icons.phone_outlined, keyboardType: TextInputType.phone),
          const SizedBox(height: 24),
          _sectionTitle('Booking Details'),
          Row(children: [
            Expanded(child: _dateTile('Date', '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}', Icons.calendar_today, _pickDate)),
            const SizedBox(width: 12),
            Expanded(child: _dateTile('Time', _selectedTime.format(context), Icons.access_time, _pickTime)),
          ]),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
            child: Row(children: [
              const Icon(Icons.people_outline),
              const SizedBox(width: 12),
              Text('Party Size', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => setState(() { if (_partySize > 1) _partySize--; })),
              Text('$_partySize', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => setState(() => _partySize++)),
            ]),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(backgroundColor: _navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              child: _loading ? const CircularProgressIndicator(color: Colors.white) : Text('CONFIRM BOOKING', style: GoogleFonts.inter(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _sectionTitle(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(t, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: _navy)),
  );

  Widget _field(TextEditingController c, String hint, IconData icon, {TextInputType? keyboardType}) => TextField(
    controller: c, keyboardType: keyboardType,
    decoration: InputDecoration(
      hintText: hint, prefixIcon: Icon(icon),
      filled: true, fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
    ),
  );

  Widget _dateTile(String label, String value, IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(icon, size: 16, color: Colors.grey), const SizedBox(width: 8), Text(label, style: GoogleFonts.inter(color: Colors.grey, fontSize: 12))]),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: _navy)),
      ]),
    ),
  );
}
