import 'package:dio/dio.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductRepository {
  final ApiService _apiService;

  ProductRepository(this._apiService);

  Future<List<Product>> getProductsByBusiness(String businessId, {String userId = ''}) async {
    final response = await _apiService.get('/products/products/$userId/$businessId');
    final List list = response.data['data'] ?? (response.data is List ? response.data : []);
    return list.map((e) => Product.fromJson(e)).toList();
  }

  Future<String?> uploadProductImage(String filePath) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(filePath),
    });
    final response = await _apiService.post('/upload-images/products', data: formData);
    return response.data['url'];
  }

  Future<Map<String, dynamic>> getProductsRaw(String userId, String businessId) async {
    final response = await _apiService.get('/products/products/$userId/$businessId');
    return response.data;
  }

  Future<Product?> getProductById(String id) async {
    final response = await _apiService.get('/products/product/$id');
    return Product.fromJson(response.data);
  }

  // --- Categories ---
  Future<List<dynamic>> getCategories() async {
    final response = await _apiService.get('/products/category');
    return response.data['data'] ?? (response.data is List ? response.data : []);
  }

  Future<Map<String, dynamic>> getProductCategories(String userId, String businessId) async {
    final response = await _apiService.get('/products/products-category/$userId/$businessId');
    return response.data;
  }

  Future<void> createCategory(Map<String, dynamic> data) async {
    await _apiService.post('/products/category', data: data);
  }

  Future<void> updateCategory(String id, Map<String, dynamic> data) async {
    await _apiService.patch('/products/category/$id', data: data);
  }

  Future<void> deleteCategory(String id) async {
    await _apiService.delete('/products/category/$id');
  }

  // --- Products ---
  Future<void> createProduct(Map<String, dynamic> data) async {
    await _apiService.post('/products/create', data: data);
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    await _apiService.patch('/products/update/$id', data: data);
  }

  Future<void> deleteProduct(String id) async {
    await _apiService.delete('/products/delete/$id');
  }

  // --- Options ---
  Future<Map<String, dynamic>> fetchProductOptions() async {
    final response = await _apiService.get('/products/options');
    return response.data;
  }

  Future<void> createProductOption(Map<String, dynamic> data) async {
    await _apiService.post('/products/options', data: data);
  }

  Future<void> updateProductOption(String id, Map<String, dynamic> data) async {
    await _apiService.patch('/products/options/$id', data: data);
  }

  Future<void> deleteProductOption(String id) async {
    await _apiService.delete('/products/options/$id');
  }
}
