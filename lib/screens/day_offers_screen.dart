import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/data_providers.dart';
import '../features/auth/providers/auth_provider.dart';

class DayOffersScreen extends ConsumerStatefulWidget {
  const DayOffersScreen({super.key});
  @override
  ConsumerState<DayOffersScreen> createState() => _DayOffersScreenState();
}

class _DayOffersScreenState extends ConsumerState<DayOffersScreen> {
  static const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  static const Color _navy = Color(0xFF1A3C5E);
  static const Color _bg = Color(0xFFF4F8FD);
  static const Color _green = Color(0xFF15803D);
  List<dynamic> _offers = [];
  bool _loading = true;

  @override
  void initState() { 
    super.initState(); 
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadOffers());
  }

  Future<void> _loadOffers() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final businessId = ref.read(authProvider).business?.id;
      final offers = await ref.read(offerRepositoryProvider).fetchDayOffers(businessId: businessId);
      if (mounted) setState(() => _offers = offers);
    } catch (e) {
      debugPrint('Load offers: $e');
    }
    if (mounted) setState(() => _loading = false);
  }

  dynamic _offerForDay(String day) {
    return _offers.firstWhere(
      (o) => (o['dayOfWeek'] ?? o['day'] ?? '').toString().toLowerCase() == day.toLowerCase(),
      orElse: () => null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: Text('Day Offers & Discounts', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _navy))
          : RefreshIndicator(
              onRefresh: _loadOffers,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Weekly Discount Schedule', style: GoogleFonts.jost(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Tap a day to set or edit the discount offer', style: GoogleFonts.jost(color: Colors.grey[500], fontSize: 13)),
                    const SizedBox(height: 20),
                    _buildDayTiles(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDayTiles() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: List.generate(7, (i) {
        final day = _days[i];
        final offer = _offerForDay(day);
        final hasOffer = offer != null;
        final discount = hasOffer ? (offer['discount_percent'] ?? offer['discountPercentage'] ?? 0) : 0;

        return GestureDetector(
          onTap: () => _showOfferForm(day, offer),
          child: Container(
            width: (MediaQuery.of(context).size.width - 56) / 2,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: hasOffer
                  ? Border.all(color: _green, width: 2)
                  : Border.all(color: Colors.grey.shade300, width: 1, style: BorderStyle.none), // We'll use a custom painter or just a dashed effect
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10)],
            ),
            child: CustomPaint(
              painter: !hasOffer ? DashPainter(color: Colors.grey.shade300) : null,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(day, style: GoogleFonts.jost(fontWeight: FontWeight.bold, color: _navy)),
                        if (hasOffer)
                          const Icon(Icons.check_circle, color: Color(0xFF15803D), size: 18)
                        else
                          Icon(Icons.add_circle_outline, color: Colors.grey[400], size: 18),
                      ],
                    ),
                    if (hasOffer)
                      Text(
                        '$discount% OFF',
                        style: GoogleFonts.jost(fontSize: 20, fontWeight: FontWeight.bold, color: _green),
                      )
                    else
                      Text(
                        'Empty',
                        style: GoogleFonts.jost(fontSize: 14, color: Colors.grey[400]),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showOfferForm(String day, dynamic existing) {
    final isEdit = existing != null;
    final discountCtrl = TextEditingController(text: isEdit ? (existing['discount_percent'] ?? existing['discountPercentage'] ?? '').toString() : '');
    final startCtrl = TextEditingController(text: isEdit ? _fmtDate(existing['start_date'] ?? existing['startDate']) : '');
    final endCtrl = TextEditingController(text: isEdit ? _fmtDate(existing['end_date'] ?? existing['endDate']) : '');
    String startIso = existing?['start_date'] ?? existing?['startDate'] ?? '';
    String endIso = existing?['end_date'] ?? existing?['endDate'] ?? '';
    String? selectedCategoryId = existing?['product_category_id'] ?? existing?['categoryFilter'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${isEdit ? 'Edit' : 'Create'} $day Offer', style: GoogleFonts.jost(fontSize: 20, fontWeight: FontWeight.bold, color: _navy)),
            const SizedBox(height: 24),
            TextField(
              controller: discountCtrl,
              decoration: _inputDeco('Discount Percentage (e.g. 15)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: startCtrl,
                    readOnly: true,
                    decoration: _inputDeco('Start Date'),
                    onTap: () async {
                      final d = await showDatePicker(context: ctx, initialDate: DateTime.now(), firstDate: DateTime(2024), lastDate: DateTime(2030));
                      if (d != null) {
                        startCtrl.text = '${d.day}/${d.month}/${d.year}';
                        startIso = d.toIso8601String();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: endCtrl,
                    readOnly: true,
                    decoration: _inputDeco('End Date (Optional)'),
                    onTap: () async {
                      final d = await showDatePicker(context: ctx, initialDate: DateTime.now(), firstDate: DateTime(2024), lastDate: DateTime(2030));
                      if (d != null) {
                        endCtrl.text = '${d.day}/${d.month}/${d.year}';
                        endIso = d.toIso8601String();
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Category Selector
            FutureBuilder<List<dynamic>>(
              future: ref.read(productRepositoryProvider).getCategories(),
              builder: (context, snapshot) {
                final categories = snapshot.data ?? [];
                return DropdownButtonFormField<String>(
                  initialValue: selectedCategoryId,
                  decoration: _inputDeco('Product Category (Optional)'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Categories')),
                    ...categories.map((c) => DropdownMenuItem(value: c['_id'] as String, child: Text(c['name'] ?? ''))),
                  ],
                  onChanged: (val) => selectedCategoryId = val,
                );
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  if (discountCtrl.text.isEmpty) return;
                  Navigator.pop(ctx);
                  final data = {
                    'day': day,
                    'discount_percent': double.tryParse(discountCtrl.text) ?? 0,
                    'start_date': startIso.isNotEmpty ? startIso : DateTime.now().toIso8601String(),
                    if (endIso.isNotEmpty) 'end_date': endIso,
                    'product_category_id': selectedCategoryId,
                    'business_id': ref.read(authProvider).business?.id ?? ref.read(authProvider).user?.id,
                    'isActive': true,
                  };
                  try {
                    if (isEdit) {
                      await ref.read(offerRepositoryProvider).updateDayOffer(existing['_id'], data);
                    } else {
                      await ref.read(offerRepositoryProvider).createDayOffer(data);
                    }
                    _loadOffers();
                  } catch (e) {
                    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _navy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(isEdit ? 'Save Changes' : 'Create Offer', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
              ),
            ),
            if (isEdit) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _deleteOffer(existing['_id']);
                  },
                  child: Text('Delete Offer', style: GoogleFonts.jost(color: Colors.red)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _deleteOffer(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete offer?', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        content: Text('This action cannot be undone.', style: GoogleFonts.jost()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('Delete', style: TextStyle(color: Colors.white))),
        ],
      ),
    ) ?? false;
    if (!confirmed) return;
    await ref.read(offerRepositoryProvider).deleteDayOffer(id);
    await _loadOffers();
  }

  String _fmtDate(dynamic s) {
    if (s == null || s.toString().isEmpty) return '';
    try {
      final dt = DateTime.parse(s.toString());
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) { return s.toString(); }
  }

  InputDecoration _inputDeco(String label) => InputDecoration(
    labelText: label, labelStyle: GoogleFonts.jost(fontSize: 13),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  );
}

class DashPainter extends CustomPainter {
  final Color color;
  DashPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    const dashWidth = 5.0;
    const dashSpace = 3.0;
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(16));
    final path = Path()..addRRect(rrect);
    
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
