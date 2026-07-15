import '../../../../core/api/api_client.dart';
import '../../../../core/network/api_response_envelope.dart';
import '../models/dashboard_summary_model.dart';
import '../models/revenue_point_model.dart';

abstract class ReportRemoteDataSource {
  Future<DashboardSummaryModel> getDashboardSummary(DateTime? date);
  Future<List<RevenuePointModel>> getRevenueSummary(
    DateTime? from,
    DateTime? to,
  );
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final ApiClient _apiClient;

  const ReportRemoteDataSourceImpl(this._apiClient);

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Future<DashboardSummaryModel> getDashboardSummary(DateTime? date) async {
    final params = <String, dynamic>{};
    if (date != null) params['date'] = _formatDate(date);

    final response = await _apiClient.get(
      '/reports/dashboard',
      params: params,
    );

    final envelope = ApiResponseEnvelope<DashboardSummaryModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => DashboardSummaryModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data!;
  }

  @override
  Future<List<RevenuePointModel>> getRevenueSummary(
    DateTime? from,
    DateTime? to,
  ) async {
    final params = <String, dynamic>{};
    if (from != null) params['from'] = _formatDate(from);
    if (to != null) params['to'] = _formatDate(to);

    final response = await _apiClient.get('/reports/revenue', params: params);

    final envelope = ApiResponseEnvelope<List<RevenuePointModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((e) => RevenuePointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    return envelope.data ?? [];
  }
}
