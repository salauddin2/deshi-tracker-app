import '../models/category.dart';
import '../services/api_service.dart';

class CategoryRepository {
  final ApiService _apiService;

  CategoryRepository(this._apiService);

  Future<List<Category>> getCategories() async {
    try {
      final response = await _apiService.get('category/');
      if (response.statusCode == 200) {
        final data = response.data;
        final List list;
        if (data is Map && data.containsKey('data')) {
          list = data['data'] ?? [];
        } else if (data is List) {
          list = data;
        } else {
          list = [];
        }
        
        final parsed = <Category>[];
        for (final e in list) {
          try {
            parsed.add(Category.fromJson(e));
          } catch (err) {
            print('CategoryParseError: $err');
          }
        }
        return parsed;
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }
}
