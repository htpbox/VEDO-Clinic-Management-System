class UpdateTenantSettingsParams {
  final String name;
  final String? nameEn;
  final String? phone;
  final String? email;
  final String? address;
  final String? city;
  final String? governorate;
  final String? taxNumber;

  const UpdateTenantSettingsParams({
    required this.name,
    this.nameEn,
    this.phone,
    this.email,
    this.address,
    this.city,
    this.governorate,
    this.taxNumber,
  });
}
