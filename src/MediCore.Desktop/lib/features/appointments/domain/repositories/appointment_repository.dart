import '../entities/appointment.dart';
import '../entities/queue_appointment.dart';
import '../entities/create_appointment_params.dart';

abstract class AppointmentRepository {
  Future<List<Appointment>> searchByDate(DateTime date, {String? doctorId});
  Future<Appointment> create(CreateAppointmentParams params);
  Future<Appointment> cancel(String id, String reason);
  Future<List<QueueAppointment>> getQueue(DateTime date, {String? doctorId});
  Future<void> checkIn(String appointmentId);
  Future<void> addToQueue(String appointmentId);
  Future<void> callPatient(String appointmentId);
  Future<void> completeVisit(String appointmentId);
}
