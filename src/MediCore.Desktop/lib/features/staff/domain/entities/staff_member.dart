class StaffMember {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String role;
  final bool isActive;

  const StaffMember({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    required this.role,
    required this.isActive,
  });
}