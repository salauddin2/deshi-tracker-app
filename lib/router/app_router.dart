import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/providers/auth_provider.dart';
import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/all_businesses_screen.dart';
import '../screens/business_dashboard_screen.dart';
import '../screens/business_detail_screen.dart';
import '../screens/member_profile_screen.dart';
import '../screens/leave_review_screen.dart';
import '../screens/business_form_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/reset_password_screen.dart';
import '../screens/registration_screen.dart';

import '../screens/owner_profile_screen.dart';
import '../screens/change_password_screen.dart';
import '../screens/my_business_screen.dart';
import '../screens/products_screen.dart';
import '../screens/day_offers_screen.dart';
import '../screens/order_management_screen.dart';
import '../screens/analytics_screen.dart';
import '../screens/member_verification_screen.dart';
import '../screens/staff_management_screen.dart';
import '../screens/staff_dashboard_screen.dart';
import '../screens/attendance_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/take_order_screen.dart';
import '../screens/order_detail_screen.dart';
import '../screens/staff_login_screen.dart';
import '../screens/staff_setup_screen.dart';
import '../screens/rota_screen.dart';
import '../screens/clock_in_out_screen.dart';
import '../screens/booking_screen.dart';
import '../screens/member_offers_screen.dart';
import '../screens/fridge_screen.dart';
import '../screens/admin_dashboard_screen.dart';
import '../screens/leads_screen.dart';
import '../screens/admin_businesses_screen.dart';
import '../screens/admin_users_screen.dart';
import '../screens/admin_categories_screen.dart';
import '../data/models/business.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final bool loggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/staff-login';
      final bool isAuth = authState.user != null;
      final role = authState.user?.role;

      // Redirect staff (using role string for now as it's from backend)
      if (isAuth && role == 'staff' && state.matchedLocation == '/business-dashboard') {
        return '/staff-dashboard';
      }

      // Restrict access to Business Dashboard for non-owners
      if (state.matchedLocation.startsWith('/owner/') && !isAuth) {
        return '/login';
      }

      // If logging in and already authenticated, redirect based on role
      if (loggingIn && isAuth) {
        if (role == 'staff') return '/staff-dashboard';
        if (role == 'business_owner') return '/business-dashboard';
        if (role == 'user') return '/member-profile';
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/all-businesses', builder: (context, state) => const AllBusinessesScreen()),

      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegistrationScreen()),
      GoRoute(path: '/forgot-password', builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(
        path: '/reset-password/:token',
        builder: (context, state) => ResetPasswordScreen(token: state.pathParameters['token']!),
      ),
      GoRoute(path: '/business-dashboard', builder: (context, state) => const BusinessDashboardScreen()),
      GoRoute(
        path: '/business/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final business = state.extra is Business ? state.extra as Business : null;
          return BusinessDetailScreen(businessId: id, business: business);
        },
      ),
      GoRoute(path: '/member-profile', builder: (context, state) => const MemberProfileScreen()),
      GoRoute(
        path: '/business/:id/review',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final extra = state.extra as Map<String, dynamic>?;
          return LeaveReviewScreen(
            businessId: id,
            businessName: extra?['businessName'] ?? 'Business',
          );
        },
      ),
      GoRoute(
        path: '/owner/edit-business',
        builder: (context, state) {
          final business = state.extra is Business ? state.extra as Business : null;
          return BusinessFormScreen(business: business);
        },
      ),
      GoRoute(path: '/owner/my-businesses', builder: (context, state) => const MyBusinessScreen()),
      GoRoute(path: '/owner/change-password', builder: (context, state) => const ChangePasswordScreen()),
      GoRoute(path: '/owner/profile', builder: (context, state) => const OwnerProfileScreen()),
      GoRoute(path: '/owner/products', builder: (context, state) => const ProductsScreen()),
      GoRoute(path: '/owner/offers', builder: (context, state) => const DayOffersScreen()),
      GoRoute(path: '/owner/orders', builder: (context, state) => const OrderManagementScreen()),
      GoRoute(path: '/owner/analytics', builder: (context, state) => const AnalyticsScreen()),
      GoRoute(path: '/owner/verify-member', builder: (context, state) => const MemberVerificationScreen()),
      GoRoute(path: '/owner/staff', builder: (context, state) => const StaffManagementScreen()),
      GoRoute(path: '/owner/attendance', builder: (context, state) => const AttendanceScreen()),
      GoRoute(path: '/owner/notifications', builder: (context, state) => const NotificationsScreen()),
      GoRoute(path: '/owner/take-order', builder: (context, state) => const TakeOrderScreen()),
      GoRoute(
        path: '/owner/order-detail/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return OrderDetailScreen(orderId: id);
        },
      ),
      GoRoute(path: '/staff-login', builder: (context, state) => const StaffLoginScreen()),
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/businesses',
        builder: (context, state) => const AdminBusinessesScreen(),
      ),
      GoRoute(
        path: '/admin/users',
        builder: (context, state) => const AdminUsersScreen(),
      ),
      GoRoute(
        path: '/admin/categories',
        builder: (context, state) => const AdminCategoriesScreen(),
      ),
      GoRoute(path: '/staff-dashboard', builder: (context, state) => const StaffDashboardScreen()),
      GoRoute(
        path: '/staff-setup/:token',
        builder: (context, state) => StaffSetupScreen(token: state.pathParameters['token']!),
      ),
      // ─── Phase 7-8: Rota & Attendance ──────────────────────────────────────
      GoRoute(path: '/owner/rota', builder: (context, state) => const RotaScreen()),
      GoRoute(path: '/staff/clock', builder: (context, state) => const ClockInOutScreen()),
      // ─── Phase 9: Member ────────────────────────────────────────────────────
      GoRoute(path: '/member/offers', builder: (context, state) => const MemberOffersScreen()),
      GoRoute(path: '/member/leads', builder: (context, state) => const LeadsScreen()),
      GoRoute(
        path: '/business/:id/book',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final name = (state.extra as Map<String, dynamic>?)?['businessName'] ?? 'Business';
          return BookingScreen(businessId: id, businessName: name);
        },
      ),
      // ─── Phase 12: Fridge ───────────────────────────────────────────────────
      GoRoute(path: '/owner/fridge', builder: (context, state) => const FridgeScreen()),
      GoRoute(
        path: '/owner/fridge/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final name = (state.extra as Map<String, dynamic>?)?['name'] ?? 'Fridge';
          return FridgeDetailScreen(fridgeId: id, fridgeName: name);
        },
      ),
      // ─── Phase 10: Admin ────────────────────────────────────────────────────
      GoRoute(path: '/admin', builder: (context, state) => const AdminDashboardScreen()),
    ],
  );
});
