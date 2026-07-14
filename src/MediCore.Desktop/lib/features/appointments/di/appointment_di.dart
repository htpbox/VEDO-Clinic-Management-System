import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../data/datasources/appointment_remote_data_source.dart';
import '../data/repositories/appointment_repository_impl.dart';
import '../domain/repositories/appointment_repository.dart';
import '../domain/use_cases/search_appointments_use_case.dart';
import '../domain/use_cases/create_appointment_use_case.dart';
import '../domain/use_cases/cancel_appointment_use_case.dart';
import '../domain/use_cases/queue_actions_use_case.dart';

final appointmentRemoteDataSourceProvider =
    Provider<AppointmentRemoteDataSource>(
      (ref) => AppointmentRemoteDataSourceImpl(ApiClient.instance),
    );

final appointmentRepositoryProvider = Provider<AppointmentRepository>(
  (ref) =>
      AppointmentRepositoryImpl(ref.read(appointmentRemoteDataSourceProvider)),
);

final searchAppointmentsUseCaseProvider = Provider<SearchAppointmentsUseCase>(
  (ref) => SearchAppointmentsUseCase(ref.read(appointmentRepositoryProvider)),
);

final createAppointmentUseCaseProvider = Provider<CreateAppointmentUseCase>(
  (ref) => CreateAppointmentUseCase(ref.read(appointmentRepositoryProvider)),
);

final cancelAppointmentUseCaseProvider = Provider<CancelAppointmentUseCase>(
  (ref) => CancelAppointmentUseCase(ref.read(appointmentRepositoryProvider)),
);
final getQueueUseCaseProvider = Provider<GetQueueUseCase>(
  (ref) => GetQueueUseCase(ref.read(appointmentRepositoryProvider)),
);
final checkInUseCaseProvider = Provider<CheckInUseCase>(
  (ref) => CheckInUseCase(ref.read(appointmentRepositoryProvider)),
);
final addToQueueUseCaseProvider = Provider<AddToQueueUseCase>(
  (ref) => AddToQueueUseCase(ref.read(appointmentRepositoryProvider)),
);
final callPatientUseCaseProvider = Provider<CallPatientUseCase>(
  (ref) => CallPatientUseCase(ref.read(appointmentRepositoryProvider)),
);
final completeVisitUseCaseProvider = Provider<CompleteVisitUseCase>(
  (ref) => CompleteVisitUseCase(ref.read(appointmentRepositoryProvider)),
);
