import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/data_providers.dart';
import '../features/auth/providers/auth_provider.dart';
import '../data/models/order.dart';

class OrderManagementScreen extends ConsumerStatefulWidget {
  const OrderManagementScreen({super.key});
  @override
  ConsumerState<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends ConsumerState<OrderManagementScreen> {
  List<dynamic> _orders = [];
  bool _loading = true;
  String _selectedFilter = 'Today';
  String? _selectedStatus;

  static const Color _navy = Color(0xFF1A3C5E);
  static const Color _accent = Color(0xFF2E6DA4);
  static const Color _bg = Color(0xFFF4F8FD);
  static const Color _green = Color(0xFF15803D);
  static const Color _amber = Color(0xFFD97706);
  static const Color _red = Color(0xFFB91C1C);

  static const _filterOptions = ['Today', 'This Week', 'This Month', 'This Year', 'All'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadOrders());
  }

  ({String? from, String? to}) _getDateRange() {
    final now = DateTime.now();
    switch (_selectedFilter) {
      case 'Today':
        final d = now.toIso8601String().split('T')[0];
        return (from: d, to: d);
      case 'This Week':
        final start = now.subtract(Duration(days: now.weekday - 1));
        return (from: start.toIso8601String().split('T')[0], to: now.toIso8601String().split('T')[0]);
      case 'This Month':
        final start = DateTime(now.year, now.month, 1);
        return (from: start.toIso8601String().split('T')[0], to: now.toIso8601String().split('T')[0]);
      case 'This Year':
        final start = DateTime(now.year, 1, 1);
        return (from: start.toIso8601String().split('T')[0], to: now.toIso8601String().split('T')[0]);
      default:
        return (from: null, to: null);
    }
  }

  Future<void> _loadOrders() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final range = _getDateRange();
      final businessId = ref.read(authProvider).business?.id ?? '';
      if (businessId.isEmpty) return;

