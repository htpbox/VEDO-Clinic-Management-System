import '../entities/prescription.dart';
import '../repositories/prescription_repository.dart';

class GetPatientPrescriptionsUseCase {
  final PrescriptionRepository repository;

  const GetPatientPrescriptionsUseCase(this.repository);

  Future<List<Prescription>> execute(String patientId) {
    return repository.getByPatient(patientId);
  }
}
