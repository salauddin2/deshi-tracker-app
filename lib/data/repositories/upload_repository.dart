import 'package:dio/dio.dart';
import '../services/api_service.dart';

class UploadRepository {
  final ApiService _api;
  UploadRepository(this._api);

  /// Upload one or more images. [folder] = 'profile' | 'myBusiness' | 'products'
  Future<List<String>> uploadImages(List<String> filePaths, String folder) async {
    final formData = FormData();
    for (final path in filePaths) {
      formData.files.add(MapEntry(folder, await MultipartFile.fromFile(path)));
    }
    final r = await _api.post('/upload-images/$folder', data: formData);
    if (r.statusCode == 200) {
      final List urls = r.data['data'] ?? [];
      return urls.map((e) => (e['url'] ?? '').toString()).toList();
    }
    return [];
  }
}
