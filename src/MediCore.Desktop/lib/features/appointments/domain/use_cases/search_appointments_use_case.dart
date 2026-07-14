import '../entities/appointment.dart';
import '../repositories/appointment_repository.dart';

class SearchAppointmentsUseCase {
  final AppointmentRepository repository;

  const SearchAppointmentsUseCase(this.repository);

  Future<List<Appointment>> execute(DateTime date, {String? doctorId}) {
    return repository.searchByDate(date, doctorId: doctorId);
  }
}
