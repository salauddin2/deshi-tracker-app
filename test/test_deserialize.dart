import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:desitracker_mobile/models/business.dart';

void main() async {
  try {
    final response = await http.get(Uri.parse('https://api.desitracker.com/api/v1/business?isActive=true&page=1&limit=20'));
    final body = json.decode(response.body);
    final list = body['data'] as List? ?? [];
    
    for (int i = 0; i < list.length; i++) {
      try {
        Business.fromJson(list[i]);
      } catch (e) {
        debugPrint('Error parsing business at index $i:');
        debugPrint('Business ID: ${list[i]['_id']} Name: ${list[i]['businessName']}');
        debugPrint(e.toString());
        return; // Stop on first error
      }
    }
    debugPrint('Successfully parsed ${list.length} businesses.');
  } catch (e) {
    debugPrint('Fetch error: $e');
  }
}
