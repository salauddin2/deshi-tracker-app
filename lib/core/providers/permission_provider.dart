import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/providers/auth_provider.dart';

final permissionProvider = Provider<PermissionManager>((ref) {
  final authState = ref.watch(authProvider);
  return PermissionManager(authState);
});

class PermissionManager {
  final AuthState authState;

  PermissionManager(this.authState);

  bool get isOwner => authState.user?.role == 'owner';
  bool get isManager => authState.user?.role == 'manager';
  bool get isStaff => authState.user?.role == 'staff' || isManager || isOwner;
  bool get isMember => authState.user?.role == 'member';

  // Specific Actions
  bool get canManageStaff => isOwner || isManager;
  bool get canEditBusiness => isOwner;
  bool get canTakeOrders => isStaff;
  bool get canViewAnalytics => isOwner || isManager;
  bool get canManageInventory => isStaff;
  
  // Rota/Attendance
  bool get canClockIn => isStaff;
  bool get canEditAttendance => isOwner || isManager;
}
