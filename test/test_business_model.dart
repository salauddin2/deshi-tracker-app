import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:desitracker_mobile/models/business.dart'; // import the business model

Future<void> main() async {
  final url = Uri.parse('https://api.desitracker.com/api/v1/business/?isActive=true&page=1&limit=20');

  try {
    final response = await http.get(url, headers: {'Accept': 'application/json'});
    final body = json.decode(response.body);
    final list = body['data'] as List?;
    
    if (list != null && list.isNotEmpty) {
      debugPrint('Parsing ${list.length} businesses...');
      for (int i = 0; i < list.length; i++) {
        try {
          final b = Business.fromJson(list[i]);
          debugPrint('Parsed OK: ${b.businessName}');
        } catch (e, st) {
          debugPrint('ERROR parsing index $i: $e');
          debugPrint(st.toString());
          // debugPrint the problematic JSON
          // debugPrint(json.encode(list[i]));
          break; // Stop at first error
        }
      }
    }
  } catch (e) {
    debugPrint('Error: $e');
  }
}
