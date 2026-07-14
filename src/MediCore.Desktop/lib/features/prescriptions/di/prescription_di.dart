import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../data/datasources/prescription_remote_data_source.dart';
import '../data/repositories/prescription_repository_impl.dart';
import '../domain/repositories/prescription_repository.dart';
import '../domain/use_cases/create_prescription_use_case.dart';
import '../domain/use_cases/get_patient_prescriptions_use_case.dart';

final prescriptionRemoteDataSourceProvider =
    Provider<PrescriptionRemoteDataSource>(
      (ref) => PrescriptionRemoteDataSourceImpl(ApiClient.instance),
    );

final prescriptionRepositoryProvider = Provider<PrescriptionRepository>(
  (ref) => PrescriptionRepositoryImpl(
    ref.read(prescriptionRemoteDataSourceProvider),
  ),
);

final createPrescriptionUseCaseProvider = Provider<CreatePrescriptionUseCase>(
  (ref) => CreatePrescriptionUseCase(ref.read(prescriptionRepositoryProvider)),
);

final getPatientPrescriptionsUseCaseProvider =
    Provider<GetPatientPrescriptionsUseCase>(
      (ref) => GetPatientPrescriptionsUseCase(
        ref.read(prescriptionRepositoryProvider),
      ),
    );
