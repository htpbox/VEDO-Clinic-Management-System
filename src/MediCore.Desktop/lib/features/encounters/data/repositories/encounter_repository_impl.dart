import '../../domain/entities/encounter.dart';
import '../../domain/entities/create_encounter_params.dart';
import '../../domain/entities/update_encounter_params.dart';
import '../../domain/repositories/encounter_repository.dart';
import '../datasources/encounter_remote_data_source.dart';

class EncounterRepositoryImpl implements EncounterRepository {
  final EncounterRemoteDataSource _remoteDataSource;

  const EncounterRepositoryImpl(this._remoteDataSource);

  @override
  Future<Encounter> getById(String id) async {
    final model = await _remoteDataSource.getById(id);
    return model.toEntity();
  }

  @override
  Future<List<Encounter>> getByPatient(String patientId) async {
    final models = await _remoteDataSource.getByPatient(patientId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Encounter> create(CreateEncounterParams params) async {
    final model = await _remoteDataSource.create(params);
    return model.toEntity();
  }

  @override
  Future<Encounter> update(String id, UpdateEncounterParams params) async {
    final model = await _remoteDataSource.update(id, params);
    return model.toEntity();
  }

  @override
  Future<Encounter> close(String id) async {
    final model = await _remoteDataSource.close(id);
    return model.toEntity();
  }
}
