import '../services/api_service.dart';

class NotificationRepository {
  final ApiService _apiService;

  NotificationRepository(this._apiService);

  Future<Map<String, dynamic>> fetchNotifications() async {
    final response = await _apiService.get('/notifications');
    return response.data is Map ? response.data : {'data': [], 'unread_count': 0};
  }

  Future<void> markRead(String id) async {
    await _apiService.patch('/notifications/$id/read');
  }

  Future<void> markAllRead() async {
    await _apiService.patch('/notifications/read-all');
  }

  Future<void> registerDeviceToken(String token, String platform) async {
    await _apiService.post('/notifications/device-token', data: {
      'token': token,
      'platform': platform,
    });
  }
}
