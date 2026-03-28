import 'dart:convert';
import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  const baseUrl = 'https://api.desitracker.com/api/v1';

  print('Testing Category Endpoints:');
  
  for (final path in ['/category', '/category/']) {
    try {
      print('\nTrying: $baseUrl$path');
      final response = await dio.get('$baseUrl$path');
      print('Status: ${response.statusCode}');
      final data = response.data;
      if (data is Map && data.containsKey('data')) {
        final list = data['data'] as List;
        print('Found ${list.length} categories.');
      } else {
        print('Unexpected response structure: $data');
      }
    } catch (e) {
      print('Failed on $path: $e');
    }
  }

  print('\nTesting Business Endpoints:');
  for (final path in ['/business', '/business/']) {
    try {
      print('\nTrying: $baseUrl$path');
      final response = await dio.get('$baseUrl$path', queryParameters: {'isActive': 'true'});
      print('Status: ${response.statusCode}');
      final data = response.data;
      if (data is Map && data.containsKey('data')) {
        final list = data['data'] as List;
        print('Found ${list.length} businesses.');
      } else {
        print('Unexpected response structure: $data');
      }
    } catch (e) {
      print('Failed on $path: $e');
    }
  }
}
