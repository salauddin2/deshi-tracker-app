import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../data/models/business.dart';
import '../providers/data_providers.dart';
import '../features/auth/providers/auth_provider.dart';

class BusinessFormScreen extends ConsumerStatefulWidget {
  final Business? business;
  const BusinessFormScreen({super.key, this.business});
  @override
  ConsumerState<BusinessFormScreen> createState() => _BusinessFormScreenState();
}

class _BusinessFormScreenState extends ConsumerState<BusinessFormScreen> {
  Business? _business;
  bool _isSaving = false;
  bool _isLoading = true;
  List<dynamic> _platformCategories = [];
  List<dynamic> _subCategories = [];

  // Part A
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _aboutCtrl;
  late TextEditingController _yearCtrl;

  // Part B
  String? _selectedCategoryId;
  String? _selectedSubCategoryId;

  // Part C — Opening Hours
  final Map<String, bool> _isClosed = {};
  final Map<String, TextEditingController> _openCtrls = {};
  final Map<String, TextEditingController> _closeCtrls = {};
  static const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  // Part D — Language
  late TextEditingController _primaryLangCtrl;
  late TextEditingController _secondLangCtrl;

  // Part E — Contact
  late TextEditingController _phoneCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _websiteCtrl;
  late TextEditingController _facebookCtrl;
  late TextEditingController _instagramCtrl;
  late TextEditingController _linkedinCtrl;
  late TextEditingController _twitterCtrl;

  // Part F — Feature Toggles
  bool _wheelchairAccessible = false;
  bool _onlineService = false;
  bool _halalCertified = false;
  bool _homeDelivery = false;
  bool _inStorePickup = false;
  bool _parkingAvailable = false;
  bool _onlineBooking = false;
  bool _specialMemberDiscount = false;

  // Part G — Location
  late TextEditingController _addressCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _countryCtrl;
  late TextEditingController _postCodeCtrl;

  // Part H — Media
  final List<String> _localMedia = [];
  final List<String> _existingMedia = [];
  bool _isUploadingMedia = false;
  LatLng? _pickedLocation;

  // Branches
  final List<Map<String, String>> _branches = [];

  // Part I — Payment Methods
  final List<String> _allPaymentMethods = ['Cash', 'Card', 'Online Payment', 'Mobile Payment', 'Cheque'];
  final Set<String> _selectedPayments = {};

  static const Color _navy = Color(0xFF1A3C5E);
  static const Color _accentBlue = Color(0xFF2E6DA4);
  static const Color _bg = Color(0xFFF4F8FD);

  @override
  void initState() {
    super.initState();
    _initControllers();
    _loadData();
  }

  void _initControllers() {
    _nameCtrl = TextEditingController();
    _descCtrl = TextEditingController();
    _aboutCtrl = TextEditingController();
    _yearCtrl = TextEditingController();
    _primaryLangCtrl = TextEditingController();
    _secondLangCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _websiteCtrl = TextEditingController();
    _facebookCtrl = TextEditingController();
    _instagramCtrl = TextEditingController();
    _linkedinCtrl = TextEditingController();
    _twitterCtrl = TextEditingController();
    _addressCtrl = TextEditingController();
    _cityCtrl = TextEditingController();
    _countryCtrl = TextEditingController();
    _postCodeCtrl = TextEditingController();

    for (final d in _days) {
      _isClosed[d] = false;
      _openCtrls[d] = TextEditingController();
      _closeCtrls[d] = TextEditingController();
    }
  }

  Future<void> _loadData() async {
    final auth = ref.read(authProvider);
    setState(() => _isLoading = true);
    try {
      final businessRepo = ref.read(businessRepositoryProvider);
      // Load platform categories
      final cats = await businessRepo.fetchCategories();
      _platformCategories = cats.map((c) => {'_id': c['_id'], 'name': c['name'], 'slug': c['slug']}).toList();

      // Load owner's business
      final userId = auth.user?.id ?? '';
      if (userId.isNotEmpty) {
        final bizList = await businessRepo.getBusinesses(query: userId);
        if (bizList.isNotEmpty && mounted) {
          _business = bizList.first;
          _populateFromBusiness(_business!);
        }
      }

      // If external business was passed
      if (widget.business != null && _business == null) {
        _business = widget.business;
        _populateFromBusiness(_business!);
      }

      // Load sub-categories if category selected
      if (_selectedCategoryId != null) {
        await _loadSubCategories(_selectedCategoryId!);
      }
    } catch (e) {
      debugPrint('Error loading business data: $e');
    }
    if (mounted) setState(() => _isLoading = false);
  }

