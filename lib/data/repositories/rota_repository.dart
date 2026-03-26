import '../services/api_service.dart';

class RotaRepository {
  final ApiService _api;
  RotaRepository(this._api);

  // --- Roles ---
  Future<List<dynamic>> getRoles(String businessId) async {
    final r = await _api.get('/rota/roles', queryParameters: {'business': businessId});
    return r.data['data'] ?? [];
  }

  Future<Map<String, dynamic>> createRole(Map<String, dynamic> data) async {
    final r = await _api.post('/rota/roles', data: data);
    return r.data;
  }

  Future<Map<String, dynamic>> updateRole(String id, Map<String, dynamic> data) async {
    final r = await _api.patch('/rota/roles/$id', data: data);
    return r.data;
  }

  Future<void> deleteRole(String id) async => await _api.delete('/rota/roles/$id');

  Future<Map<String, dynamic>> setRolePermissions(String roleId, List<String> tabs) async {
    final r = await _api.post('/rota/roles/$roleId/permissions', data: {'tabs': tabs});
    return r.data;
  }

  Future<List<dynamic>> getRolePermissions(String roleId) async {
    final r = await _api.get('/rota/roles/$roleId/permissions');
    return r.data['data'] ?? [];
  }

  // --- Employees ---
  Future<List<dynamic>> getEmployees(String businessId) async {
    final r = await _api.get('/rota/employees', queryParameters: {'business': businessId});
    return r.data['data'] ?? [];
  }

  Future<Map<String, dynamic>> createEmployee(Map<String, dynamic> data) async {
    final r = await _api.post('/rota/employees', data: data);
    return r.data;
  }

  Future<Map<String, dynamic>> updateEmployee(String id, Map<String, dynamic> data) async {
    final r = await _api.patch('/rota/employees/$id', data: data);
    return r.data;
  }

  Future<void> deleteEmployee(String id) async => await _api.delete('/rota/employees/$id');

  // --- Shifts ---
  Future<List<dynamic>> getShifts({String? businessId, String? employeeId, String? startDate, String? endDate}) async {
    final r = await _api.get('/rota/shifts', queryParameters: {
      if (businessId != null) 'business': businessId,
      if (employeeId != null) 'employee': employeeId,
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
    });
    return r.data['data'] ?? [];
  }

  Future<Map<String, dynamic>> createShift(Map<String, dynamic> data) async {
    final r = await _api.post('/rota/shifts', data: data);
    return r.data;
  }

  Future<Map<String, dynamic>> updateShift(String id, Map<String, dynamic> data) async {
    final r = await _api.patch('/rota/shifts/$id', data: data);
    return r.data;
  }

  Future<void> deleteShift(String id) async => await _api.delete('/rota/shifts/$id');
}
