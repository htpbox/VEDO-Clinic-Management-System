import '../entities/encounter.dart';
import '../entities/create_encounter_params.dart';
import '../entities/update_encounter_params.dart';

abstract class EncounterRepository {
  Future<Encounter> getById(String id);
  Future<List<Encounter>> getByPatient(String patientId);
  Future<Encounter> create(CreateEncounterParams params);
  Future<Encounter> update(String id, UpdateEncounterParams params);
  Future<Encounter> close(String id);
}
