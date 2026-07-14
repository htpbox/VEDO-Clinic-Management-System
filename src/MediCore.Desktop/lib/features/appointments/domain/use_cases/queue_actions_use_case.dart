import '../entities/queue_appointment.dart';
import '../repositories/appointment_repository.dart';

class GetQueueUseCase {
  final AppointmentRepository repository;
  const GetQueueUseCase(this.repository);

  Future<List<QueueAppointment>> execute(DateTime date, {String? doctorId}) {
    return repository.getQueue(date, doctorId: doctorId);
  }
}

class CheckInUseCase {
  final AppointmentRepository repository;
  const CheckInUseCase(this.repository);
  Future<void> execute(String appointmentId) =>
      repository.checkIn(appointmentId);
}

class AddToQueueUseCase {
  final AppointmentRepository repository;
  const AddToQueueUseCase(this.repository);
  Future<void> execute(String appointmentId) =>
      repository.addToQueue(appointmentId);
}

class CallPatientUseCase {
  final AppointmentRepository repository;
  const CallPatientUseCase(this.repository);
  Future<void> execute(String appointmentId) =>
      repository.callPatient(appointmentId);
}

class CompleteVisitUseCase {
  final AppointmentRepository repository;
  const CompleteVisitUseCase(this.repository);
  Future<void> execute(String appointmentId) =>
      repository.completeVisit(appointmentId);
}
