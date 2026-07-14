class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime appointmentDate;
  final String startTime;
  final String endTime;
  final String status;
  final String? chiefComplaint;
  final String? notes;
  final String? cancellationReason;
  final DateTime createdAt;

  const Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.chiefComplaint,
    this.notes,
    this.cancellationReason,
    required this.createdAt,
  });
}