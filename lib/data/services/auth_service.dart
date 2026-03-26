import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const _ownerTokenKey = 'owner_token';
  static const _staffTokenKey = 'staff_token';
  static const _memberTokenKey = 'member_token';
  static const _userRoleKey = 'user_role';
  static const _appModeKey = 'app_mode';

  Future<void> saveOwnerToken(String token) async {
    await _storage.write(key: _ownerTokenKey, value: token);
  }

  Future<String?> getOwnerToken() async {
    return await _storage.read(key: _ownerTokenKey);
  }

  Future<void> saveStaffToken(String token) async {
    await _storage.write(key: _staffTokenKey, value: token);
  }

  Future<String?> getStaffToken() async {
    return await _storage.read(key: _staffTokenKey);
  }

  Future<void> saveMemberToken(String token) async {
    await _storage.write(key: _memberTokenKey, value: token);
  }

  Future<String?> getMemberToken() async {
    return await _storage.read(key: _memberTokenKey);
  }

  Future<void> saveUserRole(String role) async {
    await _storage.write(key: _userRoleKey, value: role);
  }

  Future<String?> getUserRole() async {
    return await _storage.read(key: _userRoleKey);
  }

  Future<void> saveAppMode(String mode) async {
    await _storage.write(key: _appModeKey, value: mode);
  }

  Future<String?> getAppMode() async {
    return await _storage.read(key: _appModeKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
