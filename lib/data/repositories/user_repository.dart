import '../services/api_service.dart';

class UserRepository {
  final ApiService _api;
  UserRepository(this._api);

  Future<Map<String, dynamic>> getMe() async {
    final r = await _api.get('/users/me');
    return r.data['data'] ?? r.data;
  }

  Future<List<dynamic>> getAllUsers() async {
    final r = await _api.get('/users');
    return r.data['data'] ?? [];
  }

  Future<Map<String, dynamic>> getUser(String id) async {
    final r = await _api.get('/users/$id');
    return r.data['data'] ?? r.data;
  }

  Future<Map<String, dynamic>> updateUser(String id, Map<String, dynamic> data) async {
    final r = await _api.put('/users/$id', data: data);
    return r.data;
  }

  Future<void> deleteUser(String id) async => await _api.delete('/users/$id');
}
