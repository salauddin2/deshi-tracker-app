import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/models/business.dart';
import '../providers/data_providers.dart';

class AdminBusinessesScreen extends ConsumerStatefulWidget {
  const AdminBusinessesScreen({super.key});
  @override
  ConsumerState<AdminBusinessesScreen> createState() => _AdminBusinessesScreenState();
}

class _AdminBusinessesScreenState extends ConsumerState<AdminBusinessesScreen> {
  static const _navy = Color(0xFF1A3C5E);
  List<Business> _businesses = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final data = await ref.read(businessRepositoryProvider).getBusinesses(page: 1);
      if (mounted) setState(() { _businesses = data; _loading = false; });
    } catch (_) { if (mounted) setState(() => _loading = false); }
  }

  Future<void> _toggleStatus(String id, bool val) async {
    // A placeholder for toggle business status functionality
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Status update not wired yet')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FD),
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: Text('Manage Businesses', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _businesses.length,
              itemBuilder: (context, i) {
                final b = _businesses[i];
                final active = b.isActive;
                return Card(
                  elevation: 0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _navy.withValues(alpha: 0.1),
                      child: const Icon(Icons.store, color: _navy),
                    ),
                    title: Text(b.businessName, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                    subtitle: Text('Category ID: ${b.categoryId}'),
                    trailing: Switch(
                      value: active,
                      activeThumbColor: _navy,
                      onChanged: (v) => _toggleStatus(b.id, v),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
