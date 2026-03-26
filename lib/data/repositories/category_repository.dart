import '../models/category.dart';
import '../services/api_service.dart';

class CategoryRepository {
  final ApiService _apiService;

  CategoryRepository(this._apiService);

  Future<List<Category>> getCategories() async {
    try {
      final response = await _apiService.get('/category/all');
      if (response.statusCode == 200) {
        final List list = response.data['data'] ?? [];
        return list.map((e) => Category.fromJson(e)).toList();
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }
}
