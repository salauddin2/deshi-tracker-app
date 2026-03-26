import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/data_providers.dart';

class MemberOffersScreen extends ConsumerStatefulWidget {
  const MemberOffersScreen({super.key});
  @override
  ConsumerState<MemberOffersScreen> createState() => _MemberOffersScreenState();
}

class _MemberOffersScreenState extends ConsumerState<MemberOffersScreen> {
  static const _navy = Color(0xFF1A3C5E);
  List _businesses = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final data = await ref.read(memberRepositoryProvider).getRestaurantsWithDiscounts();
      if (mounted) setState(() { _businesses = data; _loading = false; });
    } catch (_) { if (mounted) setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FD),
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: Text('Member Offers', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _businesses.isEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.local_offer_outlined, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('No member offers available yet.', style: GoogleFonts.inter(color: Colors.grey)),
                ]))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _businesses.length,
                    itemBuilder: (_, i) {
                      final b = _businesses[i];
                      final logo = b['logo'] ?? '';
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        clipBehavior: Clip.antiAlias,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          if (logo.isNotEmpty)
                            CachedNetworkImage(imageUrl: logo, height: 160, width: double.infinity, fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Container(height: 160, color: Colors.grey.shade100, child: const Icon(Icons.store, size: 48))),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(children: [
                                Expanded(child: Text(b['businessName'] ?? '', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16))),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(20)),
                                  child: Text('Members Save!', style: GoogleFonts.inter(color: Colors.green[700], fontWeight: FontWeight.bold, fontSize: 12)),
                                ),
                              ]),
                              const SizedBox(height: 8),
                              Text(b['description'] ?? '', style: GoogleFonts.inter(color: Colors.grey[600]), maxLines: 2, overflow: TextOverflow.ellipsis),
                            ]),
                          ),
                        ]),
                      );
                    },
                  ),
                ),
    );
  }
}
