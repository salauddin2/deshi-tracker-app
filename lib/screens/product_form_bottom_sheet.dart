import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../data/models/product.dart';
import '../providers/data_providers.dart';
import '../features/auth/providers/auth_provider.dart';

class ProductFormBottomSheet extends ConsumerStatefulWidget {
  final Product? product;
  const ProductFormBottomSheet({super.key, this.product});

  @override
  ConsumerState<ProductFormBottomSheet> createState() => _ProductFormBottomSheetState();
}

class _ProductFormBottomSheetState extends ConsumerState<ProductFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final Color navy = const Color(0xFF1A3C5E);

  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _discountController;
  late TextEditingController _startCtrl;
  late TextEditingController _endCtrl;

  String? _selectedCategoryId;
  String _currency = 'GBP';
  String? _thumbnailUrl;
  List<String> _galleryUrls = [];
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();
  File? _localThumbnail;
  final List<File> _localGallery = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name);
    _descController = TextEditingController(text: widget.product?.description);
    _priceController = TextEditingController(text: widget.product?.price.toString());
    _discountController = TextEditingController(text: widget.product?.discountPercent.toString());
    _selectedCategoryId = widget.product?.categoryId;
    _currency = widget.product?.currency ?? 'GBP';
    _thumbnailUrl = widget.product?.thumbnail;
    _galleryUrls = List.from(widget.product?.images ?? []);
    
    _startCtrl = TextEditingController(text: _fmtDate(widget.product?.discountStart));
    _endCtrl = TextEditingController(text: _fmtDate(widget.product?.discountEnd));
  }

  String _fmtDate(DateTime? dt) {
    if (dt == null) return '';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  Future<void> _pickThumbnail() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _localThumbnail = File(image.path));
    }
  }

  Future<void> _pickGallery() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() => _localGallery.addAll(images.map((e) => File(e.path))));
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(productRepositoryProvider);
      
      // Upload thumbnail if new
      if (_localThumbnail != null) {
        _thumbnailUrl = await repo.uploadProductImage(_localThumbnail!.path);
      }

      // Upload gallery if new
      for (var f in _localGallery) {
        final url = await repo.uploadProductImage(f.path);
        if (url != null) _galleryUrls.add(url);
      }

      final data = {
        'name': _nameController.text,
        'description': _descController.text,
        'price': double.tryParse(_priceController.text) ?? 0,
        'currency': _currency,
        'discount_percent': double.tryParse(_discountController.text) ?? 0,
        'discount_start': _startCtrl.text.isNotEmpty ? _parseDate(_startCtrl.text)?.toIso8601String() : null,
        'discount_end': _endCtrl.text.isNotEmpty ? _parseDate(_endCtrl.text)?.toIso8601String() : null,
        'product_category_id': _selectedCategoryId,
        'thumbnail': _thumbnailUrl,
        'images': _galleryUrls,
        'business_id': ref.read(authProvider).business?.id ?? ref.read(authProvider).user?.id,
      };

      if (widget.product != null) {
        await repo.updateProduct(widget.product!.id, data);
      } else {
        await repo.createProduct(data);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
    setState(() => _isLoading = false);
  }

  DateTime? _parseDate(String val) {
    try {
      final parts = val.split('/');
      return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
    } catch (_) {
      return null;
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController ctrl) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() => ctrl.text = _fmtDate(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product == null ? 'Add New Product' : 'Edit Product',
                style: GoogleFonts.jost(fontSize: 20, fontWeight: FontWeight.bold, color: navy),
              ),
              const SizedBox(height: 24),
              _buildImagePicker(),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: _inputDeco('Product Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              // Category Dropdown
              FutureBuilder<List<dynamic>>(
                future: ref.read(productRepositoryProvider).getCategories(),
                builder: (context, snapshot) {
                  final categories = snapshot.data ?? [];
                  return DropdownButtonFormField<String>(
                    initialValue: _selectedCategoryId,
                    decoration: _inputDeco('Category'),
                    items: categories.map((c) => DropdownMenuItem(value: c['_id'] as String, child: Text(c['name'] ?? ''))).toList(),
                    onChanged: (val) => setState(() => _selectedCategoryId = val),
                    validator: (v) => v == null ? 'Required' : null,
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: _inputDeco('Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: _inputDeco('Price'),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 100,
                    child: DropdownButtonFormField<String>(
                      initialValue: _currency,
                      decoration: _inputDeco('CCY'),
                      items: ['GBP', 'USD', 'EUR', 'BDT'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) => setState(() => _currency = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _discountController,
                decoration: _inputDeco('Discount %'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startCtrl,
                      decoration: _inputDeco('Starts'),
                      readOnly: true,
                      onTap: () => _selectDate(context, _startCtrl),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _endCtrl,
                      decoration: _inputDeco('Ends'),
                      readOnly: true,
                      onTap: () => _selectDate(context, _endCtrl),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildGalleryPicker(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text('Save Product', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickThumbnail,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: _localThumbnail != null
            ? ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.file(_localThumbnail!, fit: BoxFit.cover))
            : _thumbnailUrl != null
                ? ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.network(_thumbnailUrl!, fit: BoxFit.cover))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined, color: Colors.grey[400]),
                      const SizedBox(height: 8),
                      Text('Cover Photo', style: GoogleFonts.jost(color: Colors.grey[400], fontSize: 13)),
                    ],
                  ),
      ),
    );
  }

  Widget _buildGalleryPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product Gallery', style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              GestureDetector(
                onTap: _pickGallery,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Icon(Icons.add_photo_alternate_outlined, color: Colors.grey[400]),
                ),
              ),
              const SizedBox(width: 8),
              ..._galleryUrls.map((url) => _buildGalleryItem(url, isRemote: true)),
              ..._localGallery.map((file) => _buildGalleryItem(file.path, isRemote: false)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGalleryItem(String path, {required bool isRemote}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: isRemote ? NetworkImage(path) as ImageProvider : FileImage(File(path)),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 4,
            top: 4,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isRemote) {
                    _galleryUrls.remove(path);
                  } else {
                    _localGallery.removeWhere((f) => f.path == path);
                  }
                });
              },
              child: Container(
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDeco(String label) => InputDecoration(
    labelText: label, labelStyle: GoogleFonts.jost(fontSize: 13),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
}
