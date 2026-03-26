import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  final url = Uri.parse('https://api.desitracker.com/api/v1/business/?isActive=true&isDeleted=false&page=1&limit=20');

  try {
    debugPrint('GET //api.desitracker.com/api/v1/business/?isActive=true');
    final response = await http.get(url, headers: {'Accept': 'application/json'});
    debugPrint('Status: ${response.statusCode}');
    
    final body = json.decode(response.body);
    debugPrint('Keys in response: ${body.keys.toList()}');
    
    final meta = body['meta'] as Map<String, dynamic>?;
    debugPrint('Meta: $meta');
    
    final list = body['data'] as List?;
    if (list != null) {
      debugPrint('Got ${list.length} businesses.');
      if (list.isNotEmpty) {
        // Try parsing the first one manually
        final first = list.first;
        debugPrint('First business keys: ${first.keys.toList()}');
        
        // Print location format carefully
        if (first['location'] != null) {
          debugPrint('Location struct: ${first['location']}');
        } else if (first['locations'] != null) {
          debugPrint('Locations struct: ${first['locations']}');
        }
      }
    } else {
      debugPrint('data array is missing or null: ${body['data']}');
    }
  } catch (e, st) {
    debugPrint('Error: $e');
    debugPrint(st.toString());
  }
}
