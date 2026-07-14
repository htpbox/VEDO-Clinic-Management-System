import '../../domain/entities/queue_appointment.dart';

class QueueAppointmentModel {
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

  const QueueAppointmentModel({
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

  factory QueueAppointmentModel.fromJson(Map<String, dynamic> json) {
    return QueueAppointmentModel(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      patientFullName: json['patientFullName'] as String,
      patientFileNumber: json['patientFileNumber'] as String,
      patientPhone: json['patientPhone'] as String?,
      doctorId: json['doctorId'] as String,
      doctorFullName: json['doctorFullName'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      status: json['status'] as String,
      chiefComplaint: json['chiefComplaint'] as String?,
      arrivedAt: json['arrivedAt'] != null
          ? DateTime.parse(json['arrivedAt'] as String)
          : null,
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'] as String)
          : null,
    );
  }

  QueueAppointment toEntity() {
    return QueueAppointment(
      id: id,
      patientId: patientId,
      patientFullName: patientFullName,
      patientFileNumber: patientFileNumber,
      patientPhone: patientPhone,
      doctorId: doctorId,
      doctorFullName: doctorFullName,
      startTime: startTime,
      endTime: endTime,
      status: status,
      chiefComplaint: chiefComplaint,
      arrivedAt: arrivedAt,
      startedAt: startedAt,
    );
  }
}
