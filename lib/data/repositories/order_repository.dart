import '../services/api_service.dart';

class OrderRepository {
  final ApiService _apiService;

  OrderRepository(this._apiService);

  Future<Map<String, dynamic>> fetchOrders({
    required String businessId,
    String? from,
    String? to,
    String? status,
  }) async {
    final response = await _apiService.get('orders/business/$businessId', queryParameters: {
      if (from != null) 'from': from,
      if (to != null) 'to': to,
      if (status != null) 'status': status,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> updateOrder(String id, Map<String, dynamic> data) async {
    final response = await _apiService.patch('orders/$id', data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> data) async {
    final response = await _apiService.post('orders', data: data);
    return response.data;
  }
}
