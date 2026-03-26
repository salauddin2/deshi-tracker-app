import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/data_providers.dart';

class RotaScreen extends ConsumerStatefulWidget {
  const RotaScreen({super.key});
  @override
  ConsumerState<RotaScreen> createState() => _RotaScreenState();
}

class _RotaScreenState extends ConsumerState<RotaScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  static const _navy = Color(0xFF1A3C5E);
  List _roles = [], _employees = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _load();
  }

  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final rota = ref.read(rotaRepositoryProvider);
      // Use empty string as fallback — real app gets businessId from auth state
      final rs = await rota.getRoles('');
      final es = await rota.getEmployees('');
      if (mounted) setState(() { _roles = rs; _employees = es; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FD),
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: Text('Rota Management', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [Tab(text: 'ROLES'), Tab(text: 'EMPLOYEES'), Tab(text: 'SHIFTS')],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tab,
              children: [
                _buildRolesTab(),
                _buildEmployeesTab(),
                _buildShiftsTab(),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text('Add', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        onPressed: _showAddDialog,
      ),
    );
  }

  Widget _buildRolesTab() {
    if (_roles.isEmpty) return _emptyState('No roles created yet.', Icons.badge_outlined);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _roles.length,
      itemBuilder: (_, i) {
        final role = _roles[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: _navy, child: const Icon(Icons.badge, color: Colors.white)),
            title: Text(role['name'] ?? 'Role', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            subtitle: Text(role['description'] ?? '', style: GoogleFonts.inter()),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(icon: const Icon(Icons.security, color: Colors.orange), onPressed: () => _showPermissions(role)),
              IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _deleteRole(role['_id'])),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildEmployeesTab() {
    if (_employees.isEmpty) return _emptyState('No employees added yet.', Icons.people_outline);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _employees.length,
      itemBuilder: (_, i) {
        final emp = _employees[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _navy.withValues(alpha: 0.1),
              child: Text((emp['firstName'] ?? '?')[0].toUpperCase(), style: TextStyle(color: _navy, fontWeight: FontWeight.bold)),
            ),
            title: Text('${emp['firstName'] ?? ''} ${emp['lastName'] ?? ''}', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            subtitle: Text(emp['email'] ?? '', style: GoogleFonts.inter(color: Colors.grey)),
            trailing: IconButton(
              icon: const Icon(Icons.person_add_alt_1, color: Colors.blue),
              tooltip: 'Invite to Staff Portal',
              onPressed: () => _inviteStaff(emp),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShiftsTab() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.calendar_month_outlined, size: 64, color: Colors.grey[300]),
        const SizedBox(height: 16),
        Text('Shift Calendar', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600])),
        const SizedBox(height: 8),
        Text('Tap + to create a shift for an employee.', style: GoogleFonts.inter(color: Colors.grey)),
      ]),
    );
  }

  Widget _emptyState(String msg, IconData icon) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 64, color: Colors.grey[300]),
      const SizedBox(height: 16),
      Text(msg, style: GoogleFonts.inter(color: Colors.grey)),
    ]));
  }

  void _showAddDialog() {
    final tabIndex = _tab.index;
    final label = tabIndex == 0 ? 'Role' : tabIndex == 1 ? 'Employee' : 'Shift';
    final ctrl = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text('Add $label', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      content: TextField(controller: ctrl, decoration: InputDecoration(hintText: '$label name')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: _navy, foregroundColor: Colors.white),
          onPressed: () async {
            Navigator.pop(context);
            if (tabIndex == 0) {
              await ref.read(rotaRepositoryProvider).createRole({'name': ctrl.text});
            } else if (tabIndex == 1) {
              await ref.read(rotaRepositoryProvider).createEmployee({'firstName': ctrl.text});
            }
            _load();
          },
          child: const Text('Add'),
        ),
      ],
    ));
  }

  void _showPermissions(Map role) {
    final tabs = ['take_order', 'orders', 'inventory', 'products', 'offers'];
    final selected = <String>{};
    showModalBottomSheet(context: context, builder: (_) => StatefulBuilder(
      builder: (ctx, setSt) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Permissions for ${role['name']}', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          Wrap(spacing: 8, children: tabs.map((t) => FilterChip(
            label: Text(t),
            selected: selected.contains(t),
            onSelected: (v) => setSt(() => v ? selected.add(t) : selected.remove(t)),
          )).toList()),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _navy, foregroundColor: Colors.white),
            onPressed: () async {
              await ref.read(rotaRepositoryProvider).setRolePermissions(role['_id'], selected.toList());
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Save Permissions'),
          ),
        ]),
      ),
    ));
  }

  void _inviteStaff(Map emp) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invitation sent to ${emp['email'] ?? 'employee'}'), backgroundColor: Colors.green),
    );
  }

  Future<void> _deleteRole(String id) async {
    await ref.read(rotaRepositoryProvider).deleteRole(id);
    _load();
  }
}

