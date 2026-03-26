import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../data/models/business.dart';
import '../providers/data_providers.dart';
import '../features/auth/providers/auth_provider.dart';

class MyBusinessScreen extends ConsumerStatefulWidget {
  const MyBusinessScreen({super.key});

  @override
  ConsumerState<MyBusinessScreen> createState() => _MyBusinessScreenState();
}

class _MyBusinessScreenState extends ConsumerState<MyBusinessScreen> {
  bool _isLoading = true;
  List<Business> _businesses = [];

  @override
  void initState() {
    super.initState();
    _loadBusinesses();
  }

  Future<void> _loadBusinesses() async {
    setState(() => _isLoading = true);
    try {
      final user = ref.read(authProvider).user;
      if (user != null) {
        // Fetch businesses where owner is this user
        final bizList = await ref.read(businessRepositoryProvider).getBusinesses(
          query: user.id, // Assuming backend supports filtering by owner ID via query
        );
        if (mounted) {
          setState(() {
            _businesses = bizList;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color navy = const Color(0xFF1A3C5E);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FD),
      appBar: AppBar(
        title: Text('My Businesses', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/owner/edit-business'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1A3C5E)))
          : _businesses.isEmpty
              ? _buildEmptyState(context, navy)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _businesses.length,
                  itemBuilder: (context, index) {
                    final biz = _businesses[index];
                    return _buildBusinessCard(context, biz, navy);
                  },
                ),
    );
  }

  Widget _buildEmptyState(BuildContext context, Color navy) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.storefront_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 24),
          Text(
            'No businesses found',
            style: GoogleFonts.jost(fontSize: 20, fontWeight: FontWeight.bold, color: navy),
          ),
          const SizedBox(height: 12),
          Text(
            'You haven\'t added any businesses yet.',
            style: GoogleFonts.jost(color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.push('/owner/edit-business'),
            style: ElevatedButton.styleFrom(
              backgroundColor: navy,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('ADD BUSINESS'),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessCard(BuildContext context, Business biz, Color navy) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                image: biz.logo.isNotEmpty
                    ? DecorationImage(image: NetworkImage(biz.logo), fit: BoxFit.cover)
                    : null,
              ),
              child: biz.logo.isEmpty ? const Icon(Icons.store, color: Colors.grey) : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    biz.businessName,
                    style: GoogleFonts.jost(fontSize: 18, fontWeight: FontWeight.bold, color: navy),
                  ),
                  Text(
                    biz.locations.address,
                    style: GoogleFonts.jost(color: Colors.grey[600], fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: biz.isActive ? Colors.green[50] : Colors.orange[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          biz.isActive ? 'Active' : 'Pending',
                          style: TextStyle(
                            color: biz.isActive ? Colors.green[800] : Colors.orange[800],
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.push('/owner/edit-business', extra: biz),
            ),
          ],
        ),
      ),
    );
  }
}
