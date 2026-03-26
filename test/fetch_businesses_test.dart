import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:desitracker_mobile/models/business.dart';

void main() async {
  try {
    debugPrint('Fetching businesses...');
    final res = await http.get(Uri.parse('https://api.desitracker.com/api/v1/business?isActive=true&isDeleted=false&page=1&limit=20'));
    debugPrint('Status: \${res.statusCode}');
    
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final list = data['data'] as List? ?? [];
      debugPrint('Got \${list.length} businesses. Parsing...');
      
      for (final item in list) {
        try {
          Business.fromJson(item);
        } catch (e, stack) {
          debugPrint("Error parsing business (ID: \${item['_id']}): \$e");
          debugPrint(stack.toString());
          break;
        }
      }
      debugPrint('Successfully parsed businesses.');
    }
  } catch (e) {
    debugPrint('Failed to fetch: \$e');
  }
}
