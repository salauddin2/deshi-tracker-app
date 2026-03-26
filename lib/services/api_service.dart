import 'package:flutter/foundation.dart' hide Category;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/business.dart';
import '../models/category.dart';
import '../models/product.dart';
// ─── MODELS ─────────────────────────────────────────────────

class ApiResponse<T> {
  final bool success;
  final T? data;
  final dynamic meta;
  final String? message;

  ApiResponse({required this.success, this.data, this.meta, this.message});
}

// ─── SERVICE ─────────────────────────────────────────────────

class ApiService {
  /// Base URL — live production API
  /// For local Android emulator testing, swap to: http://10.0.2.2:5000/api/v1
  static const String baseUrl = 'https://api.desitracker.com/api/v1';


  // ── HTTP helpers ────────────────────────────────────────────────────────

  static Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final headers = await _authHeaders();
    return await http.post(Uri.parse('$baseUrl$endpoint'),
        headers: headers, body: json.encode(body)).timeout(const Duration(seconds: 10));
  }

  static Future<http.Response> get(String endpoint) async {
    final headers = await _authHeaders();
    return await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers).timeout(const Duration(seconds: 10));
  }

  static Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final headers = await _authHeaders();
    return await http.put(Uri.parse('$baseUrl$endpoint'),
        headers: headers, body: json.encode(body)).timeout(const Duration(seconds: 10));
  }

  static Future<http.Response> patch(String endpoint, Map<String, dynamic> body) async {
    final headers = await _authHeaders();
    return await http.patch(Uri.parse('$baseUrl$endpoint'),
        headers: headers, body: json.encode(body)).timeout(const Duration(seconds: 10));
  }

  static Future<http.Response> delete(String endpoint) async {
    final headers = await _authHeaders();
    return await http.delete(Uri.parse('$baseUrl$endpoint'), headers: headers).timeout(const Duration(seconds: 10));
  }

  // ── 🔐 Auth  /api/v1/auth ──────────────────────────────────────────────

  /// POST /auth/login  — Body: { email?, phoneNumber?, password }
  static Future<http.Response> login(String emailOrPhone, String password) async {
    return await post('/auth/login', {
      'email': emailOrPhone.contains('@') ? emailOrPhone : null,
      'phoneNumber': !emailOrPhone.contains('@') ? emailOrPhone : null,
      'password': password,
    }..removeWhere((k, v) => v == null));
  }

  /// POST /auth/logout
  static Future<http.Response> logout() async => await post('/auth/logout', {});

  /// POST /auth/forgot-password  — Body: { email }
  static Future<http.Response> forgotPassword(String email) async {
    return await post('/auth/forgot-password', {'email': email});
  }

  /// POST /auth/reset-password/:token  — Body: { newPassword }
  static Future<http.Response> resetPassword(String token, String newPassword) async {
    return await post('/auth/reset-password/$token', {'newPassword': newPassword});
  }

  // ── 👤 Users  /api/v1/users ────────────────────────────────────────────

  /// POST /users/register  — Multipart: data (JSON) + file (optional)
  static Future<http.Response> register(Map<String, dynamic> data, {String? filePath}) async {
    final url = Uri.parse('$baseUrl/users/register');
    final request = http.MultipartRequest('POST', url);
    request.fields['data'] = json.encode(data);
    if (filePath != null) {
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
    }
    return await http.Response.fromStream(await request.send());
  }

  /// GET /users/me
  static Future<http.Response> getMe() async => await get('/users/me');

  /// PUT /users/:id
  static Future<http.Response> updateUser(String id, Map<String, dynamic> data) async {
    return await put('/users/$id', data);
  }

  // ── 🏢 Business  /api/v1/business ──────────────────────────────────────

  /// POST /business/register
  static Future<http.Response> registerBusiness(Map<String, dynamic> data) async {
    return await post('/business/register', data);
  }

  /// GET /business  — Params: category, city, country, search, page, limit
  static Future<http.Response> getBusinessList({
    String? category,
    String? city,
    String? country,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    final params = <String, String>{
      'isActive': 'true',
      'isDeleted': 'false',
      'page': '$page',
      'limit': '$limit',
      if (search != null && search.isNotEmpty) 'searchTerm': search,
      if (category != null && category.isNotEmpty) 'category': category,
      if (city != null && city.isNotEmpty) 'city': city,
      if (country != null && country.isNotEmpty) 'country': country,
    };
    final q = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return await get('/business/?$q');
  }

  /// PUT /business/:slug
  static Future<http.Response> updateBusiness(String slug, Map<String, dynamic> data) async {
    return await put('/business/$slug', data);
  }

  /// DELETE /business/:slug
  static Future<http.Response> deleteBusiness(String slug) async => await delete('/business/$slug');

  // ── 📦 Products  /api/v1/products ──────────────────────────────────────

  /// POST /products/create  — Body: name, price, currency, category, business, user, memberDiscount
  static Future<http.Response> createProduct(Map<String, dynamic> data) async {
    return await post('/products/create', data);
  }

  /// GET /products/products/:user_id/:business_id
  static Future<http.Response> getProducts(String userId, String businessId) async {
    return await get('/products/products/$userId/$businessId');
  }

  /// GET /products/products-category/:user_id/:business_id
  static Future<http.Response> getProductCategories(String userId, String businessId) async {
    return await get('/products/products-category/$userId/$businessId');
  }

  /// GET /products/product/:id
  static Future<http.Response> getProductById(String id) async => await get('/products/product/$id');

  /// GET /products/category-products/:categoryId
  static Future<http.Response> getProductsByCategory(String categoryId) async {
    return await get('/products/category-products/$categoryId');
  }

  /// PUT /products/products/:productId
  static Future<http.Response> updateProduct(String id, Map<String, dynamic> data) async {
    return await put('/products/products/$id', data);
  }

  /// DELETE /products/products/:productId
  static Future<http.Response> deleteProduct(String id) async => await delete('/products/products/$id');

  /// PUT /products/products/discount/bulk
  static Future<http.Response> bulkUpdateDiscounts(Map<String, dynamic> data) async {
    return await put('/products/products/discount/bulk', data);
  }

  // ── Product Categories  /api/v1/products/category ──────────────────────

  /// POST /products/category/create
  static Future<http.Response> createCategory(Map<String, dynamic> data) async {
    return await post('/products/category/create', data);
  }

  /// GET /products/category
  static Future<http.Response> getCategories() async => await get('/products/category');

  /// PUT /products/category/:id
  static Future<http.Response> updateCategory(String id, Map<String, dynamic> data) async {
    return await put('/products/category/$id', data);
  }

  /// DELETE /products/category/:id
  static Future<http.Response> deleteCategory(String id) async => await delete('/products/category/$id');

  // ── Day Offers  /api/v1/products/poffer ────────────────────────────────

  /// GET /products/poffer/day-offers
  static Future<http.Response> fetchDayOffers() async => await get('/products/poffer/day-offers');

  /// GET /products/poffer/day-offers/active-today
  static Future<http.Response> fetchActiveTodayOffer() async {
    return await get('/products/poffer/day-offers/active-today');
  }

  /// POST /products/poffer/day-offers
  static Future<http.Response> createDayOffer(Map<String, dynamic> data) async {
    return await post('/products/poffer/day-offers', data);
  }

  /// POST /products/poffer/day-offers/apply-today
  static Future<http.Response> applyTodayOffer() async {
    return await post('/products/poffer/day-offers/apply-today', {});
  }

  /// PUT /products/poffer/day-offers/:id
  static Future<http.Response> updateDayOffer(String id, Map<String, dynamic> data) async {
    return await put('/products/poffer/day-offers/$id', data);
  }

  /// DELETE /products/poffer/day-offers/:id
  static Future<http.Response> deleteDayOffer(String id) async =>
      await delete('/products/poffer/day-offers/$id');

  // ── Product Options  /api/v1/product-options ───────────────────────────

  /// GET /product-options
  static Future<http.Response> fetchProductOptions() async => await get('/product-options');

  /// GET /product-options/:optionId
  static Future<http.Response> getProductOption(String optionId) async =>
      await get('/product-options/$optionId');

  /// POST /product-options/create
  static Future<http.Response> createProductOption(Map<String, dynamic> data) async {
    return await post('/product-options/create', data);
  }

  /// PUT /product-options/:optionId
  static Future<http.Response> updateProductOption(String id, Map<String, dynamic> data) async {
    return await put('/product-options/$id', data);
  }

  /// DELETE /product-options/:optionId
  static Future<http.Response> deleteProductOption(String id) async =>
      await delete('/product-options/$id');

  // ── 🧾 Orders  /api/v1/orders ──────────────────────────────────────────

  /// POST /orders/create  — Body: { business, tableNumber?, customerName?, items[], total, status }
  static Future<http.Response> createOrder(Map<String, dynamic> data) async {
    return await post('/orders/create', data);
  }

  /// GET /orders — Query: businessId, from, to, status
  static Future<http.Response> fetchOrders({
    String? businessId,
    String? status,
    String? from,
    String? to,
  }) async {
    final params = <String, String>{};
    if (businessId != null) params['businessId'] = businessId; // official param name
    if (status != null) params['status'] = status;
    if (from != null) params['from'] = from;
    if (to != null) params['to'] = to;
    final q = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return await get('/orders${q.isNotEmpty ? '?$q' : ''}');
  }

  /// GET /orders/:id
  static Future<http.Response> getOrderById(String id) async => await get('/orders/$id');

  /// PUT /orders/:id  — Body: { status?, items? }
  static Future<http.Response> updateOrder(String id, Map<String, dynamic> data) async {
    return await put('/orders/$id', data);
  }

  /// DELETE /orders/:id
  static Future<http.Response> deleteOrder(String id) async => await delete('/orders/$id');

  // ── 👥 Staff Rota  /api/v1/rota ────────────────────────────────────────

  static Future<http.Response> fetchRotaRoles() async => await get('/rota/roles');
  static Future<http.Response> createRotaRole(Map<String, dynamic> data) async => await post('/rota/roles', data);
  static Future<http.Response> getRotaRole(String id) async => await get('/rota/roles/$id');
  static Future<http.Response> patchRotaRole(String id, Map<String, dynamic> data) async => await patch('/rota/roles/$id', data);
  static Future<http.Response> deleteRotaRole(String id) async => await delete('/rota/roles/$id');

  static Future<http.Response> fetchRotaEmployees() async => await get('/rota/employees');
  static Future<http.Response> createRotaEmployee(Map<String, dynamic> data) async => await post('/rota/employees', data);
  static Future<http.Response> getRotaEmployee(String id) async => await get('/rota/employees/$id');
  static Future<http.Response> patchRotaEmployee(String id, Map<String, dynamic> data) async => await patch('/rota/employees/$id', data);
  static Future<http.Response> deleteRotaEmployee(String id) async => await delete('/rota/employees/$id');

  static Future<http.Response> fetchRotaShifts({String? employeeId}) async {
    return await get('/rota/shifts${employeeId != null ? '?employeeId=$employeeId' : ''}');
  }
  static Future<http.Response> createRotaShift(Map<String, dynamic> data) async => await post('/rota/shifts', data);
  static Future<http.Response> getRotaShift(String id) async => await get('/rota/shifts/$id');
  static Future<http.Response> patchRotaShift(String id, Map<String, dynamic> data) async => await patch('/rota/shifts/$id', data);
  static Future<http.Response> deleteRotaShift(String id) async => await delete('/rota/shifts/$id');

  // ── 🎫 Members  /api/v1/members ────────────────────────────────────────

  static Future<http.Response> registerMember(Map<String, dynamic> data) async => await post('/members/register', data);
  static Future<http.Response> loginMember(Map<String, dynamic> data) async => await post('/members/login', data);
  static Future<http.Response> verifyMember(String slug) async => await get('/members/verify/$slug');
  static Future<http.Response> lookupMember(String serial) async => await get('/members/lookup/$serial');
  static Future<http.Response> getMemberProfile() async => await get('/members/me');
  static Future<http.Response> updateMemberProfile(Map<String, dynamic> data) async => await patch('/members/me', data);
  static Future<http.Response> updateMemberStatus(Map<String, dynamic> data) async => await patch('/members/me/status', data);
  static Future<http.Response> deleteMemberAccount() async => await delete('/members/me');
  static Future<http.Response> searchMembers({String? query, int page = 1}) async =>
      await get('/members/search?q=${query ?? ''}&page=$page');
  static Future<http.Response> searchMemberBySerial(String serial) async =>
      await get('/members/search-by-serial?serial=$serial');
  static Future<http.Response> getMemberRestaurants() async => await get('/members/restaurants');

  // Member leads
  static Future<http.Response> addLead(String memberId, Map<String, dynamic> data) async =>
      await post('/members/me/leads', data);
  static Future<http.Response> getMyLeads() async => await get('/members/me/leads');
  static Future<http.Response> removeLead(String memberId) async =>
      await delete('/members/me/leads/$memberId');

  // ── 📅 Booking  /api/v1/booking ────────────────────────────────────────

  /// POST /booking/create  — Body: { business, name, email, phone, date, time, partySize, notes? }
  static Future<http.Response> createBooking(Map<String, dynamic> data) async {
    return await post('/booking/create', data);
  }

  /// GET /booking/business/:businessId
  static Future<http.Response> getBusinessBookings(String businessId) async {
    return await get('/booking/business/$businessId');
  }

  // ── 📊 Analytics  /api/v1/analytics ───────────────────────────────────

  /// GET /analytics/:businessId
  static Future<http.Response> fetchAnalytics(String businessId) async =>
      await get('/analytics/$businessId');

  /// POST /analytics/:businessId/visit  — Add page visit count
  static Future<http.Response> recordVisit(String businessId) async =>
      await post('/analytics/$businessId/visit', {});

  /// GET /analytics/:businessId/contact
  static Future<http.Response> fetchContactAnalytics(String businessId) async =>
      await get('/analytics/$businessId/contact');

  /// POST /analytics/:businessId  — Add contact click count
  static Future<http.Response> recordContactClick(String businessId) async =>
      await post('/analytics/$businessId', {});

  // ── 🌡️ Fridge  /api/v1/fridges ────────────────────────────────────────

  static Future<http.Response> createFridge(Map<String, dynamic> data) async => await post('/fridges/create', data);
  static Future<http.Response> addFridgeRecord(Map<String, dynamic> data) async => await post('/fridges/add-record', data);
  static Future<http.Response> editFridgeRecord(Map<String, dynamic> data) async => await put('/fridges/edit-record', data);
  static Future<http.Response> fetchFridgesByUser(String userId) async => await get('/fridges/$userId');
  static Future<http.Response> fetchFridgeRecords(String fridgeId) async => await get('/fridges/records/$fridgeId');

  // ── 📁 Image Upload  /api/v1/upload-images ─────────────────────────────

  /// POST /upload-images/:folder  — Multipart: images[] (multiple files)
  static Future<http.Response> uploadImages(String folder, List<String> filePaths) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload-images/$folder'));
    if (token != null) request.headers['Authorization'] = 'Bearer $token';
    for (final path in filePaths) {
      request.files.add(await http.MultipartFile.fromPath('images', path));
    }
    return await http.Response.fromStream(await request.send());
  }

  // ── ⚙️ Settings  /api/v1/settings ─────────────────────────────────────

  static Future<http.Response> getSettings() async => await get('/settings');
  static Future<http.Response> updateSettings(Map<String, dynamic> data) async => await put('/settings', data);

  // ── 🏷️ Platform Categories  /api/v1/category ───────────────────────────

  static Future<http.Response> getPlatformCategory(String slug) async => await get('/category/$slug');

  // ── ⭐ Reviews  /api/v1/reviews ────────────────────────────────────────

  /// GET /reviews/all/:businessId
  static Future<http.Response> getReviews(String businessId) async =>
      await get('/reviews/all/$businessId');

  /// POST /reviews/create
  static Future<http.Response> createReview(Map<String, dynamic> data) async =>
      await post('/reviews/create', data);

  // ── Staff (custom backend module) ──────────────────────────────────────

  static Future<http.Response> inviteStaff(Map<String, dynamic> data) async =>
      await post('/staff/invite', data);

  static Future<http.Response> staffLogin(String email, String password) async =>
      await post('/staff/login', {'email': email, 'password': password});

  static Future<http.Response> acceptInvite(String token, String password) async =>
      await post('/staff/accept-invite/$token', {'password': password});

  static Future<http.Response> fetchStaff(String businessId) async =>
      await get('/staff?business_id=$businessId');

  static Future<http.Response> updateStaff(String id, String businessId, Map<String, dynamic> data) async =>
      await patch('/staff/$id?business_id=$businessId', data);

  static Future<http.Response> deleteStaff(String id, String businessId) async =>
      await delete('/staff/$id?business_id=$businessId');

  // ── Attendance (custom backend module) ────────────────────────────────

  static Future<http.Response> clockIn(String staffId, String businessId) async =>
      await post('/attendance/clock-in', {'staff_id': staffId, 'business_id': businessId});

  static Future<http.Response> clockOut(String staffId, String businessId) async =>
      await post('/attendance/clock-out', {'staff_id': staffId, 'business_id': businessId});

  static Future<http.Response> getActiveSession(String staffId, String businessId) async =>
      await get('/attendance/active-session?staff_id=$staffId&business_id=$businessId');

  static Future<http.Response> fetchAttendance(String businessId, {String? from, String? to}) async {
    String ep = '/attendance?business_id=$businessId';
    if (from != null) ep += '&from=$from';
    if (to != null) ep += '&to=$to';
    return await get(ep);
  }

  static Future<http.Response> editAttendanceRecord(String id, String businessId, Map<String, dynamic> data) async =>
      await patch('/attendance/$id?business_id=$businessId', data);

  // ── Notifications (custom backend module) ─────────────────────────────

  static Future<http.Response> fetchNotifications(String ownerId) async =>
      await get('/notifications?owner_id=$ownerId');

  static Future<http.Response> markNotificationRead(String id, String ownerId) async =>
      await patch('/notifications/$id/read?owner_id=$ownerId', {});

  static Future<http.Response> markAllNotificationsRead(String ownerId) async =>
      await patch('/notifications/read-all?owner_id=$ownerId', {});

  // ── Typed convenience helpers ──────────────────────────────────────────

  static Future<List<Category>> fetchCategories() async {
    debugPrint('ApiService: Fetching platform categories');
    final response = await get('/category');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List list = data['data'] ?? [];
      return list.map((e) => Category.fromJson(e)).toList();
    }
    return [];
  }

  static Future<List<Business>> fetchBusinesses({String? categoryId, String? query, int page = 1, int limit = 20}) async {
    debugPrint('ApiService: Fetching businesses (category=$categoryId, query=$query, page=$page)');
    try {
      final res = await getBusinessList(category: categoryId, search: query, page: page, limit: limit);
      debugPrint('ApiService: Businesses response status: ${res.statusCode}');
      if (res.statusCode == 200) {
        try {
          final body = json.decode(res.body);
          final list = body['data'] as List? ?? [];
          debugPrint('ApiService: Got ${list.length} businesses');
          final businesses = <Business>[];
          for (final item in list) {
            try { businesses.add(Business.fromJson(item)); }
            catch (e) { debugPrint('ApiService: Skipped a bad business record: $e'); }
          }
          return businesses;
        } catch (e) {
          debugPrint('ApiService: Error parsing businesses — $e');
          return [];
        }
      }
      debugPrint('ApiService: Businesses fetch failed — ${res.body}');
    } catch (e) {
      debugPrint('ApiService: Network error fetching businesses — $e');
    }
    return [];
  }

  /// Fetches businesses with pagination metadata (total count for infinite scroll)
  static Future<({List<Business> businesses, int total, int totalPages})> fetchBusinessesPaginated({
    String? categoryId,
    String? query,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final res = await getBusinessList(category: categoryId, search: query, page: page, limit: limit);
      if (res.statusCode == 200) {
        try {
          final body = json.decode(res.body);
          final meta = body['meta'] as Map<String, dynamic>? ?? {};
          final list = body['data'] as List? ?? [];
          final parsedList = <Business>[];
          for (final item in list) {
            try { parsedList.add(Business.fromJson(item)); }
            catch (e) { debugPrint('ApiService: Skipped a bad business record: $e'); }
          }
          return (
            businesses: parsedList,
            total: (meta['total'] as num?)?.toInt() ?? 0,
            totalPages: (meta['totalPage'] as num?)?.toInt() ?? 1,
          );
        } catch (e) {
          debugPrint('ApiService: Error parsing businesses — $e');
        }
      }
    } catch (e) {
      debugPrint('ApiService: Network error in fetchBusinessesPaginated — $e');
    }
    return (businesses: <Business>[], total: 0, totalPages: 0);
  }

  static Future<Business?> fetchBusinessBySlug(String slug) async {
    final response = await get('/business/$slug');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Business.fromJson(data['data']);
    }
    return null;
  }

  static Future<List<Product>> fetchProductsByBusiness(String businessId, {String userId = ''}) async {
    final response = await getProducts(userId, businessId);
    if (response.statusCode == 200) {
      final List list = json.decode(response.body);
      return list.map((e) => Product.fromJson(e)).toList();
    }
    return [];
  }
}
