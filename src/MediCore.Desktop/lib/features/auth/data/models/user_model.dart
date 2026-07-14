import '../../domain/entities/authenticated_user.dart';
import '../../domain/enums/user_role.dart';

class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final String tenantId;
  final String? branchId;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.tenantId,
    this.branchId,
  });

  factory UserModel.fromFlatJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['userId'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      role: json['role'] as String,
      tenantId: json['tenantId'] as String,
      branchId: json['branchId'] as String?,
    );
  }

  AuthenticatedUser toEntity() {
    return AuthenticatedUser(
      id: id,
      email: email,
      fullName: fullName,
      role: UserRole.fromString(role),
      tenantId: tenantId,
      branchId: branchId,
    );
  }
}
