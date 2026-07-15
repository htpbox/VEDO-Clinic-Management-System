class UpdateStaffParams {
  final String fullName;
  final String? phone;
  final String role;

  const UpdateStaffParams({
    required this.fullName,
    this.phone,
    required this.role,
  });
}
