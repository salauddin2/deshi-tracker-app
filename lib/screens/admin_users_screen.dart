import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/data_providers.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});
  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  static const _navy = Color(0xFF1A3C5E);
  List<dynamic> _users = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final data = await ref.read(userRepositoryProvider).getAllUsers();
      if (mounted) setState(() { _users = data; _loading = false; });
    } catch (_) { if (mounted) setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FD),
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: Text('Manage Users', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _users.length,
              itemBuilder: (context, i) {
                final u = _users[i];
                return Card(
                  elevation: 0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.withValues(alpha: 0.1),
                      child: const Icon(Icons.person, color: Colors.blue),
                    ),
                    title: Text(u['name'] ?? 'Unnamed User', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                    subtitle: Text(u['email'] ?? 'No email'),
                    trailing: Chip(
                      label: Text((u['role'] ?? 'user').toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                      backgroundColor: u['role'] == 'admin' ? Colors.red : (u['role'] == 'business_owner' ? Colors.green : Colors.grey),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
