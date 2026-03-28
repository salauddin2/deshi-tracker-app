import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/providers/auth_provider.dart';
import '../providers/data_providers.dart';
import '../data/models/business.dart';
import '../data/models/category.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Business> _businesses = [];
  List<Category> _categories = [];
  String? _selectedCategoryId;

  bool _isLoading = true;
  bool _hasError = false;

  final Color _primaryColor = const Color(0xFF1A3B5B);
  final Color _accentColor = const Color(0xFF2E6DA4);
  final Color _bgColor = const Color(0xFFF4F8FD);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    debugPrint('Home: starting _loadData');
    setState(() {
      _isLoading = true;
      _hasError = false;
      _businesses = [];
    });

    final categoriesFuture = ref.read(categoryRepositoryProvider).getCategories().then((res) {
      debugPrint('Home: Categories fetched: ${res.length}');
      return res;
    }).catchError((e, st) {
      debugPrint('Home: categories error: $e');
      debugPrint('$st');
      return <Category>[];
    });

    final bizFuture = ref.read(businessRepositoryProvider).getBusinesses(
      categoryId: _selectedCategoryId,
      query: _searchController.text.isEmpty ? null : _searchController.text,
      page: 1,
      limit: 20,
    ).then((res) {
      debugPrint('Home: Businesses fetched: ${res.length}');
      return res;
    }).catchError((e, st) {
      debugPrint('Home: businesses error: $e');
      debugPrint('$st');
      return <Business>[];
    });

    try {
      debugPrint('Home: waiting for futures...');
      // Note: failures are handled individually via .catchError on the futures themselves
      final results = await Future.wait([categoriesFuture, bizFuture]);
      debugPrint('Home: futures completed');

      if (mounted) {
        final cats = results[0] as List<Category>;
        final bizList = results[1] as List<Business>;
        
        setState(() {
          _categories = cats;
          _businesses = bizList;
          _isLoading = false;
          _hasError = bizList.isEmpty && cats.isEmpty && _searchController.text.isEmpty;
        });
        debugPrint('Home: state updated: ${_businesses.length} businesses, ${_categories.length} categories');
      }
    } catch (e, st) {
      debugPrint('Home: Error in _loadData catch block: $e');
      debugPrint('$st');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _businesses = [];
        });
      }
    }
  }

  Future<void> _filterBusinesses([String? query]) async {
    setState(() {
      _isLoading = true;
      _businesses = [];
    });

    try {
      final bizList = await ref.read(businessRepositoryProvider).getBusinesses(
        categoryId: _selectedCategoryId,
        query: query ?? (_searchController.text.isEmpty ? null : _searchController.text),
        page: 1,
        limit: 20,
      );

      if (mounted) {
        setState(() {
          _businesses = bizList;
          _isLoading = false;
          _hasError = bizList.isEmpty;
        });
      }
    } catch (e) {
      debugPrint('Error filtering businesses: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _businesses = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    return Scaffold(
      backgroundColor: _bgColor,
      drawer: _buildDrawer(context, authState),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(context, authState),
              _buildHeroSection(),
              _buildBusinessesSection(),
              _buildFooter(),
              const SliverToBoxAdapter(child: SizedBox(height: 100)), // Bottom nav padding
            ],
          ),
          // Floating Bottom Nav
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNav(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AuthState auth) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: Colors.white.withValues(alpha: 0.9),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.location_on, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 8),
          Text(
            'DesiTracker',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: _primaryColor,
              fontSize: 20,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: Colors.grey[600]),
          onPressed: () {},
        ),
        if (auth.user == null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 4.0),
            child: TextButton(
              onPressed: () => context.push('/login'),
              child: Text('Login', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.w600)),
            ),
          )
        else
          GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Container(
              margin: const EdgeInsets.only(right: 16, left: 8),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _primaryColor.withValues(alpha: 0.1),
                border: Border.all(color: _primaryColor.withValues(alpha: 0.2), width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Icon(Icons.person, color: _primaryColor, size: 20),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeroSection() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _primaryColor.withValues(alpha: 0.1),
              Colors.white,
              Colors.transparent,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search Diverse\n',
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
                height: 1.1,
              ),
            ),
            Text(
              'Businesses',
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: _primaryColor,
                height: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Worldwide',
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withValues(alpha: 0.1),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Search Input
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search business name...',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                        prefixIcon: Icon(Icons.storefront_outlined, color: Colors.grey.shade400),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Horizontal Category Bar (Step 37)
                  SizedBox(
                    height: 85,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: _categories.length + 1,
                      itemBuilder: (context, index) {
                        final isAll = index == 0;
                        final category = isAll ? null : _categories[index - 1];
                        final isSelected = _selectedCategoryId == category?.id;
                        
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _selectedCategoryId = category?.id);
                              _filterBusinesses();
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isSelected ? _primaryColor : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: isSelected ? [BoxShadow(color: _primaryColor.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))] : [],
                                    border: Border.all(color: isSelected ? _primaryColor : Colors.grey.shade100),
                                  ),
                                  child: Icon(
                                    isAll ? Icons.apps : _getCategoryIcon(category!.icon),
                                    color: isSelected ? Colors.white : Colors.grey.shade500,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  isAll ? 'All' : category!.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected ? _primaryColor : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Country & City Dropdowns
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: null,
                              hint: Text('Country', style: TextStyle(color: Colors.grey.shade600, fontSize: 15)),
                              icon: Icon(Icons.expand_more, color: Colors.grey.shade400),
                              items: const [
                                DropdownMenuItem(value: null, child: Text('Country')),
                              ],
                              onChanged: (val) {},
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: null,
                              hint: Text('City', style: TextStyle(color: Colors.grey.shade600, fontSize: 15)),
                              icon: Icon(Icons.expand_more, color: Colors.grey.shade400),
                              items: const [
                                DropdownMenuItem(value: null, child: Text('City')),
                              ],
                              onChanged: (val) {},
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _filterBusinesses(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: _primaryColor.withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.travel_explore, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'Search Businesses',
                            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      // Primary Categories (Match roadmap & backend)
      case 'food':
      case 'restaurant': return Icons.restaurant;
      case 'retail':
      case 'shop': return Icons.shopping_bag;
      case 'grocery': return Icons.local_grocery_store;
      case 'health':
      case 'medical': return Icons.medical_services;
      case 'services':
      case 'professional': return Icons.miscellaneous_services;
      case 'entertainment': return Icons.theater_comedy;
      case 'fashion': return Icons.checkroom;
      case 'beauty': return Icons.face;
      case 'travel': return Icons.flight;
      case 'education': return Icons.school;
      case 'real_estate': return Icons.home_work;
      case 'automotive': return Icons.directions_car;
      case 'electronics': return Icons.devices;
      case 'finance': return Icons.account_balance;
      case 'emergency': return Icons.emergency;
      default: return Icons.category_outlined;
    }
  }

  Widget _buildBusinessesSection() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Listed Businesses',
                  style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Text(
                  'Discover the most loved businesses in your community',
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          if (_isLoading)
            const SliverToBoxAdapter(
              child: Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            )
          else if (_hasError)
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text('Error loading businesses.', style: GoogleFonts.inter(color: Colors.grey[700])),
                      TextButton(onPressed: _loadData, child: const Text('Retry')),
                    ],
                  ),
                ),
              ),
            )
          else if (_businesses.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text('No businesses found.', style: GoogleFonts.inter(color: Colors.grey[600])),
                ),
              ),
            )
          else
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveValue<int>(
                  context,
                  defaultValue: 2,
                  conditionalValues: [
                    const Condition.largerThan(name: MOBILE, value: 3),
                    const Condition.largerThan(name: TABLET, value: 4),
                  ],
                ).value,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.62,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildBusinessCardGrid(_businesses[index]);
                },
                childCount: _businesses.length,
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 16),
              child: Center(
                child: OutlinedButton(
                  onPressed: () => context.push('/all-businesses'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _primaryColor,
                    side: BorderSide(color: _primaryColor.withValues(alpha: 0.3), width: 2),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'SEE ALL BUSINESSES',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBusinessCardGrid(Business business) {
    // Find category name if available
    String categoryName = 'Business';
    if (business.categoryId.isNotEmpty) {
      final cat = _categories.where((c) => c.id == business.categoryId).firstOrNull;
      if (cat != null) categoryName = cat.name;
    }

    final imageUrl = business.logo.isNotEmpty 
        ? business.logo 
        : (business.media.images.isNotEmpty ? business.media.images[0].url : '');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/business/${business.id}', extra: business),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Section
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1.3,
                    child: () {
                      if (imageUrl.isEmpty) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: Icon(Icons.store, color: Colors.grey.shade400, size: 40),
                        );
                      }
                      return CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey.shade200,
                          child: Icon(Icons.store, color: Colors.grey.shade400, size: 40),
                        ),
                        placeholder: (context, url) => Container(color: Colors.grey.shade100),
                      );
                    }(),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
                        ],
                      ),
                      child: const Icon(Icons.favorite_border, color: Colors.grey, size: 16),
                    ),
                  ),
                ],
              ),
              // Content Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryName.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                          color: _accentColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        business.businessName,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 12, color: Colors.grey.shade400),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${business.locations.city}, ${business.locations.country == 'US' ? 'USA' : business.locations.country}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            'New',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _primaryColor.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'VIEW DETAILS',
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: _primaryColor,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        color: const Color(0xFF0A1118),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Color(0xFF1A3B5B), size: 28),
                const SizedBox(width: 8),
                Text(
                  'DesiTracker',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 24,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _footerLink('About Us'),
                _footerLink('Add Business'),
                _footerLink('Contact Support'),
                _footerLink('Privacy Policy'),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _socialIcon(Icons.share),
                const SizedBox(width: 16),
                _socialIcon(Icons.alternate_email),
                const SizedBox(width: 16),
                _socialIcon(Icons.forum),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              '© 2024 DesiTracker Inc.\nsupport@desitracker.app',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _footerLink(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: Colors.grey.shade400,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _socialIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.grey.shade400, size: 20),
    );
  }

  Widget _buildBottomNav() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.only(bottom: 32, top: 12, left: 16, right: 16), // Account for iOS home indicator
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            border: Border(
              top: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _navItem(Icons.home, 'HOME', isSelected: true),
              _navItem(Icons.search, 'SEARCH'),
              _navAddButton(),
              _navItem(Icons.favorite_border, 'FAVORITES'),
              _navItem(Icons.person_outline, 'PROFILE'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, {bool isSelected = false}) {
    final color = isSelected ? _primaryColor : Colors.grey.shade400;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            color: color,
            fontSize: 9,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _navAddButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 4),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _primaryColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: _primaryColor.withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 24),
        ),
        Text(
          'ADD',
          style: GoogleFonts.inter(
            color: Colors.grey.shade600,
            fontSize: 9,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context, AuthState auth) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            margin: EdgeInsets.zero,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        auth.isAuthenticated ? (auth.user?.name ?? 'User') : 'Guest',
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (auth.isAuthenticated)
                        Text(
                          auth.role.name.toUpperCase().replaceAll('_', ' '),
                          style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                if (auth.isAuthenticated) ...[
                  if (auth.role == UserRole.businessOwner)
                    ListTile(
                      leading: const Icon(Icons.dashboard_outlined),
                      title: Text('Business Dashboard', style: GoogleFonts.inter()),
                      onTap: () => context.go('/business-dashboard'),
                    ),
                  if (auth.role == UserRole.user)
                    ListTile(
                      leading: const Icon(Icons.qr_code_outlined),
                      title: Text('My Digital ID', style: GoogleFonts.inter()),
                      onTap: () => context.go('/member-profile'),
                    ),
                  ListTile(
                    leading: const Icon(Icons.logout_outlined),
                    title: Text('Logout', style: GoogleFonts.inter()),
                    onTap: () {
                      ref.read(authProvider.notifier).logout();
                      context.go('/');
                    },
                  ),
                ] else
                  ListTile(
                    leading: const Icon(Icons.login_outlined),
                    title: Text('Login', style: GoogleFonts.inter()),
                    onTap: () => context.push('/login'),
                  ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text('About Us', style: GoogleFonts.inter()),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

