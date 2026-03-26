import 'package:dio/dio.dart';
import '../models/business.dart';
import '../services/api_service.dart';

class BusinessRepository {
  final ApiService _apiService;

  BusinessRepository(this._apiService);

  Future<List<Business>> getBusinesses({
    String? categoryId,
    String? query,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get('/business/', queryParameters: {
        'isActive': 'true',
        'isDeleted': 'false',
        'page': page,
        'limit': limit,
        if (query != null && query.isNotEmpty) 'searchTerm': query,
        if (categoryId != null && categoryId.isNotEmpty) 'category': categoryId,
      });

      if (response.statusCode == 200) {
        final List list = response.data['data'] ?? [];
        final parsed = <Business>[];
        for (final e in list) {
          try {
            parsed.add(Business.fromJson(e));
          } catch (err) {
            print('BusinessParseError: $err'); // Skip invalid businesses
          }
        }
        return parsed;
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }

  Future<Business?> getBusinessBySlug(String slug) async {
    try {
      final response = await _apiService.get('/business/$slug');
      if (response.statusCode == 200) {
        return Business.fromJson(response.data['data']);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<Map<String, dynamic>> fetchAnalytics(String businessId) async {
    final response = await _apiService.get('/analytics/$businessId');
    return response.data['data'] ?? response.data;
  }

  Future<Map<String, dynamic>> fetchContactAnalytics(String businessId) async {
    final response = await _apiService.get('/analytics/$businessId/contact');
    return response.data['data'] ?? response.data;
  }

  Future<List<dynamic>> getReviews(String businessId) async {
    final response = await _apiService.get('/reviews/all/$businessId');
    return response.data['data'] ?? response.data ?? [];
  }

  // --- Categories ---
  Future<List<dynamic>> fetchCategories() async {
    final response = await _apiService.get('/category/');
    final List list = response.data['data'] ?? [];
    return list;
  }

  Future<Map<String, dynamic>> getPlatformCategory(String slug) async {
    final response = await _apiService.get('/category/$slug');
    return response.data;
  }

  // --- Business Management ---
  Future<Map<String, dynamic>> registerBusiness(Map<String, dynamic> data) async {
    final response = await _apiService.post('/business/register', data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> updateBusiness(String slug, Map<String, dynamic> data) async {
    final response = await _apiService.put('/business/$slug', data: data);
    return response.data;
  }

  Future<void> deleteBusiness(String slug) async {
    await _apiService.delete('/business/$slug');
  }

  Future<Map<String, dynamic>> submitReview({
    required String businessId,
    required int rating,
    required String comment,
  }) async {
    final response = await _apiService.post('/reviews/create', data: {
      'business': businessId,
      'rating': rating,
      'comment': comment,
    });
    return response.data;
  }

  Future<List<String>> uploadBusinessPhotos(List<String> filePaths) async {
    final formData = FormData();
    for (final path in filePaths) {
      formData.files.add(MapEntry(
        'myBusiness',
        await MultipartFile.fromFile(path),
      ));
    }
    final response = await _apiService.post('/upload-images/myBusiness', data: formData);
    if (response.statusCode == 200) {
      final List urls = response.data['data'] ?? [];
      return urls.map((e) => e['url'].toString()).toList();
    }
    return [];
  }
}
