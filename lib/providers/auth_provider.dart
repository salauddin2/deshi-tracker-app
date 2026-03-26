import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import '../models/business.dart';

enum AppMode { ownerMode, memberMode }

class AuthProvider with ChangeNotifier {
  String? _token;
  UserRole _role = UserRole.user;
  User? _currentUser;
  Business? _currentBusiness;
  bool _isInit = false;

  // Staff-specific fields
  String? _staffId;
  String? _staffBusinessId;
  String? _staffName;
  bool _isStaff = false;

  // Dual mode
  AppMode _appMode = AppMode.ownerMode;

  // Getters
  bool get isAuthenticated => _token != null;
  UserRole get role => _role;
  User? get currentUser => _currentUser;
  Business? get currentBusiness => _currentBusiness;
  bool get isInit => _isInit;
  bool get isStaff => _isStaff;
  AppMode get appMode => _appMode;

  // Staff getters
  String? get staffId => _staffId;
  String? get staffBusinessId => _staffBusinessId;
  String? get staffName => _staffName;

  AuthProvider() {
    _loadStoredAuth();
  }

  Future<void> _loadStoredAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    final storedRole = prefs.getString('user_role');
    
    if (_token != null && storedRole != null) {
      _role = _parseRole(storedRole);
      final userStr = prefs.getString('user_context');
      if (userStr != null) {
        try {
          _currentUser = User.fromJson(json.decode(userStr));
        } catch (e) {
          debugPrint('Error parsing user context: $e');
        }
      }
      final businessStr = prefs.getString('business_context');
      if (businessStr != null) {
        try {
          _currentBusiness = Business.fromJson(json.decode(businessStr));
        } catch (e) {
          debugPrint('Error parsing business context: $e');
        }
      }
      // Staff session
      _isStaff = prefs.getBool('is_staff') ?? false;
      _staffId = prefs.getString('staff_id');
      _staffBusinessId = prefs.getString('staff_business_id');
      _staffName = prefs.getString('staff_name');
      // App mode
      final storedMode = prefs.getString('app_mode');
      _appMode = storedMode == 'member' ? AppMode.memberMode : AppMode.ownerMode;
    }
    _isInit = true;
    notifyListeners();
  }

  UserRole _parseRole(String roleStr) {
    switch (roleStr) {
      case 'admin':
        return UserRole.admin;
      case 'business_owner':
        return UserRole.businessOwner;
      case 'staff':
        return UserRole.user; // no dedicated staff enum; use isStaff flag
      default:
        return UserRole.user;
    }
  }

  Future<bool> login(String emailOrPhone, String password) async {
    try {
      final response = await ApiService.login(emailOrPhone, password);
      debugPrint('Login Response Status: ${response.statusCode}');
      debugPrint('Login Response Body: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return await _handleAuthResponse(data);
      }
      return false;
    } catch (e) {
      debugPrint('Login Error: $e');
      return false;
    }
  }

  /// Staff login — returns true and sets staff context on success
  Future<bool> staffLogin(String email, String password) async {
    try {
      final response = await ApiService.staffLogin(email, password);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final token = data['data']?['accessToken'];
        final staffData = data['data']?['staff'] as Map<String, dynamic>?;
        if (token != null && staffData != null) {
          _token = token;
          _isStaff = true;
          _staffId = staffData['id']?.toString() ?? '';
          _staffBusinessId = staffData['business_id']?.toString() ?? '';
          _staffName = '${staffData['firstName'] ?? ''} ${staffData['lastName'] ?? ''}'.trim();
          _role = UserRole.user;

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', _token!);
          await prefs.setString('user_role', 'staff');
          await prefs.setBool('is_staff', true);
          await prefs.setString('staff_id', _staffId ?? '');
          await prefs.setString('staff_business_id', _staffBusinessId ?? '');
          await prefs.setString('staff_name', _staffName ?? '');

          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Staff Login Error: $e');
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    String? filePath,
  }) async {
    try {
      final response = await ApiService.register({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'role': 'business_owner',
      }, filePath: filePath);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return await _handleAuthResponse(data);
      }
      return false;
    } catch (e) {
      debugPrint('Registration Error: $e');
      return false;
    }
  }

  Future<bool> _handleAuthResponse(Map<String, dynamic> data) async {
    final token = data['data']?['accessToken'];
    final userData = data['data']?['user'];

    if (token != null) {
      final parts = token.split('.');
      if (parts.length == 3) {
        Map<String, dynamic> payload = json.decode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1])))
        );
        
        if (userData != null) {
          payload.addAll(userData);
        }

        _token = token;
        _currentUser = User.fromJson(payload);
        _role = _currentUser!.role;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        await prefs.setString('user_role', _role.name);
        await prefs.setString('user_context', json.encode(payload));

        notifyListeners();
        return true;
      }
    }
    return false;
  }

  /// Set the current business context (called when business dashboard loads)
  void setCurrentBusiness(Business business) {
    _currentBusiness = business;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('business_context', json.encode(business.toJson()));
    });
    notifyListeners();
  }

  /// Toggle between owner mode and member mode
  Future<void> toggleAppMode() async {
    _appMode = _appMode == AppMode.ownerMode ? AppMode.memberMode : AppMode.ownerMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_mode', _appMode == AppMode.memberMode ? 'member' : 'owner');
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _role = UserRole.user;
    _currentUser = null;
    _currentBusiness = null;
    _isStaff = false;
    _staffId = null;
    _staffBusinessId = null;
    _staffName = null;
    _appMode = AppMode.ownerMode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_role');
    await prefs.remove('user_context');
    await prefs.remove('business_context');
    await prefs.remove('is_staff');
    await prefs.remove('staff_id');
    await prefs.remove('staff_business_id');
    await prefs.remove('staff_name');
    await prefs.remove('app_mode');

    notifyListeners();
  }
}

