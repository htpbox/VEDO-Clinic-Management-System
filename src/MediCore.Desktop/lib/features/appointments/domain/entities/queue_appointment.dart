class QueueAppointment {
  final String id;
  final String patientId;
  final String patientFullName;
  final String patientFileNumber;
  final String? patientPhone;
  final String doctorId;
  final String doctorFullName;
  final String startTime;
  final String endTime;
  final String status;
  final String? chiefComplaint;
  final DateTime? arrivedAt;
  final DateTime? startedAt;

  const QueueAppointment({
    required this.id,
    required this.patientId,
    required this.patientFullName,
    required this.patientFileNumber,
    this.patientPhone,
    required this.doctorId,
    required this.doctorFullName,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.chiefComplaint,
    this.arrivedAt,
    this.startedAt,
  });
}
