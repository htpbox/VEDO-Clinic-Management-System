import '../entities/prescription.dart';
import '../entities/create_prescription_params.dart';

abstract class PrescriptionRepository {
  Future<Prescription> getById(String id);
  Future<List<Prescription>> getByPatient(String patientId);
  Future<Prescription> create(CreatePrescriptionParams params);
}
