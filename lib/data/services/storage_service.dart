import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static const _appModeKey = 'app_mode';
  static const _localeKey = 'selected_locale';
  static const _onboardingCompleteKey = 'onboarding_complete';
  static const _rememberMeKey = 'remember_me';
  static const _savedEmailKey = 'saved_email';

  // Onboarding
  Future<void> setOnboardingComplete(bool value) async {
    await _prefs.setBool(_onboardingCompleteKey, value);
  }

  bool isOnboardingComplete() {
    return _prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  // App Mode (owner/member)
  Future<void> setAppMode(String mode) async {
    await _prefs.setString(_appModeKey, mode);
  }

  String getAppMode() {
    return _prefs.getString(_appModeKey) ?? 'owner';
  }

  // Remember Me
  Future<void> setRememberMe(bool value) async {
    await _prefs.setBool(_rememberMeKey, value);
  }

  bool isRememberMe() {
    return _prefs.getBool(_rememberMeKey) ?? true;
  }

  // Saved Email
  Future<void> setSavedEmail(String email) async {
    await _prefs.setString(_savedEmailKey, email);
  }

  String? getSavedEmail() {
    return _prefs.getString(_savedEmailKey);
  }

  // Locale
  Future<void> setLocale(String languageCode) async {
    await _prefs.setString(_localeKey, languageCode);
  }

  String getLocale() {
    return _prefs.getString(_localeKey) ?? 'en';
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
