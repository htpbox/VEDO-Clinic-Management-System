import '../../domain/entities/patient.dart';
import '../../domain/entities/create_patient_params.dart';
import '../../domain/entities/update_patient_params.dart';
import '../../domain/repositories/patient_repository.dart';
import '../datasources/patient_remote_data_source.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource _remoteDataSource;

  const PatientRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Patient>> search(String searchTerm) async {
    final models = await _remoteDataSource.search(searchTerm);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Patient> getById(String id) async {
    final model = await _remoteDataSource.getById(id);
    return model.toEntity();
  }

  @override
  Future<Patient> create(CreatePatientParams params) async {
    final model = await _remoteDataSource.create(params);
    return model.toEntity();
  }

  @override
  Future<void> delete(String id) async {
    await _remoteDataSource.delete(id);
  }

  @override
  Future<Patient> update(String id, UpdatePatientParams params) async {
    final model = await _remoteDataSource.update(id, params);
    return model.toEntity();
  }
}
