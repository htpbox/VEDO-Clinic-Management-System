class Encounter {
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

  const Encounter({
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
}