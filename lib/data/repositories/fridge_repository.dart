import '../services/api_service.dart';

class FridgeRepository {
  final ApiService _api;
  FridgeRepository(this._api);

  Future<List<dynamic>> getFridges(String userId) async {
    final r = await _api.get('/fridges/$userId');
    return r.data['data'] ?? [];
  }

  Future<Map<String, dynamic>> createFridge(Map<String, dynamic> data) async {
    final r = await _api.post('/fridges/create', data: data);
    return r.data;
  }

  Future<List<dynamic>> getRecords(String fridgeId, {String? startDate, String? endDate}) async {
    final r = await _api.get('/fridges/records/$fridgeId', queryParameters: {
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
    });
    return r.data['data'] ?? [];
  }

  Future<Map<String, dynamic>> addRecord(Map<String, dynamic> data) async {
    final r = await _api.post('/fridges/add-record', data: data);
    return r.data;
  }

  Future<Map<String, dynamic>> editRecord(Map<String, dynamic> data) async {
    final r = await _api.put('/fridges/edit-record', data: data);
    return r.data;
  }
}
