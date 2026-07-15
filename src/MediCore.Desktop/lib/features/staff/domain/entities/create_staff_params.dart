class CreateStaffParams {
  final String fullName;
  final String email;
  final String password;
  final String? phone;
  final String role;

  const CreateStaffParams({
    required this.fullName,
    required this.email,
    required this.password,
    this.phone,
    required this.role,
  });
}
