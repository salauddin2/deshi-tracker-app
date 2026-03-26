import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  bool _newOrder = true;
  bool _orderCancelled = true;
  bool _newReview = true;
  bool _promotionExpiring = false;
  bool _systemUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FD),
      appBar: AppBar(
        title: Text('Notification Settings', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Alerts',
              style: GoogleFonts.jost(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1A3C5E)),
            ),
            const SizedBox(height: 16),
            _buildToggleItem('New Order Received', 'Get notified when a customer places a new order', _newOrder, (v) => setState(() => _newOrder = v)),
            _buildToggleItem('Order Cancelled', 'Alert when an order is cancelled by the customer', _orderCancelled, (v) => setState(() => _orderCancelled = v)),
            
            const SizedBox(height: 32),
            Text(
              'Business Alerts',
              style: GoogleFonts.jost(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1A3C5E)),
            ),
            const SizedBox(height: 16),
            _buildToggleItem('New Review', 'Notify when a customer leaves a review on your business', _newReview, (v) => setState(() => _newReview = v)),
            _buildToggleItem('Promotion Expiring', 'Get an alert 24 hours before a deal expires', _promotionExpiring, (v) => setState(() => _promotionExpiring = v)),
            
            const SizedBox(height: 32),
            Text(
              'System',
              style: GoogleFonts.jost(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1A3C5E)),
            ),
            const SizedBox(height: 16),
            _buildToggleItem('System Announcements', 'Alerts about new features and scheduled maintenance', _systemUpdates, (v) => setState(() => _systemUpdates = v)),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle, style: GoogleFonts.jost(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: const Color(0xFF1A3C5E),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
