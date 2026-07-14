import '../entities/patient.dart';
import '../entities/create_patient_params.dart';
import '../repositories/patient_repository.dart';

class CreatePatientUseCase {
  final PatientRepository repository;

  const CreatePatientUseCase(this.repository);

  Future<Patient> execute(CreatePatientParams params) {
    return repository.create(params);
  }
}
