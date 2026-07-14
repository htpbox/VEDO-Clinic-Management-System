import '../entities/encounter.dart';
import '../repositories/encounter_repository.dart';

class CloseEncounterUseCase {
  final EncounterRepository repository;

  const CloseEncounterUseCase(this.repository);

  Future<Encounter> execute(String id) {
    return repository.close(id);
  }
}
