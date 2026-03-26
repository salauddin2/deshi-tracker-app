import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/data_providers.dart';
import '../features/auth/providers/auth_provider.dart';
import '../core/providers/permission_provider.dart';

class StaffManagementScreen extends ConsumerStatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  ConsumerState<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends ConsumerState<StaffManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Data
  List<dynamic> _roles = [];
  List<dynamic> _employees = [];
  List<dynamic> _shifts = [];
  bool _loading = true;

  // Colors
  static const Color navy = Color(0xFF1A3C5E);
  static const Color bg = Color(0xFFF4F8FD);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAll();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() => _loading = true);
    try {
      final authState = ref.read(authProvider);
      final businessId = authState.business?.id ?? '';
      if (businessId.isEmpty) return;

      await Future.wait([
        _loadRoles(),
        _loadEmployees(businessId),
        _loadShifts(businessId),
      ]);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadRoles() async {
    try {
      final data = await ref.read(staffRepositoryProvider).fetchRotaRoles();
      setState(() => _roles = data['data'] ?? []);
    } catch (e) {
      debugPrint('Load roles: $e');
    }
  }

  Future<void> _loadEmployees(String businessId) async {
    try {
      final data = await ref.read(staffRepositoryProvider).fetchStaff(businessId);
      setState(() => _employees = data['data'] ?? []);
    } catch (e) {
      debugPrint('Load staff: $e');
    }
  }

  Future<void> _loadShifts(String businessId) async {
    try {
      final data = await ref.read(staffRepositoryProvider).fetchRotaShifts();
      setState(() => _shifts = data);
    } catch (e) {
      debugPrint('Load shifts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final permissions = ref.watch(permissionProvider);

    if (!permissions.canManageStaff) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text('Access Denied', style: GoogleFonts.jost(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Only owners and managers can access this screen.', style: GoogleFonts.jost(color: Colors.grey[600])),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text('Staff Management', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: navy,
          unselectedLabelColor: Colors.grey,
          indicatorColor: navy,
          tabs: const [
            Tab(icon: Icon(Icons.badge_outlined), text: 'Roles'),
            Tab(icon: Icon(Icons.people_outline), text: 'Employees'),
            Tab(icon: Icon(Icons.calendar_month_outlined), text: 'Shifts'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildRolesTab(),
                _buildEmployeesTab(),
                _buildShiftsTab(),
              ],
            ),
    );
  }

  // ── TAB 1: Roles ────────────────────────────────────────────────────────
  Widget _buildRolesTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_roles.length} roles', style: GoogleFonts.jost(color: Colors.grey[600])),
              ElevatedButton.icon(
                onPressed: () => _showRoleDialog(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Role'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: navy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _roles.isEmpty
              ? _emptyState('No roles yet', 'Create a role to assign to staff members')
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _roles.length,
                  itemBuilder: (context, i) {
                    final role = _roles[i];
                    return _card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: navy.withValues(alpha: 0.1),
                          child: const Icon(Icons.badge, color: navy, size: 20),
                        ),
                        title: Text(role['name'] ?? '', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
                        subtitle: Text(role['description'] ?? '', style: GoogleFonts.jost(color: Colors.grey[600])),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit_outlined, color: Colors.blue), onPressed: () => _showRoleDialog(role: role)),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () => _deleteRole(role['_id']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ── TAB 2: Employees ────────────────────────────────────────────────────
  Widget _buildEmployeesTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_employees.length} staff', style: GoogleFonts.jost(color: Colors.grey[600])),
              ElevatedButton.icon(
                onPressed: () => _showInviteDialog(),
                icon: const Icon(Icons.person_add_alt_1, size: 18),
                label: const Text('Invite Staff'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: navy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _employees.isEmpty
              ? _emptyState('No staff yet', 'Invite your first team member')
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _employees.length,
                  itemBuilder: (context, i) {
                    final emp = _employees[i];
                    final status = emp['status'] ?? 'invited';
                    final isActive = status == 'active';
                    return _card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isActive ? Colors.green.shade50 : Colors.orange.shade50,
                          child: Text(
                            ((emp['firstName'] ?? 'S')[0]).toUpperCase(),
                            style: GoogleFonts.jost(color: isActive ? Colors.green : Colors.orange, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text('${emp['firstName'] ?? ''} ${emp['lastName'] ?? ''}', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
                        subtitle: Text(emp['email'] ?? '', style: GoogleFonts.jost(color: Colors.grey[600], fontSize: 12)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _statusBadge(status),
                            const SizedBox(width: 8),
                            PopupMenuButton<String>(
                              onSelected: (val) {
                                if (val == 'delete') _deleteEmployee(emp['_id']);
                                if (val == 'deactivate') _toggleEmployeeStatus(emp['_id'], isActive ? 'inactive' : 'active');
                              },
                              itemBuilder: (_) => [
                                PopupMenuItem(value: 'deactivate', child: Text(isActive ? 'Deactivate' : 'Activate')),
                                const PopupMenuItem(value: 'delete', child: Text('Remove', style: TextStyle(color: Colors.red))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ── TAB 3: Shifts ───────────────────────────────────────────────────────
  Widget _buildShiftsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_shifts.length} shifts', style: GoogleFonts.jost(color: Colors.grey[600])),
              ElevatedButton.icon(
                onPressed: () => _showShiftDialog(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Shift'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: navy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _shifts.isEmpty
              ? _emptyState('No shifts yet', 'Schedule your first staff shift')
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _shifts.length,
                  itemBuilder: (context, i) {
                    final shift = _shifts[i];
                    return _card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF2E6DA4).withValues(alpha: 0.1),
                          child: const Icon(Icons.schedule, color: Color(0xFF2E6DA4), size: 20),
                        ),
                        title: Text(
                          _formatDate(shift['date']),
                          style: GoogleFonts.jost(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${shift['start_time'] ?? ''} — ${shift['end_time'] ?? ''}  |  ${shift['notes'] ?? ''}',
                          style: GoogleFonts.jost(color: Colors.grey[600], fontSize: 12),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _deleteShift(shift['_id']),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ── Dialogs ─────────────────────────────────────────────────────────────

  void _showRoleDialog({dynamic role}) {
    final nameCtrl = TextEditingController(text: role?['name'] ?? '');
    final descCtrl = TextEditingController(text: role?['description'] ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(role == null ? 'Add Role' : 'Edit Role', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: _inputDeco('Role Name (e.g. Waiter)')),
            const SizedBox(height: 12),
            TextField(controller: descCtrl, decoration: _inputDeco('Description (optional)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              if (role == null) {
                await ref.read(staffRepositoryProvider).createRotaRole({'name': nameCtrl.text.trim(), 'description': descCtrl.text.trim()});
              } else {
                await ref.read(staffRepositoryProvider).patchRotaRole(role['_id'], {'name': nameCtrl.text.trim(), 'description': descCtrl.text.trim()});
              }
              await _loadRoles();
            },
            style: ElevatedButton.styleFrom(backgroundColor: navy, foregroundColor: Colors.white),
            child: Text(role == null ? 'Create' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _showInviteDialog() {
    final authState = ref.read(authProvider);
    final businessId = authState.business?.id ?? '';
    final ownerId = authState.user?.id ?? '';

    final firstCtrl = TextEditingController();
    final lastCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    String? selectedRoleId;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text('Invite Staff', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(child: TextField(controller: firstCtrl, decoration: _inputDeco('First Name'))),
                    const SizedBox(width: 8),
                    Expanded(child: TextField(controller: lastCtrl, decoration: _inputDeco('Last Name'))),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(controller: emailCtrl, decoration: _inputDeco('Email Address'), keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 12),
                TextField(controller: phoneCtrl, decoration: _inputDeco('Phone (optional)')),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: _inputDeco('Assign Role'),
                  initialValue: selectedRoleId,
                  items: _roles.map<DropdownMenuItem<String>>((r) => DropdownMenuItem(value: r['_id'], child: Text(r['name'] ?? ''))).toList(),
                  onChanged: (val) => setDialogState(() => selectedRoleId = val),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final email = emailCtrl.text.trim();
                if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please enter a valid email address.'),
                    backgroundColor: Colors.red,
                  ));
                  return;
                }
                if (selectedRoleId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please select a role.'),
                    backgroundColor: Colors.red,
                  ));
                  return;
                }

                Navigator.pop(ctx);
                await ref.read(staffRepositoryProvider).inviteStaff({
                  'business_id': businessId,
                  'owner_id': ownerId,
                  'firstName': firstCtrl.text.trim(),
                  'lastName': lastCtrl.text.trim(),
                  'email': email,
                  'phone': phoneCtrl.text.trim(),
                  'role_id': selectedRoleId,
                });
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Invitation request sent!'),
                    backgroundColor: Color(0xFF15803D),
                  ));
                }
                await _loadEmployees(businessId);
              },
              style: ElevatedButton.styleFrom(backgroundColor: navy, foregroundColor: Colors.white),
              child: const Text('Send Invite'),
            ),
          ],
        ),
      ),
    );
  }

  void _showShiftDialog() {
    final authState = ref.read(authProvider);
    final businessId = authState.business?.id ?? '';
    final dateCtrl = TextEditingController();
    final startCtrl = TextEditingController();
    final endCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String? selectedEmployeeId;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text('Add Shift', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: _inputDeco('Employee'),
                  initialValue: selectedEmployeeId,
                  items: _employees.map<DropdownMenuItem<String>>((e) => DropdownMenuItem(
                    value: e['_id'],
                    child: Text('${e['firstName'] ?? ''} ${e['lastName'] ?? ''}'),
                  )).toList(),
                  onChanged: (val) => setDialogState(() => selectedEmployeeId = val),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: dateCtrl,
                  readOnly: true,
                  decoration: _inputDeco('Date'),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(const Duration(days: 30)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      dateCtrl.text = picked.toIso8601String().split('T')[0];
                    }
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: TextField(controller: startCtrl, decoration: _inputDeco('Start (e.g. 09:00'))),
                    const SizedBox(width: 8),
                    Expanded(child: TextField(controller: endCtrl, decoration: _inputDeco('End (e.g. 17:00)'))),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(controller: notesCtrl, decoration: _inputDeco('Notes (optional)')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (selectedEmployeeId == null || dateCtrl.text.isEmpty) return;
                Navigator.pop(ctx);
                await ref.read(staffRepositoryProvider).createRotaShift({
                  'employee': selectedEmployeeId,
                  'business': businessId,
                  'date': dateCtrl.text,
                  'start_time': startCtrl.text.trim(),
                  'end_time': endCtrl.text.trim(),
                  'notes': notesCtrl.text.trim(),
                });
                await _loadShifts(businessId);
              },
              style: ElevatedButton.styleFrom(backgroundColor: navy, foregroundColor: Colors.white),
              child: const Text('Save Shift'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Future<void> _deleteRole(String id) async {
    await ref.read(staffRepositoryProvider).deleteRotaRole(id);
    await _loadRoles();
  }

  Future<void> _deleteEmployee(String id) async {
    final authState = ref.read(authProvider);
    final businessId = authState.business?.id ?? '';
    await ref.read(staffRepositoryProvider).deleteStaff(id, businessId);
    await _loadEmployees(businessId);
  }

  Future<void> _toggleEmployeeStatus(String id, String status) async {
    final authState = ref.read(authProvider);
    final businessId = authState.business?.id ?? '';
    await ref.read(staffRepositoryProvider).updateStaff(id, businessId, {'status': status});
    await _loadEmployees(businessId);
  }

  Future<void> _deleteShift(String id) async {
    final authState = ref.read(authProvider);
    await ref.read(staffRepositoryProvider).deleteRotaShift(id);
    if (!mounted) return;
    await _loadShifts(authState.business?.id ?? '');
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

  Widget _card({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: child,
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    switch (status) {
      case 'active': color = Colors.green; break;
      case 'invited': color = Colors.orange; break;
      default: color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(status.toUpperCase(), style: GoogleFonts.jost(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _emptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(title, style: GoogleFonts.jost(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Text(subtitle, style: GoogleFonts.jost(color: Colors.grey[400])),
        ],
      ),
    );
  }

  InputDecoration _inputDeco(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  );
}
