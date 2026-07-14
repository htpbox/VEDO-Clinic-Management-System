import '../entities/encounter.dart';
import '../entities/create_encounter_params.dart';
import '../repositories/encounter_repository.dart';

class CreateEncounterUseCase {
  final EncounterRepository repository;

  const CreateEncounterUseCase(this.repository);

  Future<Encounter> execute(CreateEncounterParams params) {
    return repository.create(params);
  }
}
