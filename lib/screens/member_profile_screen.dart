import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../features/auth/providers/auth_provider.dart';
import '../data/models/user.dart';

class MemberProfileScreen extends ConsumerWidget {
  const MemberProfileScreen({super.key});

  static const Color _navy = Color(0xFF1A3C5E);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final theme = Theme.of(context);

    if (user == null) {
      return const Scaffold(body: Center(child: Text('User not found')));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F1),
      appBar: AppBar(
        title: Text('Digital ID', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _buildProfileHeader(user, theme),
              const SizedBox(height: 32),
              _buildDigitalIDCard(user, theme),
              const SizedBox(height: 32),
              _buildActivityHistory(user, theme),
              const SizedBox(height: 32),
              _buildContactSection(user, theme),
              const SizedBox(height: 40),
              _buildSaveButton(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(User user, ThemeData theme) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
          backgroundImage: user.profilePicUrl != null ? NetworkImage(user.profilePicUrl!) : null,
          child: user.profilePicUrl == null
              ? Text(
                  user.name[0].toUpperCase(),
                  style: GoogleFonts.jost(fontSize: 48, color: theme.primaryColor, fontWeight: FontWeight.bold),
                )
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          style: GoogleFonts.jost(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          user.role.toUpperCase(),
          style: GoogleFonts.jost(fontSize: 14, color: Colors.grey[600], letterSpacing: 1.2),
        ),
      ],
    );
  }

  Widget _buildDigitalIDCard(User user, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[200]!),
              borderRadius: BorderRadius.circular(16),
            ),
            child: QrImageView(
              data: user.serialNumber ?? user.id,
              version: QrVersions.auto,
              size: 200.0,
              gapless: false,
              eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: _navy),
              dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: _navy),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.serialNumber ?? 'NO SERIAL',
            style: GoogleFonts.jost(fontSize: 14, fontWeight: FontWeight.bold, color: _navy, letterSpacing: 4),
          ),
          const SizedBox(height: 24),
          Text(
            'SCAN FOR SERVICES',
            style: GoogleFonts.jost(fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.grey[400]),
          ),
          const SizedBox(height: 8),
          Text(
            user.phone,
            style: GoogleFonts.jost(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityHistory(User user, ThemeData theme) {
    // Mocked history for Step 33
    final history = [
      {'title': 'Visit at Desi Cafe', 'date': '2 hours ago', 'points': '+10'},
      {'title': 'Bought 2x Products', 'date': 'Yesterday', 'points': '+25'},
      {'title': 'Monthly Bonus', 'date': '3 days ago', 'points': '+50'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Activity History', style: GoogleFonts.jost(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('125 Points', style: GoogleFonts.jost(color: theme.primaryColor, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: history.map((item) => Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
                    child: Icon(Icons.history, color: theme.primaryColor, size: 20),
                  ),
                  title: Text(item['title']!, style: GoogleFonts.jost(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: Text(item['date']!, style: GoogleFonts.jost(fontSize: 12, color: Colors.grey)),
                  trailing: Text(item['points']!, style: GoogleFonts.jost(color: Colors.green, fontWeight: FontWeight.bold)),
                ),
                if (history.indexOf(item) < history.length - 1) const Divider(height: 1, indent: 70),
              ],
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(User user, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Info',
          style: GoogleFonts.jost(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildInfoTile(Icons.email_outlined, 'Email', user.email),
        _buildInfoTile(Icons.phone_outlined, 'Phone', user.phone),
        _buildInfoTile(Icons.location_on_outlined, 'Address', '${user.contact.address}, ${user.contact.district}'),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[500]),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.jost(fontSize: 12, color: Colors.grey[500])),
              Text(value, style: GoogleFonts.jost(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(ThemeData theme) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: theme.primaryColor,
        side: BorderSide(color: theme.primaryColor),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border),
          const SizedBox(width: 12),
          Text('My Saved Businesses', style: GoogleFonts.jost(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
