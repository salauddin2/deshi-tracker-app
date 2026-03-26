import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  final catUrl = Uri.parse('https://api.desitracker.com/api/v1/category/');
  final bizUrl = Uri.parse('https://api.desitracker.com/api/v1/business/?isActive=true&isDeleted=false&page=1&limit=20');

  debugPrint('Testing Categories Endpoint...');
  try {
    final resCat = await http.get(catUrl, headers: {'Accept': 'application/json'});
    debugPrint('Category Status: ${resCat.statusCode}');
    String cBody = resCat.body;
    if (cBody.length > 200) cBody = '${cBody.substring(0, 200)}...';
    debugPrint('Category Body: $cBody');
  } catch (e) {
    debugPrint('Category Error: $e');
  }

  debugPrint('\nTesting Business Endpoint...');
  try {
    final resBiz = await http.get(bizUrl, headers: {'Accept': 'application/json'});
    debugPrint('Business Status: ${resBiz.statusCode}');
    String bBody = resBiz.body;
    if (bBody.length > 200) bBody = '${bBody.substring(0, 200)}...';
    debugPrint('Business Body: $bBody');
  } catch (e) {
    debugPrint('Business Error: $e');
  }
}
