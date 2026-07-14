import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../data/datasources/encounter_remote_data_source.dart';
import '../data/repositories/encounter_repository_impl.dart';
import '../domain/repositories/encounter_repository.dart';
import '../domain/use_cases/get_patient_encounters_use_case.dart';
import '../domain/use_cases/create_encounter_use_case.dart';
import '../domain/use_cases/update_encounter_use_case.dart';
import '../domain/use_cases/close_encounter_use_case.dart';

final encounterRemoteDataSourceProvider = Provider<EncounterRemoteDataSource>(
  (ref) => EncounterRemoteDataSourceImpl(ApiClient.instance),
);

final encounterRepositoryProvider = Provider<EncounterRepository>(
  (ref) => EncounterRepositoryImpl(ref.read(encounterRemoteDataSourceProvider)),
);

final getPatientEncountersUseCaseProvider =
    Provider<GetPatientEncountersUseCase>(
      (ref) =>
          GetPatientEncountersUseCase(ref.read(encounterRepositoryProvider)),
    );

final createEncounterUseCaseProvider = Provider<CreateEncounterUseCase>(
  (ref) => CreateEncounterUseCase(ref.read(encounterRepositoryProvider)),
);

final updateEncounterUseCaseProvider = Provider<UpdateEncounterUseCase>(
  (ref) => UpdateEncounterUseCase(ref.read(encounterRepositoryProvider)),
);

final closeEncounterUseCaseProvider = Provider<CloseEncounterUseCase>(
  (ref) => CloseEncounterUseCase(ref.read(encounterRepositoryProvider)),
);
