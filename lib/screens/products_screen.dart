import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'product_form_bottom_sheet.dart';
import '../data/models/product.dart';
import '../providers/data_providers.dart';
import '../features/auth/providers/auth_provider.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Color navy = const Color(0xFF1A3C5E);
  final Color accentBlue = const Color(0xFF3B82F6);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FD),
      appBar: AppBar(
        title: Text('Menu Management', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 14),
          unselectedLabelStyle: GoogleFonts.jost(fontWeight: FontWeight.w500, fontSize: 14),
          labelColor: navy,
          unselectedLabelColor: Colors.grey,
          indicatorColor: navy,
          tabs: const [
            Tab(text: 'Categories'),
            Tab(text: 'Products'),
            Tab(text: 'Options'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CategoriesTab(),
          _ProductsTab(),
          _OptionsTab(),
        ],
      ),
    );
  }
}

class _CategoriesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color navy = const Color(0xFF1A3C5E);
    final cartRepo = ref.watch(productRepositoryProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(context, ref),
        backgroundColor: navy,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: cartRepo.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          final categories = snapshot.data ?? [];
          if (categories.isEmpty) return const Center(child: Text('No categories found'));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(cat['name'] ?? '', style: GoogleFonts.jost(fontWeight: FontWeight.bold, color: navy)),
                  subtitle: Text(cat['slug'] ?? '', style: GoogleFonts.jost(fontSize: 12)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => _showCategoryDialog(context, ref, category: cat)),
                      IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _handleDeleteCategory(context, ref, cat['_id'])),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showCategoryDialog(BuildContext context, WidgetRef ref, {dynamic category}) {
    final nameCtrl = TextEditingController(text: category?['name'] ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(category == null ? 'Add Category' : 'Edit Category'),
        content: TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              if (nameCtrl.text.isEmpty) return;
              Navigator.pop(ctx);
              final repo = ref.read(productRepositoryProvider);
              final auth = ref.read(authProvider);
              final data = {'name': nameCtrl.text, 'user': auth.user?.id, 'business': auth.business?.id};
              if (category == null) {
                await repo.createCategory(data);
              } else {
                await repo.updateCategory(category['_id'], data);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _handleDeleteCategory(BuildContext context, WidgetRef ref, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Category?'),
        content: const Text('This will delete all associated data.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;
    if (confirmed) await ref.read(productRepositoryProvider).deleteCategory(id);
  }
}

class _ProductsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color navy = const Color(0xFF1A3C5E);
    final user = ref.watch(authProvider).user;
    final businessId = ref.watch(authProvider).user?.id ?? ''; // Business ID or owner ID check
    final repo = ref.watch(productRepositoryProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductForm(context),
        backgroundColor: navy,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: FutureBuilder<List<Product>>(
        future: repo.getProductsByBusiness(businessId, userId: user?.id ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          final products = snapshot.data ?? [];
          if (products.isEmpty) return const Center(child: Text('No products found'));

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final prod = products[index];
              return _ProductCard(
                product: prod,
                onTap: () => _showProductForm(context, product: prod),
                onDelete: () => _handleDeleteProduct(context, ref, prod.id),
              );
            },
          );
        },
      ),
    );
  }

  void _showProductForm(BuildContext context, {Product? product}) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ProductFormBottomSheet(product: product),
    );
    if (result == true) {
      // Refresh logic would ideally use a provider instead of FutureBuilder, 
      // but for simplicity here we assume the widget re-renders or manually trigged refresh.
    }
  }

  void _handleDeleteProduct(BuildContext context, WidgetRef ref, String id) async {
    final confirmed = await _showDeleteConfirm(context);
    if (confirmed) {
      await ref.read(productRepositoryProvider).deleteProduct(id);
    }
  }

  Future<bool> _showDeleteConfirm(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Product?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  const _ProductCard({required this.product, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final Color navy = const Color(0xFF1A3C5E);
    final hasDiscount = product.discountPercent > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: product.thumbnail.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: product.thumbnail,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(color: Colors.grey[100]),
                            errorWidget: (context, url, error) => const Icon(Icons.image),
                          )
                        : Container(color: Colors.grey[100], child: const Icon(Icons.image_outlined, color: Colors.grey)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 14, color: navy),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${product.currency} ${product.finalPrice.toStringAsFixed(2)}',
                            style: GoogleFonts.jost(fontWeight: FontWeight.w600, color: hasDiscount ? Colors.red : navy),
                          ),
                          GestureDetector(
                            onTap: onDelete,
                            child: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (hasDiscount)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF15803D), borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    '${product.discountPercent}% OFF',
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _OptionsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color navy = const Color(0xFF1A3C5E);
    final repo = ref.watch(productRepositoryProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showOptionDialog(context, ref),
        backgroundColor: navy,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: repo.fetchProductOptions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          final Map<String, dynamic> data = snapshot.data ?? {};
          final List options = data['data'] ?? [];
          if (options.isEmpty) return const Center(child: Text('No options found'));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: options.length,
            itemBuilder: (context, index) {
              final opt = options[index];
              final List choices = opt['choices'] ?? [];
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ExpansionTile(
                  title: Text(opt['name'] ?? '', style: GoogleFonts.jost(fontWeight: FontWeight.bold, color: navy)),
                  subtitle: Text('${choices.length} choices', style: GoogleFonts.jost(fontSize: 12)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => _showOptionDialog(context, ref, option: opt)),
                      IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _handleDeleteOption(context, ref, opt['_id'])),
                      const Icon(Icons.expand_more),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Wrap(
                        spacing: 8,
                        children: choices.map((c) => Chip(
                          label: Text(c, style: const TextStyle(fontSize: 12)),
                          backgroundColor: Colors.grey[100],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          side: BorderSide.none,
                        )).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showOptionDialog(BuildContext context, WidgetRef ref, {dynamic option}) {
    final nameCtrl = TextEditingController(text: option?['name'] ?? '');
    final choiceCtrl = TextEditingController(text: (option?['choices'] as List?)?.join(', ') ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(option == null ? 'Add Option Group' : 'Edit Option Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Group Name (e.g. Size)')),
            TextField(controller: choiceCtrl, decoration: const InputDecoration(labelText: 'Choices (comma separated)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              if (nameCtrl.text.isEmpty) return;
              Navigator.pop(ctx);
              final repo = ref.read(productRepositoryProvider);
              final choices = choiceCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
              final data = {'name': nameCtrl.text, 'choices': choices};
              if (option == null) {
                await repo.createProductOption(data);
              } else {
                await repo.updateProductOption(option['_id'], data);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _handleDeleteOption(BuildContext context, WidgetRef ref, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Option Group?'),
        content: const Text('This will remove it from all products.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;
    if (confirmed) await ref.read(productRepositoryProvider).deleteProductOption(id);
  }
}
