import '../entities/encounter.dart';
import '../repositories/encounter_repository.dart';

class GetPatientEncountersUseCase {
  final EncounterRepository repository;

  const GetPatientEncountersUseCase(this.repository);

  Future<List<Encounter>> execute(String patientId) {
    return repository.getByPatient(patientId);
  }
}
