import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  final url = Uri.parse('https://api.desitracker.com/api/v1/auth/login');
  
  // Try dummy login just to see the real response format
  final body = json.encode({
    'email': 'test@example.com',
    'password': 'password123'
  });

  try {
    debugPrint('Sending POST to $url...');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: body,
    );
    
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');
  } catch (e) {
    debugPrint('Error: $e');
  }
}
