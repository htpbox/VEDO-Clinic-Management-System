import '../../../../core/api/api_client.dart';
import '../../../../core/network/api_response_envelope.dart';
import '../../domain/entities/create_appointment_params.dart';
import '../models/appointment_model.dart';
import '../models/queue_appointment_model.dart';

abstract class AppointmentRemoteDataSource {
  Future<List<AppointmentModel>> searchByDate(
    DateTime date, {
    String? doctorId,
  });
  Future<AppointmentModel> create(CreateAppointmentParams params);
  Future<AppointmentModel> cancel(String id, String reason);
  Future<List<QueueAppointmentModel>> getQueue(
    DateTime date, {
    String? doctorId,
  });
  Future<void> checkIn(String appointmentId);
  Future<void> addToQueue(String appointmentId);
  Future<void> callPatient(String appointmentId);
  Future<void> completeVisit(String appointmentId);
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final ApiClient _apiClient;

  const AppointmentRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<AppointmentModel>> searchByDate(
    DateTime date, {
    String? doctorId,
  }) async {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final params = <String, dynamic>{'date': dateStr};
    if (doctorId != null) params['doctorId'] = doctorId;

    final response = await _apiClient.get(
      '/appointments/search',
      params: params,
    );

    final envelope = ApiResponseEnvelope<List<AppointmentModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    return envelope.data ?? [];
  }

  @override
  Future<AppointmentModel> create(CreateAppointmentParams params) async {
    final response = await _apiClient.post(
      '/appointments',
      data: {
        'patientId': params.patientId,
        'doctorId': params.doctorId,
        'appointmentDate':
            '${params.appointmentDate.year}-${params.appointmentDate.month.toString().padLeft(2, '0')}-${params.appointmentDate.day.toString().padLeft(2, '0')}',
        'startTime': params.startTime,
        'endTime': params.endTime,
        'chiefComplaint': params.chiefComplaint,
        'notes': params.notes,
      },
    );

    final envelope = ApiResponseEnvelope<AppointmentModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => AppointmentModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data!;
  }

  @override
  Future<AppointmentModel> cancel(String id, String reason) async {
    final response = await _apiClient.put(
      '/appointments/$id/cancel',
      data: {'cancellationReason': reason},
    );

    final envelope = ApiResponseEnvelope<AppointmentModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => AppointmentModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data!;
  }

  @override
  Future<List<QueueAppointmentModel>> getQueue(
    DateTime date, {
    String? doctorId,
  }) async {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final params = <String, dynamic>{'date': dateStr};
    if (doctorId != null) params['doctorId'] = doctorId;

    final response = await _apiClient.get(
      '/appointments/queue',
      params: params,
    );

    final envelope = ApiResponseEnvelope<List<QueueAppointmentModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((e) => QueueAppointmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    return envelope.data ?? [];
  }

  @override
  Future<void> checkIn(String appointmentId) async {
    await _apiClient.put('/appointments/$appointmentId/checkin');
  }

  @override
  Future<void> addToQueue(String appointmentId) async {
    await _apiClient.put('/appointments/$appointmentId/add-to-queue');
  }

  @override
  Future<void> callPatient(String appointmentId) async {
    await _apiClient.put('/appointments/$appointmentId/call');
  }

  @override
  Future<void> completeVisit(String appointmentId) async {
    await _apiClient.put('/appointments/$appointmentId/complete');
  }
}
