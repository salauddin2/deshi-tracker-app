import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:desitracker_mobile/data/models/business.dart';

void main() async {
  final dio = Dio();
  const baseUrl = 'https://api.desitracker.com/api/v1';

  print('Fetching businesses from $baseUrl/business/...');
  try {
    final response = await dio.get('$baseUrl/business/', queryParameters: {
      'isActive': 'true',
      'isDeleted': 'false',
      'page': 1,
      'limit': 10,
    });
    
    final data = response.data;
    if (data == null || data['data'] == null) {
      print('Error: API returned no data or data["data"] is null');
      print('Full Response: $data');
      return;
    }

    final list = data['data'] as List;
    print('Found ${list.length} businesses. Starting parsing test...');
    
    int index = 0;
    int successCount = 0;
    for (final item in list) {
      try {
        Business.fromJson(item as Map<String, dynamic>);
        successCount++;
      } catch (e, st) {
        print('FAILED on index $index (Business Name: ${item['businessName']}):');
        print('Error: $e');
        // Save the raw JSON for inspection
        final fileName = 'failed_business_$index.json';
        File(fileName).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(item));
        print('Saved problematic JSON to $fileName');
      }
      index++;
    }
    
    print('\nParsing complete!');
    print('Successfully parsed: $successCount/${list.length}');
    if (successCount < list.length) {
      print('Check the failed_business_*.json files for details.');
    } else {
      print('All fetched businesses parsed perfectly!');
    }
  } catch (e) {
    print('Fatal Error during API request: $e');
    if (e is DioException) {
      print('Response: ${e.response?.data}');
    }
  }
}
