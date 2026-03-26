import '../services/api_service.dart';

class AttendanceRepository {
  final ApiService _api;
  AttendanceRepository(this._api);

  Future<Map<String, dynamic>> clockIn() async {
    final r = await _api.post('/attendance/clock-in');
    return r.data;
  }

  Future<Map<String, dynamic>> clockOut() async {
    final r = await _api.post('/attendance/clock-out');
    return r.data;
  }

  Future<Map<String, dynamic>> getActiveSession() async {
    final r = await _api.get('/attendance/me/active-session');
    return r.data['data'] ?? {};
  }

  Future<Map<String, dynamic>> endPreviousSession() async {
    final r = await _api.post('/attendance/me/end-previous-session');
    return r.data;
  }

  Future<List<dynamic>> getMyAttendance() async {
    final r = await _api.get('/attendance/me');
    return r.data['data'] ?? [];
  }

  Future<List<dynamic>> getAllAttendance({
    String? businessId,
    String? filter,
    String? staffId,
    String? startDate,
    String? endDate,
  }) async {
    final r = await _api.get('/attendance', queryParameters: {
      if (businessId != null) 'business': businessId,
      if (filter != null) 'filter': filter,
      if (staffId != null) 'staffId': staffId,
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
    });
    return r.data['data'] ?? [];
  }

  Future<Map<String, dynamic>> editSession(String id, {String? clockIn, String? clockOut}) async {
    final r = await _api.patch('/attendance/$id', data: {
      if (clockIn != null) 'clockIn': clockIn,
      if (clockOut != null) 'clockOut': clockOut,
    });
    return r.data;
  }
}
