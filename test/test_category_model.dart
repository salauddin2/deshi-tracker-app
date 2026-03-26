import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:desitracker_mobile/data/models/category.dart' as model;

Future<void> main() async {
  final url = Uri.parse('https://api.desitracker.com/api/v1/category/');

  try {
    debugPrint('GET //api.desitracker.com/api/v1/category/');
    final response = await http.get(url, headers: {'Accept': 'application/json'});
    debugPrint('Status: ${response.statusCode}');
    
    final body = json.decode(response.body);
    final list = body['data'] as List?;
    
    if (list != null && list.isNotEmpty) {
      debugPrint('Parsing ${list.length} categories...');
      for (int i = 0; i < list.length; i++) {
        try {
          final c = model.Category.fromJson(list[i]);
          debugPrint('Parsed OK: ${c.name}');
        } catch (e) {
          debugPrint('ERROR parsing index $i: $e');
          debugPrint('Problematic JSON: ${json.encode(list[i])}');
          break;
        }
      }
    } else {
      debugPrint('Categories data is empty or null');
    }
  } catch (e) {
    debugPrint('Error: $e');
  }
}
