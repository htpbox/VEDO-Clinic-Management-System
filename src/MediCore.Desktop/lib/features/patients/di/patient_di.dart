import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../data/datasources/patient_remote_data_source.dart';
import '../data/repositories/patient_repository_impl.dart';
import '../domain/repositories/patient_repository.dart';
import '../domain/use_cases/search_patients_use_case.dart';
import '../domain/use_cases/create_patient_use_case.dart';
import '../domain/use_cases/update_patient_use_case.dart';
import '../domain/use_cases/delete_patient_use_case.dart';

final patientRemoteDataSourceProvider = Provider<PatientRemoteDataSource>(
  (ref) => PatientRemoteDataSourceImpl(ApiClient.instance),
);

final patientRepositoryProvider = Provider<PatientRepository>(
  (ref) => PatientRepositoryImpl(ref.read(patientRemoteDataSourceProvider)),
);

final searchPatientsUseCaseProvider = Provider<SearchPatientsUseCase>(
  (ref) => SearchPatientsUseCase(ref.read(patientRepositoryProvider)),
);

final createPatientUseCaseProvider = Provider<CreatePatientUseCase>(
  (ref) => CreatePatientUseCase(ref.read(patientRepositoryProvider)),
);
final updatePatientUseCaseProvider = Provider<UpdatePatientUseCase>(
  (ref) => UpdatePatientUseCase(ref.read(patientRepositoryProvider)),
);
final deletePatientUseCaseProvider = Provider<DeletePatientUseCase>(
  (ref) => DeletePatientUseCase(ref.read(patientRepositoryProvider)),
);
