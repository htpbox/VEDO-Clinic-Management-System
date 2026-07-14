import '../repositories/patient_repository.dart';

class DeletePatientUseCase {
  final PatientRepository repository;

  const DeletePatientUseCase(this.repository);

  Future<void> execute(String id) {
    return repository.delete(id);
  }
}
