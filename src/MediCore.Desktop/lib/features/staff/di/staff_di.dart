import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../data/datasources/staff_remote_data_source.dart';
import '../data/repositories/staff_repository_impl.dart';
import '../domain/entities/staff_member.dart';
import '../domain/repositories/staff_repository.dart';
import '../domain/use_cases/get_doctors_use_case.dart';

final staffRemoteDataSourceProvider = Provider<StaffRemoteDataSource>(
  (ref) => StaffRemoteDataSourceImpl(ApiClient.instance),
);

final staffRepositoryProvider = Provider<StaffRepository>(
  (ref) => StaffRepositoryImpl(ref.read(staffRemoteDataSourceProvider)),
);

final getDoctorsUseCaseProvider = Provider<GetDoctorsUseCase>(
  (ref) => GetDoctorsUseCase(ref.read(staffRepositoryProvider)),
);

/// Doctors list — loaded once, cached for the app session (fits VEDO
/// philosophy: a reference list read constantly by Appointments/Encounters
/// should not require re-fetching or extra taps).
final doctorsListProvider = FutureProvider<List<StaffMember>>((ref) async {
  final useCase = ref.read(getDoctorsUseCaseProvider);
  return useCase.execute();
});

/// Smart Default: remembers the last doctor selected in this app session,
/// so the next booking pre-fills automatically instead of asking again.
final lastSelectedDoctorProvider = StateProvider<String?>((ref) => null);
