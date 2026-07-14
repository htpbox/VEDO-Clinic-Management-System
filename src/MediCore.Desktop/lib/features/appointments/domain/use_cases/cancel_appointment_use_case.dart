import '../entities/appointment.dart';
import '../repositories/appointment_repository.dart';

class CancelAppointmentUseCase {
  final AppointmentRepository repository;

  const CancelAppointmentUseCase(this.repository);

  Future<Appointment> execute(String id, String reason) {
    return repository.cancel(id, reason);
  }
}
