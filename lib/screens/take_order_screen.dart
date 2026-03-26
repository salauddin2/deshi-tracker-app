import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/data_providers.dart';
import '../data/models/order.dart';
import '../features/auth/providers/auth_provider.dart';
import '../models/product.dart';

class TakeOrderScreen extends ConsumerStatefulWidget {
  const TakeOrderScreen({super.key});
  @override
  ConsumerState<TakeOrderScreen> createState() => _TakeOrderScreenState();
}

class _TakeOrderScreenState extends ConsumerState<TakeOrderScreen> {
  List<dynamic> _categories = [];
  List<Product> _products = [];
  String? _selectedCategoryId;
  final List<Map<String, dynamic>> _cartItems = [];
  bool _loadingProducts = true;

  final _tableCtrl = TextEditingController();
  final _customerCtrl = TextEditingController();

  static const Color navy = Color(0xFF1A3C5E);
  static const Color bg = Color(0xFFF4F8FD);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  void dispose() {
    _tableCtrl.dispose();
    _customerCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _loadingProducts = true);
    try {
      final auth = ref.read(authProvider);
      final userId = auth.user?.id ?? '';
      final businessId = auth.business?.id ?? '';

      if (userId.isEmpty || businessId.isEmpty) return;

      final productRepo = ref.read(productRepositoryProvider);
      
      final categoryRes = await productRepo.getProductCategories(userId, businessId);
      final productsRes = await productRepo.getProductsRaw(userId, businessId);

      if (mounted) {
        setState(() {
          _categories = categoryRes is List ? categoryRes : (categoryRes['data'] ?? []);
          if (_categories.isNotEmpty && _selectedCategoryId == null) {
            _selectedCategoryId = _categories[0]['_id'];
          }
          
          final list = productsRes is List ? productsRes : (productsRes['data'] ?? []);
          _products = list.map<Product>((e) => Product.fromJson(e)).toList();
          _loadingProducts = false;
        });
      }
    } catch (e) {
      debugPrint('Load data error: $e');
      if (mounted) setState(() => _loadingProducts = false);
    }
  }

  List<Product> get _filteredProducts {
    if (_selectedCategoryId == null) return _products;
    return _products.where((p) => p.categoryId == _selectedCategoryId).toList();
  }

  double get _subtotal => _cartItems.fold(0, (sum, item) => sum + item['price'] * item['quantity']);

  void _addToCart(Product product) {
    if (product.options.isNotEmpty) {
      _showOptionModal(product);
    } else {
      _addItem(product, {});
    }
  }

  void _addItem(Product product, Map<String, String> selectedOptions) {
    setState(() {
      final existingIndex = _cartItems.indexWhere(
        (item) => item['productId'] == product.id && item['options'].toString() == selectedOptions.toString()
      );
      
      if (existingIndex != -1) {
        _cartItems[existingIndex]['quantity']++;
      } else {
        _cartItems.add({
          'lineId': DateTime.now().millisecondsSinceEpoch.toString(),
          'productId': product.id,
          'name': product.name,
          'price': product.price,
          'quantity': 1,
          'currency': product.currency,
          'options': selectedOptions,
          'selectedOptions': selectedOptions.entries.map((e) => {
            'optionGroupName': e.key,
            'value': e.value,
          }).toList(),
        });
      }
    });
  }

  void _showOptionModal(Product product) {
    final Map<String, String> selected = {};
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setMdState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom + 16, top: 20, left: 20, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name, style: GoogleFonts.jost(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...product.options.map((optGroup) {
                final groupName = optGroup['name'] ?? optGroup['groupName'] ?? '';
                final choices = (optGroup['options'] ?? optGroup['choices'] ?? []) as List;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(groupName, style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: choices.map((c) {
                        final label = c is String ? c : (c['name'] ?? c.toString());
                        final isSelected = selected[groupName] == label;
                        return ChoiceChip(
                          label: Text(label),
                          selected: isSelected,
                          selectedColor: navy,
                          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                          onSelected: (_) => setMdState(() => selected[groupName] = label),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              }),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _addItem(product, Map<String, String>.from(selected));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: navy, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text('Add to Order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveOrder({bool andPrint = false}) async {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cart is empty')));
      return;
    }
    
    setState(() => _loadingProducts = true);
    final auth = ref.read(authProvider);
    final businessId = auth.business?.id ?? '';
    final userId = auth.user?.id ?? '';
    
    if (businessId.isEmpty || userId.isEmpty) {
       setState(() => _loadingProducts = false);
       return;
    }

    final items = _cartItems.map((item) => {
      'lineId': item['lineId'],
      'productId': item['productId'],
      'name': item['name'],
      'price': item['price'],
      'quantity': item['quantity'],
      'currency': item['currency'],
      'selectedOptions': item['selectedOptions'],
    }).toList();

    try {
      final orderData = {
        'business_id': businessId,
        'user_id': userId,
        'owner_id': userId,
        'tableNo': _tableCtrl.text.trim(),
        'notes': _customerCtrl.text.trim(),
        'items': items,
        'totals': {
          'subtotal': _subtotal,
          'totalQty': _cartItems.fold<int>(0, (sum, item) => sum + (item['quantity'] as int)),
        },
        'currency': 'GBP',
      };

      final res = await ref.read(orderRepositoryProvider).createOrder(orderData);

      if (andPrint && mounted) {
        final dynamic resData = res;
        final Map<String, dynamic> rawOrder = resData is List ? resData[0] : (resData['data'] ?? resData);
        final order = Order.fromJson(rawOrder);
        await ref.read(printServiceProvider).printReceipt(order);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Order saved!'), backgroundColor: Colors.green),
      );
      setState(() { _cartItems.clear(); _tableCtrl.clear(); _customerCtrl.clear(); });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red),
      );
    }
    setState(() => _loadingProducts = false);
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text('Order Pad', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: isWide ? _buildWideLayout() : _buildNarrowLayout(),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      children: [
        Expanded(flex: 5, child: _buildProductPanel()),
        Container(width: 1, color: Colors.grey[200]),
        SizedBox(width: MediaQuery.of(context).size.width * 0.35, child: _buildCartPanel()),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return Stack(
      children: [
        _buildProductPanel(),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.extended(
            onPressed: () => _showCartSheet(),
            backgroundColor: navy,
            icon: const Icon(Icons.shopping_cart_outlined),
            label: Text(
              '${_cartItems.fold<int>(0, (s, i) => s + (i['quantity'] as int))} items  •  £${_subtotal.toStringAsFixed(2)}',
              style: GoogleFonts.jost(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category tab row
        SizedBox(
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            itemCount: _categories.length,
            itemBuilder: (context, i) {
              final cat = _categories[i];
              final isSelected = _selectedCategoryId == cat['_id'];
              return GestureDetector(
                onTap: () => setState(() => _selectedCategoryId = cat['_id']),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? navy : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
                  ),
                  alignment: Alignment.center,
                  child: Text(cat['name'] ?? '', style: GoogleFonts.jost(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              );
            },
          ),
        ),
        // Product grid
        Expanded(
          child: _loadingProducts
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, i) => _buildProductCard(_filteredProducts[i]),
                ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product) {
    return InkWell(
      onTap: () => _addToCart(product),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(product.name, style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('£${product.price.toStringAsFixed(2)}', style: GoogleFonts.jost(color: navy, fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(6)),
                  child: const Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartPanel() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Current Order', style: GoogleFonts.jost(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          // Table & customer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(controller: _tableCtrl, decoration: _inputDeco('Table Number (optional)'), keyboardType: TextInputType.number),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(controller: _customerCtrl, decoration: _inputDeco('Notes / Customer Name')),
          ),
          const SizedBox(height: 8),
          const Divider(),
          // Cart items
          Expanded(
            child: _cartItems.isEmpty
                ? Center(child: Text('No items added yet', style: GoogleFonts.jost(color: Colors.grey[400])))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, i) => _buildCartItem(i),
                  ),
          ),
          const Divider(),
          // Totals & actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal', style: GoogleFonts.jost(color: Colors.grey[600])),
                    Text('£${_subtotal.toStringAsFixed(2)}', style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _saveOrder(andPrint: false),
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Save Order'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _saveOrder(andPrint: true),
                    icon: const Icon(Icons.print_outlined),
                    label: const Text('Save & Print'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: navy,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: navy)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() => _cartItems.clear()),
                    icon: const Icon(Icons.clear_all_outlined),
                    label: const Text('Clear Cart'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(int index) {
    final item = _cartItems[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'], style: GoogleFonts.jost(fontWeight: FontWeight.w600)),
                if ((item['options'] as Map).isNotEmpty)
                  Text((item['options'] as Map).entries.map((e) => '${e.key}: ${e.value}').join(', '),
                      style: GoogleFonts.jost(color: Colors.grey[500], fontSize: 11)),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() {
                  if (item['quantity'] > 1) {
                    item['quantity']--;
                  } else {
                    _cartItems.removeAt(index);
                  }
                }),
                child: Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                  child: const Icon(Icons.remove, size: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('${item['quantity']}', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
              ),
              GestureDetector(
                onTap: () => setState(() => item['quantity']++),
                child: Container(
                  width: 28, height: 28,
                  decoration: const BoxDecoration(color: navy, shape: BoxShape.circle),
                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Text('£${(item['price'] * item['quantity']).toStringAsFixed(2)}', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showCartSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SizedBox(height: MediaQuery.of(context).size.height * 0.80, child: _buildCartPanel()),
    );
  }

  InputDecoration _inputDeco(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  );
}
