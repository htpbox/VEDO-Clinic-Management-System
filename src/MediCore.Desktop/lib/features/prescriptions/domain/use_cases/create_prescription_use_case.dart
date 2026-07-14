import '../entities/prescription.dart';
import '../entities/create_prescription_params.dart';
import '../repositories/prescription_repository.dart';

class CreatePrescriptionUseCase {
  final PrescriptionRepository repository;

  const CreatePrescriptionUseCase(this.repository);

  Future<Prescription> execute(CreatePrescriptionParams params) {
    return repository.create(params);
  }
}
