import 'package:flutter/material.dart';
import 'package:desitracker_mobile/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final biz = await ApiService.fetchBusinessBySlug('tartan-steak-grill');
    if (biz != null) {
      debugPrint('✅ Business Found: ${biz.businessName} (ID: ${biz.id}, Owner: ${biz.ownerId})');
      final products = await ApiService.fetchProductsByBusiness(biz.id, userId: biz.ownerId);
      debugPrint('✅ Products Fetched: ${products.length}');
      for (var p in products) {
        debugPrint(' - ${p.name}: ${p.currency} ${p.finalPrice}');
      }
    } else {
      debugPrint('❌ Business not found.');
    }
  } catch (e) {
    debugPrint('❌ Error: $e');
  }
}
