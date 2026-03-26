import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/data_providers.dart';
import '../features/auth/providers/auth_provider.dart';
import '../data/models/business.dart';
import '../data/models/product.dart';

class BusinessDetailScreen extends ConsumerStatefulWidget {
  final Business? business;
  final String businessId;

  const BusinessDetailScreen({super.key, required this.businessId, this.business});

  @override
  ConsumerState<BusinessDetailScreen> createState() => _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends ConsumerState<BusinessDetailScreen> {
  Business? _business;
  List<Product> _products = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _business = widget.business;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    if (_business == null) {
      await _fetchBusiness();
    }
    await _fetchProducts();
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _fetchBusiness() async {
    try {
      final biz = await ref.read(businessRepositoryProvider).getBusinessBySlug(widget.businessId);
      if (mounted) _business = biz;
    } catch (e) {
      debugPrint('Error loading business: $e');
    }
  }

  Future<void> _fetchProducts() async {
    if (_business == null) return;
    try {
      final prods = await ref.read(productRepositoryProvider).getProductsByBusiness(
        _business!.id,
        userId: _business!.ownerId,
      );
      if (mounted) _products = prods;
    } catch (e) {
      debugPrint('Error loading products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _business == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_business == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Business not found')),
      );
    }

    final biz = _business!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F1),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(biz),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBasicInfo(biz, theme),
                  const Divider(height: 40),
                  _buildAboutSection(biz, theme),
                  const Divider(height: 40),
                  if (_products.isNotEmpty) ...[
                    _buildProductsSection(_products, theme),
                    const Divider(height: 40),
                  ],
                  _buildFeaturesSection(biz, theme),
                  const Divider(height: 40),
                  _buildOpeningHours(biz, theme),
                  const Divider(height: 40),
                  _buildContactSection(biz, theme),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFABs(context, biz),
    );
  }

  Widget _buildProductsSection(List<Product> products, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Products',
          style: GoogleFonts.jost(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (ctx, idx) => const SizedBox(width: 16),
            itemBuilder: (ctx, idx) {
              final prod = products[idx];
              return Container(
                width: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: prod.thumbnail.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: prod.thumbnail,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (ctx, url) => Container(color: Colors.grey[100]),
                                errorWidget: (ctx, url, err) => Container(color: Colors.grey[200], child: const Icon(Icons.shopping_bag_outlined)),
                              )
                            : Container(color: Colors.grey[200], child: const Icon(Icons.shopping_bag_outlined, size: 40)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prod.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Text(
                            '${prod.currency} ${prod.finalPrice}',
                            style: GoogleFonts.jost(color: theme.primaryColor, fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(Business biz) {
    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: biz.media.images.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: biz.media.images[0].url,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.grey[200]),
              )
            : Container(color: Colors.grey[300]),
      ),
    );
  }

  Widget _buildBasicInfo(Business biz, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                biz.businessName,
                style: GoogleFonts.jost(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            if (biz.isHalal)
              const Icon(Icons.verified, color: Colors.green, size: 30),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.location_on, size: 18, color: theme.primaryColor),
            const SizedBox(width: 4),
            Text(
              '${biz.locations.city}, ${biz.locations.country}',
              style: GoogleFonts.jost(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAboutSection(Business biz, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: GoogleFonts.jost(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          biz.about,
          style: GoogleFonts.jost(fontSize: 16, height: 1.6, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(Business biz, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Features',
          style: GoogleFonts.jost(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            if (biz.isHalal) _buildFeatureChip(Icons.check_circle_outline, 'Halal'),
            if (biz.operationDetails.provideHomeDelivery) _buildFeatureChip(Icons.delivery_dining, 'Home Delivery'),
            if (biz.operationDetails.isParkingAvailable) _buildFeatureChip(Icons.local_parking, 'Parking'),
            if (biz.operationDetails.provideOnlineService) _buildFeatureChip(Icons.online_prediction, 'Online Service'),
            if (biz.features.isWheelChairAccessible) _buildFeatureChip(Icons.accessible, 'Wheelchair Accessible'),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildOpeningHours(Business biz, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Opening Hours',
          style: GoogleFonts.jost(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...biz.openingHours.map((oh) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(oh.day, style: const TextStyle(fontSize: 16)),
                  Text(
                    oh.start != null ? '${oh.start} - ${oh.end}' : 'Closed',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: oh.start != null ? Colors.black87 : Colors.red,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildContactSection(Business biz, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Details',
          style: GoogleFonts.jost(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildContactTile(Icons.phone, 'Phone', biz.contactDetails.phoneNumber),
        _buildContactTile(Icons.email, 'Email', biz.contactDetails.email),
        if (biz.contactDetails.websiteUrl.isNotEmpty)
          _buildContactTile(Icons.language, 'Website', biz.contactDetails.websiteUrl),
        if (biz.operationDetails.whatsappNumber.isNotEmpty)
          _buildContactTile(Icons.message, 'WhatsApp', biz.operationDetails.whatsappNumber),
      ],
    );
  }

  Widget _buildContactTile(IconData icon, String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: IconButton(
        icon: const Icon(Icons.copy_all, size: 20),
        onPressed: () {}, // Implement copy to clipboard
      ),
    );
  }

  Widget _buildFABs(BuildContext context, Business biz) {
    final auth = ref.watch(authProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (auth.isAuthenticated)
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: FloatingActionButton.extended(
              heroTag: 'review',
              onPressed: () => context.push(
                '/business/${biz.id}/review',
                extra: {'businessName': biz.businessName},
              ),
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor,
              icon: const Icon(Icons.rate_review_outlined),
              label: const Text('Review'),
            ),
          ),
        FloatingActionButton.extended(
          heroTag: 'call',
          onPressed: () {}, // Implement dialer
          backgroundColor: Theme.of(context).primaryColor,
          icon: const Icon(Icons.phone),
          label: const Text('Call Now'),
        ),
      ],
    );
  }
}
