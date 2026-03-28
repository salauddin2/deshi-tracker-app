import 'package:dio/dio.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final ApiService _apiService;
  final AuthService _authService;

  AuthRepository(this._apiService, this._authService);

  Future<User?> login(String emailOrPhone, String password) async {
    try {
      final response = await _apiService.post('auth/login', data: {
        'email': emailOrPhone.contains('@') ? emailOrPhone : null,
        'phoneNumber': !emailOrPhone.contains('@') ? emailOrPhone : null,
        'password': password,
      }..removeWhere((k, v) => v == null));

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final token = response.data['token'];
        final user = User.fromJson(data);

        // Save token based on role (simplification for now)
        if (user.role == 'business_owner') {
          await _authService.saveOwnerToken(token);
        } else {
          await _authService.saveMemberToken(token);
        }
        await _authService.saveUserRole(user.role);

        return user;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<User?> getMe() async {
    try {
      final response = await _apiService.get('users/me');
      if (response.statusCode == 200) {
        return User.fromJson(response.data['data']);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<void> logout() async {
    try {
      await _apiService.post('auth/logout');
    } finally {
      await _authService.clearAll();
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await _apiService.post('users/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'role': 'user',
      });
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> resetPassword(String token, String newPassword) async {
    try {
      final response = await _apiService.post('auth/reset-password/$token', data: {
        'newPassword': newPassword,
      });
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      final response = await _apiService.post('auth/forgot-password', data: {
        'email': email,
      });
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _authService.getOwnerToken() ??
                  await _authService.getStaffToken() ??
                  await _authService.getMemberToken();
    return token != null;
  }

  Future<User?> updateProfile(Map<String, dynamic> data) async {
    final response = await _apiService.patch('users/profile/update', data: data);
    if (response.statusCode == 200) {
      return User.fromJson(response.data['data']);
    }
    return null;
  }

  Future<void> saveAppMode(String mode) async {
    await _authService.saveAppMode(mode);
  }

  Future<String?> getAppMode() async {
    return await _authService.getAppMode();
  }

  Future<User?> staffLogin(String email, String password) async {
    final response = await _apiService.post('staff/login', data: {
      'email': email,
      'password': password,
    });
    if (response.statusCode == 200) {
      final token = response.data['token'];
      final user = User.fromJson(response.data['data']);
      await _authService.saveStaffToken(token);
      await _authService.saveUserRole('staff');
      return user;
    }
    return null;
  }

  Future<bool> setupStaffAccount(String token, String password) async {
    final response = await _apiService.post('staff/setup-account/$token', data: {
      'password': password,
    });
    return response.statusCode == 200;
  }

  Future<String?> uploadProfilePhoto(String filePath) async {
    final formData = FormData.fromMap({
      'profile': await MultipartFile.fromFile(filePath),
    });
    final response = await _apiService.post('upload-images/profile', data: formData);
    if (response.statusCode == 200) {
      return response.data['data']?['url'] ?? response.data['url'];
    }
    return null;
  }
}
