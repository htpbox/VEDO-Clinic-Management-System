import '../../domain/entities/tenant_settings.dart';

class TenantSettingsModel extends TenantSettings {
  const TenantSettingsModel({
    required super.id,
    required super.name,
    super.nameEn,
    super.logoUrl,
    super.phone,
    super.email,
    super.address,
    super.city,
    super.governorate,
    super.taxNumber,
  });

  factory TenantSettingsModel.fromJson(Map<String, dynamic> json) {
    return TenantSettingsModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nameEn: json['nameEn'] as String?,
      logoUrl: json['logoUrl'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      governorate: json['governorate'] as String?,
      taxNumber: json['taxNumber'] as String?,
    );
  }

  TenantSettings toEntity() => this;
}
