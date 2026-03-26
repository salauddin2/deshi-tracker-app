import '../services/api_service.dart';

class StaffRepository {
  final ApiService _apiService;

  StaffRepository(this._apiService);

  Future<Map<String, dynamic>> getActiveSession(String staffId, String businessId) async {
    final response = await _apiService.get('/attendance/active', queryParameters: {
      'staff_id': staffId,
      'business_id': businessId,
    });
    return response.data is Map ? response.data : {'data': null};
  }

  Future<List<dynamic>> fetchRotaShifts() async {
    final response = await _apiService.get('/rota/my-shifts');
    return response.data['data'] ?? (response.data is List ? response.data : []);
  }

  Future<Map<String, dynamic>> clockIn(String staffId, String businessId) async {
    final response = await _apiService.post('/attendance/clock-in', data: {
      'staff_id': staffId,
      'business_id': businessId,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> clockOut(String staffId, String businessId) async {
    final response = await _apiService.post('/attendance/clock-out', data: {
      'staff_id': staffId,
      'business_id': businessId,
    });
    return response.data;
  }

  // --- Roles ---
  Future<Map<String, dynamic>> fetchRotaRoles() async {
    final response = await _apiService.get('/rota/roles');
    return response.data;
  }

  Future<void> createRotaRole(Map<String, dynamic> data) async {
    await _apiService.post('/rota/roles', data: data);
  }

  Future<void> patchRotaRole(String id, Map<String, dynamic> data) async {
    await _apiService.patch('/rota/roles/$id', data: data);
  }

  Future<void> deleteRotaRole(String id) async {
    await _apiService.delete('/rota/roles/$id');
  }

  // --- Staff Management ---
  Future<Map<String, dynamic>> fetchStaff(String businessId) async {
    final response = await _apiService.get('/businesses/$businessId/staff');
    return response.data;
  }

  Future<Map<String, dynamic>> inviteStaff(Map<String, dynamic> data) async {
    final response = await _apiService.post('/businesses/invite-staff', data: data);
    return response.data;
  }

  Future<void> updateStaff(String id, String businessId, Map<String, dynamic> data) async {
    await _apiService.patch('/businesses/$businessId/staff/$id', data: data);
  }

  Future<void> deleteStaff(String id, String businessId) async {
    await _apiService.delete('/businesses/$businessId/staff/$id');
  }

  // --- Shift Management ---
  Future<void> createRotaShift(Map<String, dynamic> data) async {
    await _apiService.post('/rota/shifts', data: data);
  }

  Future<void> deleteRotaShift(String id) async {
    await _apiService.delete('/rota/shifts/$id');
  }

  // --- Attendance Management ---
  Future<Map<String, dynamic>> fetchAttendance(String businessId, {String? from}) async {
    final response = await _apiService.get('/attendance/business/$businessId', queryParameters: {
      if (from != null) 'from': from,
    });
    return response.data;
  }

  Future<void> editAttendanceRecord(String id, String businessId, Map<String, dynamic> data) async {
    await _apiService.patch('/attendance/$id', data: {
      ...data,
      'business_id': businessId,
    });
  }

  // --- Member Verification ---
  Future<Map<String, dynamic>> lookupMember(String serial) async {
    final response = await _apiService.get('/members/lookup/$serial');
    return response.data;
  }
}
