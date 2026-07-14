import '../enums/user_role.dart';

class AuthenticatedUser {
  final String id;
  final String email;
  final String fullName;
  final UserRole role;
  final String tenantId;
  final String? branchId;

  const AuthenticatedUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.tenantId,
    this.branchId,
  });
}
