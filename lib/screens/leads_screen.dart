import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/data_providers.dart';

class LeadsScreen extends ConsumerStatefulWidget {
  const LeadsScreen({super.key});
  @override
  ConsumerState<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends ConsumerState<LeadsScreen> {
  static const _navy = Color(0xFF1A3C5E);
  List _leads = [];
  bool _loading = true;
  bool _sending = false;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final data = await ref.read(memberRepositoryProvider).getLeads();
      if (mounted) setState(() { _leads = data; _loading = false; });
    } catch (_) { if (mounted) setState(() => _loading = false); }
  }

  Future<void> _sendPromotion() async {
    if (_leads.isEmpty) return;
    setState(() => _sending = true);
    try {
      await ref.read(memberRepositoryProvider).sendPromotion();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Promotion sent to all leads! 🎉'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _removeLead(String id) async {
    await ref.read(memberRepositoryProvider).removeLead(id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FD),
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: Text('My Leads', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        actions: [
          if (_leads.isNotEmpty)
            IconButton(
              tooltip: 'Send Promotion to All',
              onPressed: _sending ? null : _sendPromotion,
              icon: _sending ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.send),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _leads.isEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('No leads added yet.', style: GoogleFonts.inter(color: Colors.grey)),
                  Text('Add members who are interested in your business.', style: GoogleFonts.inter(color: Colors.grey, fontSize: 12), textAlign: TextAlign.center),
                ]))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _leads.length,
                    itemBuilder: (_, i) {
                      final lead = _leads[i];
                      final name = lead['name'] ?? lead['firstName'] ?? 'Lead';
                      final email = lead['email'] ?? '';
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _navy.withValues(alpha: 0.1),
                            child: Text(name[0].toUpperCase(), style: TextStyle(color: _navy, fontWeight: FontWeight.bold)),
                          ),
                          title: Text(name, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                          subtitle: email.isNotEmpty ? Text(email, style: GoogleFonts.inter(color: Colors.grey)) : null,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _removeLead(lead['_id'] ?? ''),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

