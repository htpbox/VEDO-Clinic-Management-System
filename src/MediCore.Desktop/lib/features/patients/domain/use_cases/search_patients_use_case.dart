import '../entities/patient.dart';
import '../repositories/patient_repository.dart';

class SearchPatientsUseCase {
  final PatientRepository repository;

  const SearchPatientsUseCase(this.repository);

  Future<List<Patient>> execute(String searchTerm) {
    return repository.search(searchTerm);
  }
}
