import '../entities/patient.dart';
import '../entities/create_patient_params.dart';
import '../entities/update_patient_params.dart';

abstract class PatientRepository {
  Future<List<Patient>> search(String searchTerm);
  Future<Patient> getById(String id);
  Future<Patient> create(CreatePatientParams params);
  Future<Patient> update(String id, UpdatePatientParams params);
  Future<void> delete(String id);
}
