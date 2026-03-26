import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/api_service.dart';
import '../data/services/auth_service.dart';
import '../data/services/notification_service.dart';
import '../data/services/print_service.dart';
import '../data/services/storage_service.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/business_repository.dart';
import '../data/repositories/product_repository.dart';
import '../data/repositories/notification_repository.dart';
import '../data/repositories/staff_repository.dart';
import '../data/repositories/order_repository.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/member_repository.dart';
import '../data/repositories/offer_repository.dart';
import '../data/repositories/rota_repository.dart';
import '../data/repositories/attendance_repository.dart';
import '../data/repositories/fridge_repository.dart';
import '../data/repositories/review_repository.dart';
import '../data/repositories/analytics_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/repositories/user_repository.dart';
import '../data/repositories/upload_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Core Services ────────────────────────────────────────────────────────────

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final apiServiceProvider = Provider<ApiService>((ref) {
  final authService = ref.watch(authServiceProvider);
  return ApiService(authService, ref);
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return NotificationService(repository);
});

final printServiceProvider = Provider<PrintService>((ref) => PrintService());

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return StorageService(prefs);
});

/// Convenience accessor: raw user map from auth state (nullable).
/// Screens use this for userId, role, etc.
final authStateProvider = Provider<Map<String, dynamic>?>((ref) => null);

// ─── Repositories ─────────────────────────────────────────────────────────────

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(apiServiceProvider), ref.watch(authServiceProvider));
});

final businessRepositoryProvider = Provider<BusinessRepository>((ref) {
  return BusinessRepository(ref.watch(apiServiceProvider));
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(ref.watch(apiServiceProvider));
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(ref.watch(apiServiceProvider));
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.watch(apiServiceProvider));
});

final staffRepositoryProvider = Provider<StaffRepository>((ref) {
  return StaffRepository(ref.watch(apiServiceProvider));
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(ref.watch(apiServiceProvider));
});

final memberRepositoryProvider = Provider<MemberRepository>((ref) {
  return MemberRepository(ref.watch(apiServiceProvider), ref.watch(authServiceProvider));
});

final offerRepositoryProvider = Provider<OfferRepository>((ref) {
  return OfferRepository(ref.watch(apiServiceProvider));
});

// ─── New Repositories (Phase 7–12) ────────────────────────────────────────────

final rotaRepositoryProvider = Provider<RotaRepository>((ref) {
  return RotaRepository(ref.watch(apiServiceProvider));
});

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return AttendanceRepository(ref.watch(apiServiceProvider));
});

final fridgeRepositoryProvider = Provider<FridgeRepository>((ref) {
  return FridgeRepository(ref.watch(apiServiceProvider));
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository(ref.watch(apiServiceProvider));
});

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository(ref.watch(apiServiceProvider));
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(apiServiceProvider));
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(apiServiceProvider));
});

final uploadRepositoryProvider = Provider<UploadRepository>((ref) {
  return UploadRepository(ref.watch(apiServiceProvider));
});
