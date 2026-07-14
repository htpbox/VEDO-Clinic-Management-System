import '../../domain/entities/patient.dart';

class PatientModel {
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

  const PatientModel({
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

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'] as String,
      fileNumber: json['fileNumber'] as String,
      fullName: json['fullName'] as String,
      gender: json['gender'] as String,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      age: json['age'] as int?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      bloodType: json['bloodType'] as String?,
      insuranceCompany: json['insuranceCompany'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Patient toEntity() {
    return Patient(
      id: id,
      fileNumber: fileNumber,
      fullName: fullName,
      gender: gender,
      dateOfBirth: dateOfBirth,
      age: age,
      phone: phone,
      email: email,
      bloodType: bloodType,
      insuranceCompany: insuranceCompany,
      status: status,
      createdAt: createdAt,
    );
  }
}
