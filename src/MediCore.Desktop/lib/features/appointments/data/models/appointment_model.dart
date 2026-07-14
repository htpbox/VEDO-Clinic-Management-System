import '../../domain/entities/appointment.dart';

class AppointmentModel {
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

  const AppointmentModel({
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

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      doctorId: json['doctorId'] as String,
      appointmentDate: DateTime.parse(json['appointmentDate'] as String),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      status: json['status'] as String,
      chiefComplaint: json['chiefComplaint'] as String?,
      notes: json['notes'] as String?,
      cancellationReason: json['cancellationReason'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Appointment toEntity() {
    return Appointment(
      id: id,
      patientId: patientId,
      doctorId: doctorId,
      appointmentDate: appointmentDate,
      startTime: startTime,
      endTime: endTime,
      status: status,
      chiefComplaint: chiefComplaint,
      notes: notes,
      cancellationReason: cancellationReason,
      createdAt: createdAt,
    );
  }
}
