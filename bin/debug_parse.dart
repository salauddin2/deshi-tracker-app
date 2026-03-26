import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:desitracker_mobile/data/models/user.dart';

void main() async {
  final dio = Dio();
  const baseUrl = 'https://api.desitracker.com/api/v1';

  try {
    final uRes = await dio.get('$baseUrl/users');
    final uData = uRes.data['data'] as List;
    
    int index = 0;
    for (final item in uData) {
      try {
        User.fromJson(item);
      } catch (e, st) {
        print('Failed on index $index: $e');
        // Save the raw JSON to see what's missing
        File('failed_user.json').writeAsStringSync(const JsonEncoder.withIndent('  ').convert(item));
        print('Saved raw json to failed_user.json');
        return;
      }
      index++;
    }
    print('All users parsed successfully!');
  } catch (e) {
    print('Error: $e');
  }
}
