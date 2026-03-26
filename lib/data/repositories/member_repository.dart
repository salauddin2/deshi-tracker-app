import '../services/api_service.dart';
import '../services/auth_service.dart';

class MemberRepository {
  final ApiService _apiService;
  final AuthService _authService;

  MemberRepository(this._apiService, this._authService);

  Future<Map<String, dynamic>> registerMember(Map<String, dynamic> data) async {
    final r = await _apiService.post('/members/register', data: data);
    return r.data;
  }

  Future<Map<String, dynamic>> loginMember(String phone, String password) async {
    final r = await _apiService.post('/members/login', data: {'phone': phone, 'password': password});
    if (r.statusCode == 200) await _authService.saveMemberToken(r.data['token']);
    return r.data;
  }

  Future<Map<String, dynamic>> getMemberMe() async {
    final r = await _apiService.get('/members/me');
    return r.data;
  }

  Future<Map<String, dynamic>> updateMemberMe(Map<String, dynamic> data) async {
    final r = await _apiService.patch('/members/me', data: data);
    return r.data;
  }

  Future<Map<String, dynamic>> verifyBySlug(String slug) async {
    final r = await _apiService.get('/members/verify/$slug');
    return r.data;
  }

  Future<Map<String, dynamic>> lookupBySerial(String serial) async {
    final r = await _apiService.get('/members/lookup/$serial');
    return r.data;
  }

  // ─── Booking ─────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> createBooking({
    required String businessId,
    required String name,
    String? email,
    String? phone,
    required int partySize,
    required String date,
    required String time,
  }) async {
    final r = await _apiService.post('/booking/create', data: {
      'business': businessId,
      'name': name,
      if (email != null && email.isNotEmpty) 'email': email,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      'partySize': partySize,
      'date': date,
      'time': time,
    });
    return r.data;
  }

  // ─── Restaurants with Member Discounts ───────────────────────────────────

  Future<List<dynamic>> getRestaurantsWithDiscounts() async {
    final r = await _apiService.get('/members/restaurants');
    return r.data['data'] ?? [];
  }

  // ─── Leads ───────────────────────────────────────────────────────────────

  Future<List<dynamic>> getLeads() async {
    final r = await _apiService.get('/members/me/leads');
    return r.data['data'] ?? [];
  }

  Future<Map<String, dynamic>> addLead(String memberId) async {
    final r = await _apiService.post('/members/me/leads', data: {'memberId': memberId});
    return r.data;
  }

  Future<void> removeLead(String memberId) async {
    await _apiService.delete('/members/me/leads/$memberId');
  }

  Future<Map<String, dynamic>> sendPromotion() async {
    final r = await _apiService.post('/members/me/leads/send-promotion');
    return r.data;
  }

  // ─── Search ──────────────────────────────────────────────────────────────

  Future<List<dynamic>> searchBySerial(String serial) async {
    final r = await _apiService.get('/members/search-by-serial', queryParameters: {'serial': serial});
    return r.data['data'] ?? [];
  }
}
