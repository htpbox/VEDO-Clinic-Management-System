import '../entities/appointment.dart';
import '../entities/create_appointment_params.dart';
import '../repositories/appointment_repository.dart';

class CreateAppointmentUseCase {
  final AppointmentRepository repository;

  const CreateAppointmentUseCase(this.repository);

  Future<Appointment> execute(CreateAppointmentParams params) {
    return repository.create(params);
  }
}
