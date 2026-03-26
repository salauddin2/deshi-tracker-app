import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/data_providers.dart';

class FridgeScreen extends ConsumerStatefulWidget {
  const FridgeScreen({super.key});
  @override
  ConsumerState<FridgeScreen> createState() => _FridgeScreenState();
}

class _FridgeScreenState extends ConsumerState<FridgeScreen> {
  static const _navy = Color(0xFF1A3C5E);
  List _fridges = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      // userId comes from auth state — using empty string as placeholder
      // In production, get userId from: ref.read(authProvider).user?.id ?? ''
      final userId = '';
      final data = await ref.read(fridgeRepositoryProvider).getFridges(userId);
      if (mounted) setState(() { _fridges = data; _loading = false; });
    } catch (_) { if (mounted) setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FD),
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: Text('Fridge Monitoring', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text('Add Fridge', style: GoogleFonts.inter()),
        onPressed: _addFridge,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _fridges.isEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.kitchen_outlined, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('No fridges added yet.', style: GoogleFonts.inter(color: Colors.grey)),
                ]))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _fridges.length,
                    itemBuilder: (_, i) {
                      final f = _fridges[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.kitchen, color: Colors.blue),
                          ),
                          title: Text(f['name'] ?? 'Fridge', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                          subtitle: Text('Location: ${f['location'] ?? 'N/A'}', style: GoogleFonts.inter(color: Colors.grey)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.push(context, MaterialPageRoute(
                            builder: (_) => FridgeDetailScreen(fridgeId: f['_id'], fridgeName: f['name'] ?? 'Fridge'),
                          )),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  void _addFridge() {
    final nameCtrl = TextEditingController();
    final locCtrl = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text('Add Fridge', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: nameCtrl, decoration: const InputDecoration(hintText: 'Fridge name (e.g. Walk-in Fridge)')),
        const SizedBox(height: 12),
        TextField(controller: locCtrl, decoration: const InputDecoration(hintText: 'Location (e.g. Kitchen)')),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: _navy, foregroundColor: Colors.white),
          onPressed: () async {
            Navigator.pop(context);
            await ref.read(fridgeRepositoryProvider).createFridge({'name': nameCtrl.text, 'location': locCtrl.text});
            _load();
          },
          child: const Text('Add'),
        ),
      ],
    ));
  }
}

class FridgeDetailScreen extends ConsumerStatefulWidget {
  final String fridgeId;
  final String fridgeName;
  const FridgeDetailScreen({super.key, required this.fridgeId, required this.fridgeName});
  @override
  ConsumerState<FridgeDetailScreen> createState() => _FridgeDetailScreenState();
}

class _FridgeDetailScreenState extends ConsumerState<FridgeDetailScreen> {
  static const _navy = Color(0xFF1A3C5E);
  List _records = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final data = await ref.read(fridgeRepositoryProvider).getRecords(widget.fridgeId);
      if (mounted) setState(() { _records = data; _loading = false; });
    } catch (_) { if (mounted) setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FD),
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: Text(widget.fridgeName, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        onPressed: _addReading,
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(children: [
              if (_records.isNotEmpty) _buildChart(),
              Expanded(child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _records.length,
                itemBuilder: (_, i) {
                  final r = _records[i];
                  final temp = r['temperature'] ?? 0;
                  final isOk = temp >= 0 && temp <= 8;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isOk ? Colors.green.shade50 : Colors.red.shade50,
                        child: Text('$temp°', style: TextStyle(color: isOk ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                      title: Text('$temp°C', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                      subtitle: Text(r['recordedAt'] ?? r['createdAt'] ?? '', style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isOk ? Colors.green.shade100 : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(isOk ? 'OK' : 'ALERT', style: TextStyle(color: isOk ? Colors.green[700] : Colors.red[700], fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  );
                },
              )),
            ]),
    );
  }

  Widget _buildChart() {
    final temps = _records.take(10).map((r) => (r['temperature'] as num?)?.toDouble() ?? 0).toList().reversed.toList();
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
      height: 180,
      child: LineChart(LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [LineChartBarData(
          spots: List.generate(temps.length, (i) => FlSpot(i.toDouble(), temps[i])),
          isCurved: true,
          color: _navy,
          barWidth: 3,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(show: true, color: _navy.withValues(alpha: 0.1)),
        )],
      )),
    );
  }

  void _addReading() {
    final ctrl = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text('Log Temperature', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      content: TextField(controller: ctrl, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Temperature (°C)', suffixText: '°C')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: _navy, foregroundColor: Colors.white),
          onPressed: () async {
            Navigator.pop(context);
            await ref.read(fridgeRepositoryProvider).addRecord({'fridgeId': widget.fridgeId, 'temperature': double.tryParse(ctrl.text) ?? 0});
            _load();
          },
          child: const Text('Log'),
        ),
      ],
    ));
  }
}

