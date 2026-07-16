class TenantSettings {
  final String id;
  final String name;
  final String? nameEn;
  final String? logoUrl;
  final String? phone;
  final String? email;
  final String? address;
  final String? city;
  final String? governorate;
  final String? taxNumber;

  const TenantSettings({
    required this.id,
    required this.name,
    this.nameEn,
    this.logoUrl,
    this.phone,
    this.email,
    this.address,
    this.city,
    this.governorate,
    this.taxNumber,
  });
}
