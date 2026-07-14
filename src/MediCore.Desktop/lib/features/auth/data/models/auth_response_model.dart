class AuthResponseModel {
  final String token;
  final String fullName;
  final String role;
  final String userId;
  final String tenantId;
  final String? branchId;
  final DateTime expiresAt;

  const AuthResponseModel({
    required this.token,
    required this.fullName,
    required this.role,
    required this.userId,
    required this.tenantId,
    this.branchId,
    required this.expiresAt,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'] as String,
      fullName: json['fullName'] as String,
      role: json['role'] as String,
      userId: json['userId'] as String,
      tenantId: json['tenantId'] as String,
      branchId: json['branchId'] as String?,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'fullName': fullName,
      'role': role,
      'userId': userId,
      'tenantId': tenantId,
      'branchId': branchId,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }
}
