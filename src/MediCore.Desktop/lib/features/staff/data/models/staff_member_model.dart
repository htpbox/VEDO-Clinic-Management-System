import '../../domain/entities/staff_member.dart';

class StaffMemberModel extends StaffMember {
  const StaffMemberModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.phone,
    required super.role,
    required super.isActive,
  });

  factory StaffMemberModel.fromJson(Map<String, dynamic> json) {
    return StaffMemberModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      isActive: json['isActive'] as bool,
    );
  }

  StaffMember toEntity() => this;
}
