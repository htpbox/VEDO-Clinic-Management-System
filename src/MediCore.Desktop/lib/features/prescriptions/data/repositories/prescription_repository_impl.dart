import '../../domain/entities/prescription.dart';
import '../../domain/entities/create_prescription_params.dart';
import '../../domain/repositories/prescription_repository.dart';
import '../datasources/prescription_remote_data_source.dart';

class PrescriptionRepositoryImpl implements PrescriptionRepository {
  final PrescriptionRemoteDataSource _remoteDataSource;

  const PrescriptionRepositoryImpl(this._remoteDataSource);

  @override
  Future<Prescription> getById(String id) async {
    final model = await _remoteDataSource.getById(id);
    return model.toEntity();
  }

  @override
  Future<List<Prescription>> getByPatient(String patientId) async {
    final models = await _remoteDataSource.getByPatient(patientId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Prescription> create(CreatePrescriptionParams params) async {
    final model = await _remoteDataSource.create(params);
    return model.toEntity();
  }
}
