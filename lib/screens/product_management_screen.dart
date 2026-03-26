import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/data_providers.dart';
import '../features/auth/providers/auth_provider.dart';

class ProductManagementScreen extends ConsumerStatefulWidget {
  const ProductManagementScreen({super.key});
  @override
  ConsumerState<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends ConsumerState<ProductManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _categories = [];
  List<dynamic> _products = [];
  List<dynamic> _optionGroups = [];
  bool _loading = true;

  static const Color _navy = Color(0xFF1A3C5E);
  static const Color _accent = Color(0xFF2E6DA4);
  static const Color _bg = Color(0xFFF4F8FD);
  static const Color _green = Color(0xFF15803D);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAll());
  }

  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  Future<void> _loadAll() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final authState = ref.read(authProvider);
      final userId = authState.user?.id ?? '';
      final businessId = authState.business?.id ?? '';
      if (userId.isEmpty || businessId.isEmpty) return;

      await Future.wait([
        _loadCategories(userId, businessId),
        _loadProducts(userId, businessId),
        _loadOptions(),
      ]);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadCategories(String userId, String businessId) async {
    try {
       final data = await ref.read(productRepositoryProvider).getProductCategories(userId, businessId);
       if (mounted) setState(() => _categories = data is List ? data : (data['data'] ?? []));
    } catch (e) { debugPrint('Load categories: $e'); }
  }

  Future<void> _loadProducts(String userId, String businessId) async {
    try {
      final data = await ref.read(productRepositoryProvider).getProductsRaw(userId, businessId);
      if (mounted) setState(() => _products = data is List ? data : (data['data'] ?? []));
    } catch (e) { debugPrint('Load products: $e'); }
  }

  Future<void> _loadOptions() async {
    try {
      final data = await ref.read(productRepositoryProvider).fetchProductOptions();
      if (mounted) setState(() => _optionGroups = data is List ? data : (data['data'] ?? []));
    } catch (e) { debugPrint('Load options: $e'); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: Text('Products & Menu', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: _navy, unselectedLabelColor: Colors.grey, indicatorColor: _navy,
          labelStyle: GoogleFonts.jost(fontWeight: FontWeight.bold),
          tabs: [
            Tab(text: 'Categories (${_categories.length})'),
            Tab(text: 'Products (${_products.length})'),
            Tab(text: 'Options (${_optionGroups.length})'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _navy))
          : TabBarView(controller: _tabController, children: [
              _buildCategoriesTab(),
              _buildProductsTab(),
              _buildOptionsTab(),
            ]),
    );
  }

  // ── CATEGORIES TAB ──────────────────────────────────────────────────

  Widget _buildCategoriesTab() {
    return Column(
      children: [
        _tabHeader('Menu Categories', 'Add Category', Icons.add, () => _showCategoryDialog()),
        Expanded(
          child: _categories.isEmpty
              ? _emptyState('No categories yet', 'Create categories like Starters, Mains, Drinks')
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _categories.length,
                  itemBuilder: (ctx, i) {
                    final cat = _categories[i];
                    return _card(
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: _accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                          child: Icon(Icons.folder_outlined, color: _accent, size: 20),
                        ),
                        title: Text(cat['name'] ?? '', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit_outlined, size: 20, color: _accent), onPressed: () => _showCategoryDialog(cat: cat)),
                            IconButton(icon: Icon(Icons.delete_outline, size: 20, color: Colors.red.shade400), onPressed: () => _deleteCategory(cat['_id'])),
                          ],
                        ),
                      ),
                    );
                  }),
        ),
      ],
    );
  }

  void _showCategoryDialog({dynamic cat}) {
    final ctrl = TextEditingController(text: cat?['name'] ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(cat == null ? 'Add Category' : 'Edit Category', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        content: TextField(controller: ctrl, decoration: _inputDeco('Category Name (e.g. Burgers)'), autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (ctrl.text.trim().isEmpty) return;
              Navigator.pop(ctx);
              final authState = ref.read(authProvider);
              final userId = authState.user?.id ?? '';
              final businessId = authState.business?.id ?? '';
              if (cat == null) {
                await ref.read(productRepositoryProvider).createCategory({'name': ctrl.text.trim(), 'user': userId, 'business': businessId});
              } else {
                await ref.read(productRepositoryProvider).updateCategory(cat['_id'], {'name': ctrl.text.trim()});
              }
              await _loadCategories(userId, businessId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: _navy, foregroundColor: Colors.white),
            child: Text(cat == null ? 'Create' : 'Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCategory(String id) async {
    final confirmed = await _confirmDelete('category');
    if (!confirmed) return;
    await ref.read(productRepositoryProvider).deleteCategory(id);
    final authState = ref.read(authProvider);
    await _loadCategories(authState.user?.id ?? '', authState.business?.id ?? '');
  }

  // ── PRODUCTS TAB ────────────────────────────────────────────────────

  Widget _buildProductsTab() {
    return Column(
      children: [
        _tabHeader('All Products', 'Add Product', Icons.add, () => _showProductDialog()),
        Expanded(
          child: _products.isEmpty
              ? _emptyState('No products yet', 'Add your first product to build your menu')
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 0.72,
                  ),
                  itemCount: _products.length,
                  itemBuilder: (ctx, i) => _buildProductCard(_products[i]),
                ),
        ),
      ],
    );
  }

  Widget _buildProductCard(dynamic product) {
    final name = product['name'] ?? '';
    final price = (product['price'] ?? 0).toDouble();
    final currency = product['currency'] ?? 'GBP';
    final discount = (product['memberDiscount'] ?? 0).toDouble();
    final imageUrl = product['coverPhoto'] ?? product['image'] ?? '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            height: 100, width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              image: imageUrl.isNotEmpty ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover) : null,
            ),
            child: imageUrl.isEmpty ? Center(child: Icon(Icons.restaurant_outlined, color: Colors.grey[300], size: 36)) : null,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (discount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(color: _green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text('Member ${discount.toInt()}% off', style: GoogleFonts.jost(fontSize: 9, color: _green, fontWeight: FontWeight.bold)),
                    ),
                  Text(name, style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$currency ${price.toStringAsFixed(2)}', style: GoogleFonts.jost(color: _navy, fontWeight: FontWeight.bold, fontSize: 14)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () => _showProductDialog(product: product),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(color: _accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                              child: Icon(Icons.edit, size: 14, color: _accent),
                            ),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () => _deleteProduct(product['_id']),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                              child: Icon(Icons.delete_outline, size: 14, color: Colors.red.shade400),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProductDialog({dynamic product}) {
    final isEdit = product != null;
    final nameCtrl = TextEditingController(text: product?['name'] ?? '');
    final descCtrl = TextEditingController(text: product?['description'] ?? '');
    final priceCtrl = TextEditingController(text: product?['price']?.toString() ?? '');
    final discountCtrl = TextEditingController(text: product?['memberDiscount']?.toString() ?? '');
    String? selectedCatId = product?['category']?['_id'] ?? product?['category'];
    String currency = product?['currency'] ?? 'GBP';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(isEdit ? 'Edit Product' : 'Add Product', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameCtrl, decoration: _inputDeco('Product Name')),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: _inputDeco('Category'),
                    initialValue: _categories.any((c) => c['_id'] == selectedCatId) ? selectedCatId : null,
                    items: _categories.map<DropdownMenuItem<String>>((c) => DropdownMenuItem(value: c['_id'], child: Text(c['name'] ?? ''))).toList(),
                    onChanged: (v) => setDlg(() => selectedCatId = v),
                  ),
                  const SizedBox(height: 12),
                  TextField(controller: descCtrl, decoration: _inputDeco('Description'), maxLines: 3),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: priceCtrl, decoration: _inputDeco('Price'), keyboardType: TextInputType.number)),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 100,
                        child: DropdownButtonFormField<String>(
                          decoration: _inputDeco('Currency'),
                          initialValue: currency,
                          items: ['GBP', 'USD', 'EUR', 'BDT'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                          onChanged: (v) => setDlg(() => currency = v ?? 'GBP'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(controller: discountCtrl, decoration: _inputDeco('Member Discount % (optional)'), keyboardType: TextInputType.number),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.isEmpty || priceCtrl.text.isEmpty) return;
                Navigator.pop(ctx);
                final authState = ref.read(authProvider);
                final userId = authState.user?.id ?? '';
                final businessId = authState.business?.id ?? '';
                final data = {
                  'name': nameCtrl.text.trim(),
                  'description': descCtrl.text.trim(),
                  'price': double.tryParse(priceCtrl.text) ?? 0,
                  'currency': currency,
                  'category': selectedCatId,
                  'business': businessId,
                  'user': userId,
                  'memberDiscount': double.tryParse(discountCtrl.text) ?? 0,
                };
                if (isEdit) {
                  await ref.read(productRepositoryProvider).updateProduct(product['_id'], data);
                } else {
                  await ref.read(productRepositoryProvider).createProduct(data);
                }
                await _loadProducts(userId, businessId);
              },
              style: ElevatedButton.styleFrom(backgroundColor: _navy, foregroundColor: Colors.white),
              child: Text(isEdit ? 'Save' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteProduct(String id) async {
    final confirmed = await _confirmDelete('product');
    if (!confirmed) return;
    await ref.read(productRepositoryProvider).deleteProduct(id);
    final authState = ref.read(authProvider);
    await _loadProducts(authState.user?.id ?? '', authState.business?.id ?? '');
  }

  // ── OPTIONS TAB ─────────────────────────────────────────────────────

  Widget _buildOptionsTab() {
    return Column(
      children: [
        _tabHeader('Product Options', 'Add Option Group', Icons.add, () => _showOptionDialog()),
        Expanded(
          child: _optionGroups.isEmpty
              ? _emptyState('No option groups yet', 'Create groups like Size, Sauce, Extras')
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _optionGroups.length,
                  itemBuilder: (ctx, i) {
                    final group = _optionGroups[i];
                    final name = group['name'] ?? group['groupName'] ?? '';
                    final choices = (group['options'] ?? group['choices'] ?? []) as List;
                    return _card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(color: _accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                                  child: Icon(Icons.tune, color: _accent, size: 18),
                                ),
                                const SizedBox(width: 10),
                                Expanded(child: Text(name, style: GoogleFonts.jost(fontSize: 15, fontWeight: FontWeight.bold))),
                                IconButton(icon: const Icon(Icons.edit_outlined, size: 18, color: _accent), onPressed: () => _showOptionDialog(group: group)),
                                IconButton(icon: Icon(Icons.delete_outline, size: 18, color: Colors.red.shade400), onPressed: () => _deleteOption(group['_id'])),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8, runSpacing: 6,
                              children: choices.map<Widget>((c) {
                                final label = c is String ? c : (c['name'] ?? c.toString());
                                return Chip(
                                  label: Text(label, style: GoogleFonts.jost(fontSize: 12)),
                                  backgroundColor: _bg,
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  visualDensity: VisualDensity.compact,
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
        ),
      ],
    );
  }

  void _showOptionDialog({dynamic group}) {
    final isEdit = group != null;
    final nameCtrl = TextEditingController(text: group?['name'] ?? group?['groupName'] ?? '');
    final choices = List<String>.from(
      ((group?['options'] ?? group?['choices'] ?? []) as List).map((c) => c is String ? c : (c['name'] ?? c.toString())),
    );
    final choiceCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(isEdit ? 'Edit Option Group' : 'Add Option Group', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 350,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameCtrl, decoration: _inputDeco('Group Name (e.g. Size)')),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: choiceCtrl, decoration: _inputDeco('Add choice'))),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: _navy, borderRadius: BorderRadius.circular(6)),
                          child: const Icon(Icons.add, color: Colors.white, size: 18),
                        ),
                        onPressed: () {
                          if (choiceCtrl.text.trim().isNotEmpty) {
                            setDlg(() => choices.add(choiceCtrl.text.trim()));
                            choiceCtrl.clear();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6, runSpacing: 6,
                    children: choices.asMap().entries.map((e) => Chip(
                      label: Text(e.value, style: GoogleFonts.jost(fontSize: 12)),
                      deleteIcon: const Icon(Icons.close, size: 14),
                      onDeleted: () => setDlg(() => choices.removeAt(e.key)),
                      backgroundColor: _bg,
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.isEmpty) return;
                Navigator.pop(ctx);
                final authState = ref.read(authProvider);
                final data = {
                  'name': nameCtrl.text.trim(),
                  'options': choices.map((c) => {'name': c}).toList(),
                  'business': authState.business?.id ?? '',
                  'user': authState.user?.id ?? '',
                };
                if (isEdit) {
                  await ref.read(productRepositoryProvider).updateProductOption(group['_id'], data);
                } else {
                  await ref.read(productRepositoryProvider).createProductOption(data);
                }
                await _loadOptions();
              },
              style: ElevatedButton.styleFrom(backgroundColor: _navy, foregroundColor: Colors.white),
              child: Text(isEdit ? 'Save' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteOption(String id) async {
    final confirmed = await _confirmDelete('option group');
    if (!confirmed) return;
    await ref.read(productRepositoryProvider).deleteProductOption(id);
    await _loadOptions();
  }

  // ── SHARED WIDGETS ──────────────────────────────────────────────────

  Widget _tabHeader(String title, String btnLabel, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.jost(fontSize: 17, fontWeight: FontWeight.bold)),
          ElevatedButton.icon(
            onPressed: onTap,
            icon: Icon(icon, size: 16),
            label: Text(btnLabel, style: GoogleFonts.jost(fontWeight: FontWeight.w600, fontSize: 13)),
            style: ElevatedButton.styleFrom(
              backgroundColor: _navy, foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(14),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3))],
    ),
    child: child,
  );

  Widget _emptyState(String title, String subtitle) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inventory_2_outlined, size: 56, color: Colors.grey[300]),
        const SizedBox(height: 16),
        Text(title, style: GoogleFonts.jost(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey[600])),
        const SizedBox(height: 6),
        Text(subtitle, style: GoogleFonts.jost(color: Colors.grey[400], fontSize: 13)),
      ],
    ),
  );

  InputDecoration _inputDeco(String label) => InputDecoration(
    labelText: label,
    labelStyle: GoogleFonts.jost(fontSize: 13),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  );

  Future<bool> _confirmDelete(String item) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete $item?', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        content: Text('This action cannot be undone.', style: GoogleFonts.jost()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false;
  }
}
