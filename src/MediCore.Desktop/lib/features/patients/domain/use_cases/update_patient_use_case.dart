import '../entities/patient.dart';
import '../entities/update_patient_params.dart';
import '../repositories/patient_repository.dart';

class UpdatePatientUseCase {
  final PatientRepository repository;

  const UpdatePatientUseCase(this.repository);

  Future<Patient> execute(String id, UpdatePatientParams params) {
    return repository.update(id, params);
  }
}
