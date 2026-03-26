import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/data_providers.dart';
import '../features/auth/providers/auth_provider.dart';
import '../data/models/order.dart';

class OrderDetailScreen extends ConsumerWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  static const Color navy = Color(0xFF1A3C5E);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined),
            onPressed: () {
              // We'll need to fetch the order first if not in state
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ref.read(orderRepositoryProvider).fetchOrders(businessId: ref.read(authProvider).business?.id ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

          final List orders = snapshot.data is List ? (snapshot.data as List) : (snapshot.data?['data'] as List? ?? []);
          final orderData = orders.firstWhere((o) => o['_id'] == orderId, orElse: () => null);

          if (orderData == null) return const Center(child: Text('Order not found'));
          final order = Order.fromJson(orderData);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusBanner(order),
                const SizedBox(height: 24),
                _buildSection('Order Information', [
                  _buildInfoRow('Order ID', '#${order.id?.substring(0, 8)}'),
                  _buildInfoRow('Date', order.createdAt?.toString().split('.')[0] ?? ''),
                  _buildInfoRow('Payment', order.paymentMethod ?? 'Unpaid'),
                ]),
                const SizedBox(height: 24),
                _buildSection('Items', [
                  ...order.items.map((item) => _buildItemRow(item)),
                  const Divider(height: 24),
                  _buildInfoRow('Subtotal', '£${order.totalAmount.toStringAsFixed(2)}', isBold: true),
                ]),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => ref.read(printServiceProvider).printReceipt(order),
                    icon: const Icon(Icons.print),
                    label: Text('Print Receipt', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBanner(Order order) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: navy.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: navy.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: navy),
          const SizedBox(width: 12),
          Text(
            'Current Status: ${order.status.name.toUpperCase()}',
            style: GoogleFonts.jost(fontWeight: FontWeight.bold, color: navy),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.jost(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800])),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.jost(color: Colors.grey[600])),
          Text(value, style: GoogleFonts.jost(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildItemRow(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(6)),
            child: Text('${item.quantity}x', style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productName, style: GoogleFonts.jost(fontWeight: FontWeight.w600)),
                if (item.selectedOptions != null && item.selectedOptions!.isNotEmpty)
                  Text(item.selectedOptions!.join(', '), style: GoogleFonts.jost(fontSize: 11, color: Colors.grey[500])),
              ],
            ),
          ),
          Text('£${(item.price * item.quantity).toStringAsFixed(2)}', style: GoogleFonts.jost(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