  void _populateFromBusiness(Business b) {
    _nameCtrl.text = b.businessName;
    _descCtrl.text = b.description;
    _aboutCtrl.text = b.about;
    _yearCtrl.text = b.established?.year.toString() ?? '';
    _selectedCategoryId = b.categoryId.isNotEmpty ? b.categoryId : null;
    _selectedSubCategoryId = b.subCategoryId;

    // Opening Hours
    for (final oh in b.openingHours) {
      final day = oh.day;
      if (_openCtrls.containsKey(day)) {
        _openCtrls[day]!.text = oh.start ?? '';
        _closeCtrls[day]!.text = oh.end ?? '';
        _isClosed[day] = (oh.start == null || oh.start!.isEmpty);
      }
    }
    // Also check businessHours map
    final bh = b.operationDetails.businessHours;
    for (final d in _days) {
      if (bh.containsKey(d.toLowerCase())) {
        final h = bh[d.toLowerCase()];
        if (h is Map) {
          if (h['isClosed'] == true) {
            _isClosed[d] = true;
          } else {
            _openCtrls[d]!.text = h['open'] ?? _openCtrls[d]!.text;
            _closeCtrls[d]!.text = h['close'] ?? _closeCtrls[d]!.text;
          }
        }
      }
    }

    _primaryLangCtrl.text = b.features.officialLanguage;
    _secondLangCtrl.text = b.features.secondLanguage ?? '';
    _phoneCtrl.text = b.contactDetails.phoneNumber;
    _emailCtrl.text = b.contactDetails.email;
    _websiteCtrl.text = b.contactDetails.websiteUrl;
    _facebookCtrl.text = b.contactDetails.facebook;
    _instagramCtrl.text = b.contactDetails.instagram;
    _linkedinCtrl.text = b.contactDetails.linkedin;
    _twitterCtrl.text = b.contactDetails.twitter;
    _wheelchairAccessible = b.features.isWheelChairAccessible;
    _onlineService = b.operationDetails.provideOnlineService;
    _halalCertified = b.isHalal;
    _homeDelivery = b.operationDetails.provideHomeDelivery;
    _inStorePickup = b.operationDetails.offerInStorePickup;
    _parkingAvailable = b.operationDetails.isParkingAvailable;
    _onlineBooking = b.operationDetails.offerOnlineBooking;
    _specialMemberDiscount = b.features.offerSpecialDiscount;
    _addressCtrl.text = b.locations.address;
    _cityCtrl.text = b.locations.city ?? '';
    _countryCtrl.text = b.locations.country;
    _postCodeCtrl.text = b.locations.postCode ?? '';
    _selectedPayments.addAll(b.paymentMethods);
    
    _existingMedia.clear();
    _existingMedia.addAll(b.media.images.map((e) => e.url));

    if (b.locations.lat != null && b.locations.long != null) {
      final lt = double.tryParse(b.locations.lat!);
      final ln = double.tryParse(b.locations.long!);
      if (lt != null && ln != null) {
        _pickedLocation = LatLng(lt, ln);
      }
    }
  }

