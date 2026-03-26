import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/user.dart';
import '../../../data/models/business.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../providers/data_providers.dart';

part 'auth_provider.g.dart';

enum AppMode { ownerMode, memberMode }

enum UserRole { user, staff, businessOwner, admin }

class AuthState {
  final String? token;
  final User? user;
  final Business? business;
  final bool isLoading;
  final bool isInit;
  final AppMode appMode;

  AuthState({
    this.token,
    this.user,
    this.business,
    this.isLoading = false,
    this.isInit = false,
    this.appMode = AppMode.ownerMode,
  });

  bool get isAuthenticated => user != null;

  UserRole get role {
    if (user == null) return UserRole.user;
    switch (user!.role) {
      case 'staff':
        return UserRole.staff;
      case 'business_owner':
        return UserRole.businessOwner;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.user;
    }
  }

  AuthState copyWith({
    String? token,
    User? user,
    Business? business,
    bool? isLoading,
    bool? isInit,
    AppMode? appMode,
  }) {
    return AuthState(
      token: token ?? this.token,
      user: user ?? this.user,
      business: business ?? this.business,
      isLoading: isLoading ?? this.isLoading,
      isInit: isInit ?? this.isInit,
      appMode: appMode ?? this.appMode,
    );
  }
}

@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
    _init();
    return AuthState();
  }

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    final user = await _repository.getMe();
    final savedMode = await _repository.getAppMode();
    final appMode = savedMode == 'memberMode' ? AppMode.memberMode : AppMode.ownerMode;
    state = state.copyWith(user: user, isInit: true, isLoading: false, appMode: appMode);
  }

  Future<bool> login(String emailOrPhone, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _repository.login(emailOrPhone, password);
      if (user != null) {
        state = state.copyWith(user: user, isLoading: false);
        return true;
      }
    } catch (e) {
      // Handle error
    }
    state = state.copyWith(isLoading: false);
    return false;
  }

  Future<bool> staffLogin(String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _repository.staffLogin(email, password);
      if (user != null) {
        state = state.copyWith(user: user, isLoading: false);
        return true;
      }
    } catch (e) {
      // Handle error
    }
    state = state.copyWith(isLoading: false);
    return false;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    state = state.copyWith(isLoading: true);
    final success = await _repository.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
    state = state.copyWith(isLoading: false);
    return success;
  }

  Future<bool> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true);
    final success = await _repository.forgotPassword(email);
    state = state.copyWith(isLoading: false);
    return success;
  }

  Future<bool> resetPassword(String token, String newPassword) async {
    state = state.copyWith(isLoading: true);
    final success = await _repository.resetPassword(token, newPassword);
    state = state.copyWith(isLoading: false);
    return success;
  }

  void setCurrentBusiness(Business business) {
    state = state.copyWith(business: business);
  }

  void toggleAppMode() {
    final newMode = state.appMode == AppMode.ownerMode ? AppMode.memberMode : AppMode.ownerMode;
    state = state.copyWith(appMode: newMode);
    _repository.saveAppMode(newMode.name);
  }

  Future<void> logout() async {
    await _repository.logout();
    state = AuthState(isInit: true);
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
    String? password,
  }) async {
    state = state.copyWith(isLoading: true);
    final user = await _repository.updateProfile({
      'name': name,
      'email': email,
      'phoneNumber': phone,
      if (password != null) 'password': password,
    });
    if (user != null) {
      state = state.copyWith(user: user, isLoading: false);
      return true;
    }
    state = state.copyWith(isLoading: false);
    return false;
  }

  Future<bool> uploadProfilePhoto(String filePath) async {
    state = state.copyWith(isLoading: true);
    try {
      final photoUrl = await _repository.uploadProfilePhoto(filePath);
      if (photoUrl != null) {
        state = state.copyWith(
          user: state.user?.copyWith(profilePicUrl: photoUrl),
          isLoading: false,
        );
        return true;
      }
    } catch (e) {
      // Handle error
    }
    state = state.copyWith(isLoading: false);
    return false;
  }
}
