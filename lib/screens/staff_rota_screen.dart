import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StaffRotaScreen extends StatefulWidget {
  const StaffRotaScreen({super.key});

  @override
  State<StaffRotaScreen> createState() => _StaffRotaScreenState();
}

class _StaffRotaScreenState extends State<StaffRotaScreen> {
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<String> _staff = ['John Doe', 'Sarah Smith', 'Ahmed Ali', 'Lisa Ray'];
  
  // Mock Rota: Staff index -> Day index -> Shift Type (0: Off, 1: Morning, 2: Evening, 3: Full Day)
  final Map<int, Map<int, int>> _rota = {
    0: {0: 1, 1: 1, 2: 3, 3: 0, 4: 2, 5: 0, 6: 0},
    1: {0: 2, 1: 0, 2: 2, 3: 1, 4: 1, 5: 3, 6: 0},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FD),
      appBar: AppBar(
        title: Text('Staff Rota', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.person_add_alt_1),
            label: const Text('Add Staff'),
            style: TextButton.styleFrom(foregroundColor: const Color(0xFF1A3C5E)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFF1A3C5E)),
              dataRowMinHeight: 60,
              dataRowMaxHeight: 60,
              columnSpacing: 40,
              columns: [
                DataColumn(label: Text('STAFF NAME', style: GoogleFonts.jost(color: Colors.white, fontWeight: FontWeight.bold))),
                ..._days.map((day) => DataColumn(
                  label: Text(day.toUpperCase(), style: GoogleFonts.jost(color: Colors.white, fontWeight: FontWeight.bold)),
                )),
              ],
              rows: _staff.asMap().entries.map((entry) {
                final staffIdx = entry.key;
                final staffName = entry.value;
                return DataRow(
                  cells: [
                    DataCell(Text(staffName, style: GoogleFonts.jost(fontWeight: FontWeight.bold))),
                    ...List.generate(7, (dayIdx) => DataCell(
                      _buildShiftCell(staffIdx, dayIdx),
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShiftCell(int staffIdx, int dayIdx) {
    final shiftType = _rota[staffIdx]?[dayIdx] ?? 0;
    
    return InkWell(
      onTap: () {},
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _getShiftColor(shiftType).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _getShiftColor(shiftType).withValues(alpha: 0.5)),
        ),
        child: Center(
          child: Text(
            _getShiftLabel(shiftType),
            style: GoogleFonts.jost(
              color: _getShiftColor(shiftType),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Color _getShiftColor(int type) {
    switch (type) {
      case 1: return Colors.orange; // Morning
      case 2: return Colors.blue;   // Evening
      case 3: return Colors.purple; // Full Day
      default: return Colors.grey[300]!; // Off
    }
  }

  String _getShiftLabel(int type) {
    switch (type) {
      case 1: return 'M';
      case 2: return 'E';
      case 3: return 'F';
      default: return '-';
    }
  }
}
