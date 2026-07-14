class Patient {
  final String id;
  final String fileNumber;
  final String fullName;
  final String gender;
  final DateTime? dateOfBirth;
  final int? age;
  final String? phone;
  final String? email;
  final String? bloodType;
  final String? insuranceCompany;
  final String status;
  final DateTime createdAt;

  const Patient({
    required this.id,
    required this.fileNumber,
    required this.fullName,
    required this.gender,
    this.dateOfBirth,
    this.age,
    this.phone,
    this.email,
    this.bloodType,
    this.insuranceCompany,
    required this.status,
    required this.createdAt,
  });
}