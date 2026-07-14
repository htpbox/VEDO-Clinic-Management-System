import '../../domain/entities/encounter.dart';

class EncounterModel {
  final String id;
  final String patientId;
  final String doctorId;
  final String? appointmentId;
  final String encounterType;
  final String status;
  final String? chiefComplaint;
  final String? hpi;
  final String? physicalExam;
  final String? clinicalNotes;
  final String? treatmentPlan;
  final DateTime? followUpDate;
  final String? followUpNotes;
  final bool isLocked;
  final DateTime createdAt;

  const EncounterModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    this.appointmentId,
    required this.encounterType,
    required this.status,
    this.chiefComplaint,
    this.hpi,
    this.physicalExam,
    this.clinicalNotes,
    this.treatmentPlan,
    this.followUpDate,
    this.followUpNotes,
    required this.isLocked,
    required this.createdAt,
  });

  factory EncounterModel.fromJson(Map<String, dynamic> json) {
    return EncounterModel(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      doctorId: json['doctorId'] as String,
      appointmentId: json['appointmentId'] as String?,
      encounterType: json['encounterType'] as String,
      status: json['status'] as String,
      chiefComplaint: json['chiefComplaint'] as String?,
      hpi: json['hpi'] as String?,
      physicalExam: json['physicalExam'] as String?,
      clinicalNotes: json['clinicalNotes'] as String?,
      treatmentPlan: json['treatmentPlan'] as String?,
      followUpDate: json['followUpDate'] != null
          ? DateTime.parse(json['followUpDate'] as String)
          : null,
      followUpNotes: json['followUpNotes'] as String?,
      isLocked: json['isLocked'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Encounter toEntity() {
    return Encounter(
      id: id,
      patientId: patientId,
      doctorId: doctorId,
      appointmentId: appointmentId,
      encounterType: encounterType,
      status: status,
      chiefComplaint: chiefComplaint,
      hpi: hpi,
      physicalExam: physicalExam,
      clinicalNotes: clinicalNotes,
      treatmentPlan: treatmentPlan,
      followUpDate: followUpDate,
      followUpNotes: followUpNotes,
      isLocked: isLocked,
      createdAt: createdAt,
    );
  }
}
