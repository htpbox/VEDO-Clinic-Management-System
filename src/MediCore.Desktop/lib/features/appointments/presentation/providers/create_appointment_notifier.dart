import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/appointment_di.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/entities/create_appointment_params.dart';

enum CreateAppointmentStatus { initial, loading, success, error }

class CreateAppointmentState {
  final CreateAppointmentStatus status;
  final String? errorMessage;

  const CreateAppointmentState({
    this.status = CreateAppointmentStatus.initial,
    this.errorMessage,
  });

  bool get isLoading => status == CreateAppointmentStatus.loading;
}

class CreateAppointmentNotifier extends StateNotifier<CreateAppointmentState> {
  final Ref _ref;

  CreateAppointmentNotifier(this._ref) : super(const CreateAppointmentState());

  Future<Appointment?> submit(CreateAppointmentParams params) async {
    state = const CreateAppointmentState(status: CreateAppointmentStatus.loading);
    try {
      final useCase = _ref.read(createAppointmentUseCaseProvider);
      final appointment = await useCase.execute(params);
      state = const CreateAppointmentState(status: CreateAppointmentStatus.success);
      return appointment;
    } catch (e) {
      state = CreateAppointmentState(
        status: CreateAppointmentStatus.error,
        errorMessage: e.toString(),
      );
      return null;
    }
  }
}

final createAppointmentNotifierProvider = StateNotifierProvider.autoDispose<CreateAppointmentNotifier, CreateAppointmentState>(
  (ref) => CreateAppointmentNotifier(ref),
);
