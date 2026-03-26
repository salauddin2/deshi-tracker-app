import '../services/api_service.dart';

class AnalyticsRepository {
  final ApiService _api;
  AnalyticsRepository(this._api);

  Future<Map<String, dynamic>> getAdminStats() async {
    final r = await _api.get('/analytics');
    return r.data['data'] ?? r.data;
  }

  Future<Map<String, dynamic>> getBusinessAnalytics(String businessId) async {
    final r = await _api.get('/analytics/$businessId');
    return r.data['data'] ?? r.data;
  }

  Future<void> logVisit(String businessId) async {
    try {
      await _api.post('/analytics/$businessId/visit');
    } catch (_) {}
  }

  Future<Map<String, dynamic>> getContactAnalytics(String businessId) async {
    final r = await _api.get('/analytics/$businessId/contact');
    return r.data['data'] ?? r.data;
  }

  Future<void> logContactClick(String businessId) async {
    try {
      await _api.post('/analytics/$businessId');
    } catch (_) {}
  }
}
