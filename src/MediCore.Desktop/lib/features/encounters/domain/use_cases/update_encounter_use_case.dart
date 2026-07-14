import '../entities/encounter.dart';
import '../entities/update_encounter_params.dart';
import '../repositories/encounter_repository.dart';

class UpdateEncounterUseCase {
  final EncounterRepository repository;

  const UpdateEncounterUseCase(this.repository);

  Future<Encounter> execute(String id, UpdateEncounterParams params) {
    return repository.update(id, params);
  }
}