      final data = await ref.read(orderRepositoryProvider).fetchOrders(
        businessId: businessId,
        from: range.from,
        to: range.to,
        status: _selectedStatus,
      );
      if (mounted) setState(() => _orders = data is List ? data : (data['data'] ?? []));
    } catch (e) { debugPrint('Load orders: $e'); }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    try {
      await ref.read(orderRepositoryProvider).updateOrder(orderId, {'status': newStatus});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order updated to $newStatus'), backgroundColor: _green),
      );
      await _loadOrders();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update order'), backgroundColor: _red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: Text('Orders', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () => context.push('/owner/take-order'),
              icon: const Icon(Icons.add_shopping_cart, size: 16),
              label: Text('Take Order', style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 13)),
              style: ElevatedButton.styleFrom(backgroundColor: _navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filterOptions.map((f) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(f, style: GoogleFonts.jost(fontSize: 12, fontWeight: FontWeight.w600, color: _selectedFilter == f ? Colors.white : Colors.black87)),
                        selected: _selectedFilter == f,
                        selectedColor: _navy,
                        backgroundColor: _bg,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        side: BorderSide.none,
                        onSelected: (_) { setState(() => _selectedFilter = f); _loadOrders(); },
                      ),
                    )).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _statusChip(null, 'All'),
                      _statusChip('pending', 'Pending'),
                      _statusChip('confirmed', 'Confirmed'),
                      _statusChip('processing', 'Processing'),
                      _statusChip('completed', 'Completed'),
                      _statusChip('cancelled', 'Cancelled'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (!_loading)
            Container(
              color: const Color(0xFFEEF5FC),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _summaryBadge('Total', '${_orders.length}', _navy),
                  _summaryBadge('Pending', '${_orders.where((o) => (o['status'] ?? '').toString().toLowerCase() == 'pending').length}', _amber),
                  _summaryBadge('Completed', '${_orders.where((o) => (o['status'] ?? '').toString().toLowerCase() == 'completed').length}', _green),
                ],
              ),
            ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: _navy))
                : _orders.isEmpty
                    ? _emptyState()
                    : RefreshIndicator(
                        onRefresh: _loadOrders,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _orders.length,
                          itemBuilder: (ctx, i) => _buildOrderCard(_orders[i]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String? status, String label) {
    final isSelected = _selectedStatus == status;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () { setState(() => _selectedStatus = status); _loadOrders(); },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? _accent.withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: isSelected ? _accent : Colors.grey.shade300),
          ),
          child: Text(label, style: GoogleFonts.jost(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? _accent : Colors.grey[600])),
        ),
      ),
    );
  }

  Widget _summaryBadge(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.jost(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: GoogleFonts.jost(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildOrderCard(dynamic order) {
    final orderId = order['_id'] ?? '';
    final orderNum = order['orderNumber'] ?? order['_id']?.toString().substring(0, 8) ?? '';
    final status = (order['status'] ?? 'pending').toString().toLowerCase();
    final items = order['items'] as List? ?? [];
    final totals = order['totals'] as Map? ?? {};
    final subtotal = (totals['subtotal'] ?? order['total'] ?? 0).toDouble();
    final currency = order['currency'] ?? 'GBP';
    final tableNo = order['tableNo'] ?? '';
    final notes = order['notes'] ?? '';
    final createdAt = order['createdAt'];

    Color statusColor;
    IconData statusIcon;
    switch (status) {
      case 'completed': statusColor = _green; statusIcon = Icons.check_circle; break;
      case 'confirmed': statusColor = _navy; statusIcon = Icons.thumb_up_alt_outlined; break;
      case 'processing': statusColor = _accent; statusIcon = Icons.restaurant_menu; break;
      case 'cancelled': statusColor = _red; statusIcon = Icons.cancel; break;
      default: statusColor = _amber; statusIcon = Icons.access_time; break;
    }

    return GestureDetector(
      onTap: () => context.push('/owner/order-detail/$orderId'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: Icon(statusIcon, color: statusColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('#$orderNum', style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 15)),
                        if (tableNo.toString().isNotEmpty) Text('Table $tableNo', style: GoogleFonts.jost(color: Colors.grey[500], fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                    child: Text(status.toUpperCase(), style: GoogleFonts.jost(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.print_outlined, size: 20, color: _navy),
                    onPressed: () => ref.read(printServiceProvider).printReceipt(Order.fromJson(order)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  ...items.take(3).map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Text('${item['quantity'] ?? 1}x ', style: GoogleFonts.jost(color: _accent, fontWeight: FontWeight.bold, fontSize: 13)),
                        Expanded(child: Text(item['name'] ?? '', style: GoogleFonts.jost(fontSize: 13))),
                        Text('$currency ${((item['price'] ?? 0) * (item['quantity'] ?? 1)).toStringAsFixed(2)}',
                          style: GoogleFonts.jost(fontSize: 13, color: Colors.grey[600])),
                      ],
                    ),
                  )),
                  if (items.length > 3) Text('+ ${items.length - 3} more items', style: GoogleFonts.jost(color: Colors.grey[400], fontSize: 12)),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              child: Row(
                children: [
                  if (createdAt != null) Text(_timeAgo(createdAt), style: GoogleFonts.jost(color: Colors.grey[400], fontSize: 11)),
                  if (notes.toString().isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Expanded(child: Text(notes, style: GoogleFonts.jost(color: Colors.grey[400], fontSize: 11), overflow: TextOverflow.ellipsis)),
                  ] else
                    const Spacer(),
                  Text('$currency ${subtotal.toStringAsFixed(2)}', style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 16, color: _navy)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  if (status == 'pending')
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _updateOrderStatus(orderId, 'confirmed'),
                        style: ElevatedButton.styleFrom(backgroundColor: _navy.withValues(alpha: 0.1), foregroundColor: _navy, elevation: 0),
                        child: const Text('Confirm'),
                      ),
                    ),
                  if (status == 'confirmed')
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _updateOrderStatus(orderId, 'processing'),
                        style: ElevatedButton.styleFrom(backgroundColor: _accent.withValues(alpha: 0.1), foregroundColor: _accent, elevation: 0),
                        child: const Text('Process'),
                      ),
                    ),
                  if (status == 'processing')
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _updateOrderStatus(orderId, 'completed'),
                        style: ElevatedButton.styleFrom(backgroundColor: _green, foregroundColor: Colors.white, elevation: 0),
                        child: const Text('Complete'),
                      ),
                    ),
                  if (status != 'completed' && status != 'cancelled') ...[
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.cancel_outlined, color: Colors.red, size: 20),
                      onPressed: () => _updateOrderStatus(orderId, 'cancelled'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.receipt_long_outlined, size: 56, color: Colors.grey[300]),
        const SizedBox(height: 16),
        Text('No orders for this period', style: GoogleFonts.jost(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey[600])),
        const SizedBox(height: 6),
        Text('Try a different date range or create a new order', style: GoogleFonts.jost(color: Colors.grey[400], fontSize: 13)),
      ],
    ),
  );

  String _timeAgo(dynamic ts) {
    if (ts == null) return '';
    try {
      final dt = DateTime.parse(ts.toString()).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (_) { return ''; }
  }
}
