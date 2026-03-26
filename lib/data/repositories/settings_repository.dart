import '../services/api_service.dart';

class SettingsRepository {
  final ApiService _api;
  SettingsRepository(this._api);

  Future<Map<String, dynamic>> getSettings() async {
    final r = await _api.get('/settings');
    return r.data['data'] ?? r.data;
  }

  Future<Map<String, dynamic>> updateSettings(Map<String, dynamic> data) async {
    final r = await _api.put('/settings', data: data);
    return r.data;
  }

  Future<List<dynamic>> getSliders() async {
    final r = await _api.get('/slider/all');
    return r.data['data'] ?? [];
  }

  Future<void> deleteSlider(String id) async => await _api.delete('/slider/delete/$id');

  Future<List<dynamic>> getBanners() async {
    final r = await _api.get('/banner/all');
    return r.data['data'] ?? [];
  }

  Future<void> deleteBanner(String id) async => await _api.delete('/banner/delete/$id');
}