  Future<void> _loadSubCategories(String categoryId) async {
    try {
      // Find slug from category list
      final cat = _platformCategories.firstWhere((c) => c['_id'] == categoryId, orElse: () => null);
      if (cat == null) return;
      final res = await ref.read(businessRepositoryProvider).getPlatformCategory(cat['slug']);
      if (mounted) {
        final catData = res['data'];
        setState(() => _subCategories = catData?['subCategories'] ?? []);
      }
    } catch (e) {
      debugPrint('Error loading sub-categories: $e');
    }
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    try {
      final businessRepo = ref.read(businessRepositoryProvider);
      
      // 1. Upload new media if any
      List<String> finalImageUrls = List.from(_existingMedia);
      if (_localMedia.isNotEmpty) {
        setState(() => _isUploadingMedia = true);
        final newUrls = await businessRepo.uploadBusinessPhotos(_localMedia);
        finalImageUrls.addAll(newUrls);
        setState(() => _isUploadingMedia = false);
      }

      // Build opening hours
      final hours = <Map<String, dynamic>>[];
      for (final d in _days) {
        if (_isClosed[d] == true) {
          hours.add({'day': d, 'start': null, 'end': null});
        } else {
          hours.add({'day': d, 'start': _openCtrls[d]!.text.trim(), 'end': _closeCtrls[d]!.text.trim()});
        }
      }

      // Build businessHours map
      final businessHours = <String, dynamic>{};
      for (final d in _days) {
        businessHours[d.toLowerCase()] = {
          'isClosed': _isClosed[d] ?? false,
          'open': _openCtrls[d]!.text.trim(),
          'close': _closeCtrls[d]!.text.trim(),
        };
      }

      final body = {
        'businessName': _nameCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
        'about': _aboutCtrl.text.trim(),
        'established': _yearCtrl.text.trim().isNotEmpty
            ? '${_yearCtrl.text.trim()}-01-01T00:00:00.000Z'
            : null,
        'category': _selectedCategoryId,
        'subCategory': _selectedSubCategoryId,
        'contactDetails': {
          'phoneNumber': _phoneCtrl.text.trim(),
          'email': _emailCtrl.text.trim(),
          'websiteUrl': _websiteCtrl.text.trim(),
          'facebook': _facebookCtrl.text.trim(),
          'instagram': _instagramCtrl.text.trim(),
          'linkedin': _linkedinCtrl.text.trim(),
          'twitter': _twitterCtrl.text.trim(),
        },
        'locations': {
          'address': _addressCtrl.text.trim(),
          'city': _cityCtrl.text.trim(),
          'country': _countryCtrl.text.trim(),
          'postCode': _postCodeCtrl.text.trim(),
          'lat': _pickedLocation?.latitude.toString(),
          'long': _pickedLocation?.longitude.toString(),
        },
        'media': {
          'images': finalImageUrls.map((url) => {'url': url, 'description': ''}).toList(),
        },
        'operationDetails': {
          'businessHours': businessHours,
          'provideHomeDelivery': _homeDelivery,
          'provideOnlineService': _onlineService,
          'offerInStorePickup': _inStorePickup,
          'isParkingAvailable': _parkingAvailable,
          'offerOnlineBooking': _onlineBooking,
        },
        'features': {
          'officialLanguage': _primaryLangCtrl.text.trim(),
          'secondLanguage': _secondLangCtrl.text.trim(),
          'offerSpecialDiscount': _specialMemberDiscount,
          'isWheelChairAccessible': _wheelchairAccessible,
        },
        'isHalal': _halalCertified,
        'openingHours': hours,
        'paymentMethods': _selectedPayments.toList(),
      };

      final slug = _business?.slug ?? '';
      if (slug.isNotEmpty) {
        await businessRepo.updateBusiness(slug, body);
      } else {
        body['owner'] = ref.read(authProvider).user?.id;
        await businessRepo.registerBusiness(body);
      }

      if (!mounted) return;

      // Repository returns the data directly now, assuming it throws on error or handles it
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Business updated successfully!'), backgroundColor: Color(0xFF15803D)),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: const Color(0xFFB91C1C)),
        );
      }
    }
    if (mounted) setState(() => _isSaving = false);
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _descCtrl.dispose(); _aboutCtrl.dispose(); _yearCtrl.dispose();
    _primaryLangCtrl.dispose(); _secondLangCtrl.dispose();
    _phoneCtrl.dispose(); _emailCtrl.dispose(); _websiteCtrl.dispose();
    _facebookCtrl.dispose(); _instagramCtrl.dispose(); _linkedinCtrl.dispose(); _twitterCtrl.dispose();
    _addressCtrl.dispose(); _cityCtrl.dispose(); _countryCtrl.dispose(); _postCodeCtrl.dispose();
    for (final c in _openCtrls.values) { c.dispose(); }
    for (final c in _closeCtrls.values) { c.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: Text(_business == null ? 'Add Business' : 'Edit Business', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : _handleSave,
              icon: _isSaving
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.save_outlined, size: 18),
              label: Text(_isSaving ? 'Saving...' : 'SAVE', style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _navy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: _navy))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildSection('Part A — Basic Information', Icons.info_outline, [
                    _textField(_nameCtrl, 'Business Name', 'e.g. Spice Garden Restaurant'),
                    _textField(_descCtrl, 'Short Description', 'Shown on search cards', maxLines: 2),
                    _textField(_aboutCtrl, 'About the Business', 'Full story shown on detail page', maxLines: 4),
                    _textField(_yearCtrl, 'Year Established', 'e.g. 2015', keyboard: TextInputType.number),
                  ], initiallyExpanded: true),
                  _gap(),
                  _buildSection('Part B — Category & Sub-Category', Icons.category_outlined, [
                    _dropdownField<String>(
                      'Main Category',
                      _selectedCategoryId,
                      _platformCategories.map((c) => DropdownMenuItem<String>(value: c['_id'], child: Text(c['name'] ?? ''))).toList(),
                      (val) {
                        setState(() {
                          _selectedCategoryId = val;
                          _selectedSubCategoryId = null;
                          _subCategories = [];
                        });
                        if (val != null) _loadSubCategories(val);
                      },
                    ),
                    if (_subCategories.isNotEmpty)
                      _dropdownField<String>(
                        'Sub-Category',
                        _selectedSubCategoryId,
                        _subCategories.map((s) => DropdownMenuItem<String>(value: s['_id'] ?? s['slug'], child: Text(s['name'] ?? ''))).toList(),
                        (val) => setState(() => _selectedSubCategoryId = val),
                      ),
                  ]),
                  _gap(),
                  _buildSection('Part C — Opening Hours', Icons.access_time_outlined, [
                    for (final day in _days) _buildDayRow(day),
                  ]),
                  _gap(),
                  _buildSection('Part D — Language', Icons.language_outlined, [
                    _textField(_primaryLangCtrl, 'Primary Language', 'e.g. English, Bengali, Urdu'),
                    _textField(_secondLangCtrl, 'Second Language (Optional)', 'e.g. Arabic'),
                  ]),
                  _gap(),
                  _buildSection('Part E — Contact Details & Social Media', Icons.contact_phone_outlined, [
                    _textField(_phoneCtrl, 'Public Phone Number', '', keyboard: TextInputType.phone),
                    _textField(_emailCtrl, 'Public Email', '', keyboard: TextInputType.emailAddress),
                    _textField(_websiteCtrl, 'Website URL', 'https://...'),
                    const Divider(height: 32),
                    _textField(_facebookCtrl, 'Facebook', ''),
                    _textField(_instagramCtrl, 'Instagram', ''),
                    _textField(_linkedinCtrl, 'LinkedIn', ''),
                    _textField(_twitterCtrl, 'Twitter / X', ''),
                  ]),
                  _gap(),
                  _buildSection('Part F — Feature Toggles', Icons.toggle_on_outlined, [
                    _toggle('Wheelchair Accessible', _wheelchairAccessible, (v) => setState(() => _wheelchairAccessible = v)),
                    _toggle('Online Service', _onlineService, (v) => setState(() => _onlineService = v)),
                    _toggle('Halal / Kosher / Vegan', _halalCertified, (v) => setState(() => _halalCertified = v)),
                    _toggle('Home Delivery', _homeDelivery, (v) => setState(() => _homeDelivery = v)),
                    _toggle('In-Store Pickup', _inStorePickup, (v) => setState(() => _inStorePickup = v)),
                    _toggle('Parking Available', _parkingAvailable, (v) => setState(() => _parkingAvailable = v)),
                    _toggle('Online Booking', _onlineBooking, (v) => setState(() => _onlineBooking = v)),
                    _toggle('Special Member Discount', _specialMemberDiscount, (v) => setState(() => _specialMemberDiscount = v)),
                  ]),
                  _gap(),
                  _buildSection('Part G — Location', Icons.location_on_outlined, [
                    _textField(_addressCtrl, 'Street Address', ''),
                    _textField(_cityCtrl, 'City', ''),
                    _textField(_countryCtrl, 'Country', ''),
                    _textField(_postCodeCtrl, 'Post Code', ''),
                    const SizedBox(height: 16),
                    _buildMapPicker(),
                    const Divider(height: 32),
                    _buildBranchSection(),
                  ]),
                  _gap(),
                  _buildSection('Part H — Photos & Media', Icons.photo_library_outlined, [
                    _buildMediaGallery(),
                  ]),
                  _gap(),
                  _buildSection('Part I — Payment Methods', Icons.payment_outlined, [
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: _allPaymentMethods.map((m) => FilterChip(
                        label: Text(m, style: GoogleFonts.jost(fontSize: 13, color: _selectedPayments.contains(m) ? Colors.white : Colors.black87)),
                        selected: _selectedPayments.contains(m),
                        selectedColor: _navy,
                        checkmarkColor: Colors.white,
                        backgroundColor: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        onSelected: (sel) => setState(() => sel ? _selectedPayments.add(m) : _selectedPayments.remove(m)),
                      )).toList(),
                    ),
                  ]),
                  const SizedBox(height: 60),
                ],
              ),
            ),
    );
  }

  // ─── WIDGETS ───────────────────────────────────────────────────────

  Widget _buildSection(String title, IconData icon, List<Widget> children, {bool initiallyExpanded = false}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: _accentBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: _accentBlue, size: 20),
          ),
          title: Text(title, style: GoogleFonts.jost(fontSize: 17, fontWeight: FontWeight.bold, color: _navy)),
          childrenPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          expandedAlignment: Alignment.topLeft,
          children: children,
        ),
      ),
    );
  }

  Widget _textField(TextEditingController ctrl, String label, String hint, {int maxLines = 1, TextInputType? keyboard}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.jost(fontWeight: FontWeight.w600, fontSize: 13, color: const Color(0xFF64748B))),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            maxLines: maxLines,
            keyboardType: keyboard,
            style: GoogleFonts.jost(fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.jost(color: Colors.grey[300], fontSize: 13),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[200]!)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[200]!)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _accentBlue, width: 1.5)),
              filled: true,
              fillColor: _bg.withValues(alpha: 0.5),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdownField<T>(String label, T? value, List<DropdownMenuItem<T>> items, ValueChanged<T?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.jost(fontWeight: FontWeight.w600, fontSize: 13, color: const Color(0xFF64748B))),
          const SizedBox(height: 6),
          DropdownButtonFormField<T>(
            initialValue: items.any((i) => i.value == value) ? value : null,
            items: items,
            onChanged: onChanged,
            style: GoogleFonts.jost(fontSize: 14, color: Colors.black87),
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[200]!)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[200]!)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _accentBlue, width: 1.5)),
              filled: true,
              fillColor: _bg.withValues(alpha: 0.5),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggle(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: value ? _navy.withValues(alpha: 0.04) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(label, style: GoogleFonts.jost(fontWeight: FontWeight.w500, fontSize: 14))),
            Switch.adaptive(
              value: value,
              activeTrackColor: _navy,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayRow(String day) {
    final closed = _isClosed[day] ?? false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(day, style: GoogleFonts.jost(fontWeight: FontWeight.w600, fontSize: 13)),
          ),
          SizedBox(
            width: 70,
            child: Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 40,
                  child: Switch.adaptive(
                    value: closed,
                    activeTrackColor: Colors.red.shade300,
                    onChanged: (v) => setState(() => _isClosed[day] = v),
                  ),
                ),
                const SizedBox(width: 4),
                Text('Off', style: GoogleFonts.jost(fontSize: 11, color: closed ? Colors.red : Colors.grey[400])),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (!closed) ...[
            Expanded(
              child: TextField(
                controller: _openCtrls[day],
                readOnly: true,
                style: GoogleFonts.jost(fontSize: 13),
                decoration: _timeDeco('Open'),
                onTap: () => _pickTime(day, true),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text('—', style: GoogleFonts.jost(color: Colors.grey)),
            ),
            Expanded(
              child: TextField(
                controller: _closeCtrls[day],
                readOnly: true,
                style: GoogleFonts.jost(fontSize: 13),
                decoration: _timeDeco('Close'),
                onTap: () => _pickTime(day, false),
              ),
            ),
          ] else
            Expanded(child: Text('Closed', style: GoogleFonts.jost(color: Colors.red, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  InputDecoration _timeDeco(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.jost(color: Colors.grey[300], fontSize: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.grey[200]!)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    isDense: true,
  );

  Future<void> _pickTime(String day, bool isOpen) async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null && mounted) {
      final formatted = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      setState(() {
        if (isOpen) {
          _openCtrls[day]!.text = formatted;
        } else {
          _closeCtrls[day]!.text = formatted;
        }
      });
    }
  }

  Widget _buildMapPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Map Location (Optional)', style: GoogleFonts.jost(fontWeight: FontWeight.w600, fontSize: 13, color: const Color(0xFF64748B))),
        const SizedBox(height: 8),
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          clipBehavior: Clip.antiAlias,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: _pickedLocation ?? const LatLng(23.8103, 90.4125),
              initialZoom: 13,
              onTap: (tapPosition, point) => setState(() => _pickedLocation = point),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.desitracker.app',
              ),
              if (_pickedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _pickedLocation!,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _pickedLocation == null ? 'Tap the map to set location' : 'Location set: ${_pickedLocation!.latitude.toStringAsFixed(4)}, ${_pickedLocation!.longitude.toStringAsFixed(4)}',
          style: GoogleFonts.jost(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildMediaGallery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Business Images', style: GoogleFonts.jost(fontWeight: FontWeight.w600, fontSize: 13, color: const Color(0xFF64748B))),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Add button
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200, style: BorderStyle.solid),
                  ),
                  child: const Icon(Icons.add_a_photo_outlined, color: Colors.grey),
                ),
              ),
              // Existing images
              ..._existingMedia.map((url) => _buildThumb(url, isUrl: true)),
              // Local images
              ..._localMedia.map((path) => _buildThumb(path, isUrl: false)),
            ],
          ),
        ),
        if (_isUploadingMedia)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: LinearProgressIndicator(),
          ),
      ],
    );
  }

  Widget _buildThumb(String source, {required bool isUrl}) {
    return Stack(
      children: [
        Container(
          width: 100,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: isUrl ? NetworkImage(source) : FileImage(File(source)) as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 12,
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (isUrl) {
                  _existingMedia.remove(source);
                } else {
                  _localMedia.remove(source);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: const Icon(Icons.close, color: Colors.white, size: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBranchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Multiple Locations / Branches', style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 14)),
            TextButton.icon(
              onPressed: () => setState(() => _branches.add({'name': '', 'address': ''})),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Branch'),
            ),
          ],
        ),
        ..._branches.asMap().entries.map((entry) {
          final idx = entry.key;
          return Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Text('Branch #${idx + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red), onPressed: () => setState(() => _branches.removeAt(idx))),
                  ],
                ),
                TextField(
                  onChanged: (v) => _branches[idx]['name'] = v,
                  decoration: const InputDecoration(hintText: 'Branch Name', border: InputBorder.none, isDense: true),
                  style: const TextStyle(fontSize: 13),
                ),
                TextField(
                  onChanged: (v) => _branches[idx]['address'] = v,
                  decoration: const InputDecoration(hintText: 'Branch Address', border: InputBorder.none, isDense: true),
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() => _localMedia.addAll(images.map((e) => e.path)));
    }
  }

  Widget _gap() => const SizedBox(height: 20);
}
