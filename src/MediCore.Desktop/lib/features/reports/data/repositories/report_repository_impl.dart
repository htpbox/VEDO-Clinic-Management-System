import '../../domain/entities/dashboard_summary.dart';
import '../../domain/entities/revenue_point.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_remote_data_source.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource _remoteDataSource;

  const ReportRepositoryImpl(this._remoteDataSource);

  @override
  Future<DashboardSummary> getDashboardSummary(DateTime? date) async {
    final model = await _remoteDataSource.getDashboardSummary(date);
    return model.toEntity();
  }

  @override
  Future<List<RevenuePoint>> getRevenueSummary(
    DateTime? from,
    DateTime? to,
  ) async {
    final models = await _remoteDataSource.getRevenueSummary(from, to);
    return models.map((m) => m.toEntity()).toList();
  }
}
