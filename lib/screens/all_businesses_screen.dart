import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/data_providers.dart';
import '../data/models/business.dart';

class AllBusinessesScreen extends ConsumerStatefulWidget {
  const AllBusinessesScreen({super.key});

  @override
  ConsumerState<AllBusinessesScreen> createState() => _AllBusinessesScreenState();
}

class _AllBusinessesScreenState extends ConsumerState<AllBusinessesScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<Business> _businesses = [];
  bool _isLoading = true;
  bool _isFetchingMore = false;
  bool _hasError = false;

  int _currentPage = 1;
  bool _hasMore = true;
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _loadMoreBusinesses();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _businesses = [];
      _currentPage = 1;
    });

    final businesses = await ref.read(businessRepositoryProvider).getBusinesses(
      query: _searchController.text.isEmpty ? null : _searchController.text,
      page: 1,
      limit: _pageSize,
    );

    if (mounted) {
      setState(() {
        _businesses = businesses;
        _hasMore = businesses.length == _pageSize;
        _currentPage = 1;
        _isLoading = false;
        _hasError = false;
      });
    }
  }

  Future<void> _loadMoreBusinesses() async {
    if (_isFetchingMore || !_hasMore) return;

    setState(() => _isFetchingMore = true);

    final nextPage = _currentPage + 1;
    final businesses = await ref.read(businessRepositoryProvider).getBusinesses(
      query: _searchController.text.isEmpty ? null : _searchController.text,
      page: nextPage,
      limit: _pageSize,
    );

    if (mounted) {
      setState(() {
        _businesses.addAll(businesses);
        _currentPage = nextPage;
        _hasMore = businesses.length == _pageSize;
        _isFetchingMore = false;
      });
    }
  }

  Future<void> _filterBusinesses([String? query]) async {
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F1),
      appBar: AppBar(
        title: Text(
          'All Businesses',
          style: GoogleFonts.jost(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF9F7F1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          onSubmitted: (val) => _filterBusinesses(val),
          decoration: const InputDecoration(
            hintText: 'Search businesses...',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(16),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Could not load businesses',
              style: GoogleFonts.jost(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Check your internet connection and try again.'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_businesses.isEmpty) {
      return const Center(child: Text('No businesses found.'));
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _businesses.length + 1,
      itemBuilder: (context, index) {
        if (index == _businesses.length) {
          return _buildLoadMoreIndicator();
        }
        final business = _businesses[index];
        return _buildBusinessCard(business);
      },
    );
  }

  Widget _buildLoadMoreIndicator() {
    if (!_isFetchingMore) return const SizedBox.shrink();
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildBusinessCard(Business business) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: InkWell(
        onTap: () => context.push('/business/${business.id}', extra: business),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: () {
                  final String url = business.logo.isNotEmpty
                      ? business.logo
                      : (business.media.images.isNotEmpty ? business.media.images[0].url : '');
                  if (url.isEmpty) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.store, size: 50, color: Colors.grey),
                    );
                  }
                  return CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: Colors.grey[200]),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.store, size: 50, color: Colors.grey),
                    ),
                  );
                }(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          business.businessName,
                          style: GoogleFonts.jost(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (business.isHalal)
                        const Icon(Icons.verified, color: Colors.green, size: 20),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    business.about,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 4),
                      Text(
                        '${business.locations.city}, ${business.locations.country}',
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
