import '../../domain/entities/appointment.dart';
import '../../domain/entities/queue_appointment.dart';
import '../../domain/entities/create_appointment_params.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../datasources/appointment_remote_data_source.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDataSource _remoteDataSource;

  const AppointmentRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Appointment>> searchByDate(
    DateTime date, {
    String? doctorId,
  }) async {
    final models = await _remoteDataSource.searchByDate(
      date,
      doctorId: doctorId,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Appointment> create(CreateAppointmentParams params) async {
    final model = await _remoteDataSource.create(params);
    return model.toEntity();
  }

  @override
  Future<Appointment> cancel(String id, String reason) async {
    final model = await _remoteDataSource.cancel(id, reason);
    return model.toEntity();
  }

  @override
  Future<List<QueueAppointment>> getQueue(
    DateTime date, {
    String? doctorId,
  }) async {
    final models = await _remoteDataSource.getQueue(date, doctorId: doctorId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> checkIn(String appointmentId) =>
      _remoteDataSource.checkIn(appointmentId);

  @override
  Future<void> addToQueue(String appointmentId) =>
      _remoteDataSource.addToQueue(appointmentId);

  @override
  Future<void> callPatient(String appointmentId) =>
      _remoteDataSource.callPatient(appointmentId);

  @override
  Future<void> completeVisit(String appointmentId) =>
      _remoteDataSource.completeVisit(appointmentId);
}
