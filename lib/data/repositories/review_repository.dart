import '../services/api_service.dart';

class ReviewRepository {
  final ApiService _api;
  ReviewRepository(this._api);

  Future<List<dynamic>> getReviews(String businessId) async {
    final r = await _api.get('/reviews/all/$businessId');
    return r.data['data'] ?? [];
  }

  Future<List<dynamic>> getAllReviews() async {
    final r = await _api.get('/reviews');
    return r.data['data'] ?? [];
  }

  Future<Map<String, dynamic>> submitReview({
    required String businessId,
    required int rating,
    required String comment,
  }) async {
    final r = await _api.post('/reviews/create', data: {
      'business': businessId,
      'rating': rating,
      'comment': comment,
    });
    return r.data;
  }

  Future<Map<String, dynamic>> toggleVisibility(String reviewId) async {
    final r = await _api.put('/reviews/$reviewId/visibility');
    return r.data;
  }

  Future<Map<String, dynamic>> updateReview(String reviewId, Map<String, dynamic> data) async {
    final r = await _api.put('/reviews/$reviewId', data: data);
    return r.data;
  }
}
