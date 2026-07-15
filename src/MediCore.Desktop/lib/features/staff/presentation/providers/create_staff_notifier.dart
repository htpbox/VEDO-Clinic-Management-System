import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/staff_di.dart';
import '../../domain/entities/create_staff_params.dart';
import '../../domain/entities/staff_member.dart';

enum CreateStaffStatus { initial, loading, success, error }

class CreateStaffState {
  final CreateStaffStatus status;
  final String? errorMessage;

  const CreateStaffState({
    this.status = CreateStaffStatus.initial,
    this.errorMessage,
  });

  bool get isLoading => status == CreateStaffStatus.loading;
}

class CreateStaffNotifier extends StateNotifier<CreateStaffState> {
  final Ref _ref;

  CreateStaffNotifier(this._ref) : super(const CreateStaffState());

  Future<StaffMember?> submit(CreateStaffParams params) async {
    state = const CreateStaffState(status: CreateStaffStatus.loading);
    try {
      final useCase = _ref.read(createStaffUseCaseProvider);
      final staffMember = await useCase.execute(params);
      state = const CreateStaffState(status: CreateStaffStatus.success);
      return staffMember;
    } catch (e) {
      state = CreateStaffState(
        status: CreateStaffStatus.error,
        errorMessage: e.toString(),
      );
      return null;
    }
  }
}

final createStaffNotifierProvider =
    StateNotifierProvider.autoDispose<CreateStaffNotifier, CreateStaffState>(
      (ref) => CreateStaffNotifier(ref),
    );
