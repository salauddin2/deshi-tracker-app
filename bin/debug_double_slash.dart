import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  const baseUrl = 'https://api.desitracker.com/api/v1/';

  print('Testing Double Slash sensitivity:');
  
  for (final path in ['business/', '/business/']) {
    try {
      final target = '$baseUrl$path';
      print('\nTrying: $target');
      final response = await dio.get(target, queryParameters: {'isActive': 'true'});
      print('Status: ${response.statusCode}');
      if (response.data is Map && response.data.containsKey('data')) {
        print('Found ${(response.data['data'] as List).length} businesses.');
      }
    } catch (e) {
      print('Failed on $path: $e');
    }
  }
}
