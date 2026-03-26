import '../services/api_service.dart';

class OfferRepository {
  final ApiService _apiService;

  OfferRepository(this._apiService);

  Future<List<dynamic>> fetchDayOffers({String? businessId}) async {
    final response = await _apiService.get('/products/poffer/day-offers', queryParameters: {
      if (businessId != null) 'business_id': businessId,
    });
    return response.data is List ? response.data : (response.data['data'] ?? []);
  }

  Future<Map<String, dynamic>> createDayOffer(Map<String, dynamic> data) async {
    final response = await _apiService.post('/products/poffer/day-offers', data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> updateDayOffer(String id, Map<String, dynamic> data) async {
    final response = await _apiService.patch('/products/poffer/day-offers/$id', data: data);
    return response.data;
  }

  Future<void> deleteDayOffer(String id) async {
    await _apiService.delete('/products/poffer/day-offers/$id');
  }
}
