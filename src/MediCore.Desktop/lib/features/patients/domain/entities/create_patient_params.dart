class CreatePatientParams {
  final String fullName;
  final String gender;
  final DateTime? dateOfBirth;
  final String? nationalId;
  final String? phone;
  final String? phoneSecondary;
  final String? email;
  final String? address;
  final String? governorate;
  final String? bloodType;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? emergencyContactRelation;
  final String? insuranceCompany;
  final String? insuranceNumber;
  final DateTime? insuranceExpiry;
  final String? notes;

  const CreatePatientParams({
    required this.fullName,
    required this.gender,
    this.dateOfBirth,
    this.nationalId,
    this.phone,
    this.phoneSecondary,
    this.email,
    this.address,
    this.governorate,
    this.bloodType,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.emergencyContactRelation,
    this.insuranceCompany,
    this.insuranceNumber,
    this.insuranceExpiry,
    this.notes,
  });
}