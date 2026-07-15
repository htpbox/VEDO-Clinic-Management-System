import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../data/datasources/report_remote_data_source.dart';
import '../data/repositories/report_repository_impl.dart';
import '../domain/entities/dashboard_summary.dart';
import '../domain/entities/revenue_point.dart';
import '../domain/repositories/report_repository.dart';
import '../domain/use_cases/get_dashboard_summary_use_case.dart';
import '../domain/use_cases/get_revenue_summary_use_case.dart';

final reportRemoteDataSourceProvider = Provider<ReportRemoteDataSource>(
  (ref) => ReportRemoteDataSourceImpl(ApiClient.instance),
);

final reportRepositoryProvider = Provider<ReportRepository>(
  (ref) => ReportRepositoryImpl(ref.read(reportRemoteDataSourceProvider)),
);

final getDashboardSummaryUseCaseProvider =
    Provider<GetDashboardSummaryUseCase>(
      (ref) => GetDashboardSummaryUseCase(ref.read(reportRepositoryProvider)),
    );

final getRevenueSummaryUseCaseProvider = Provider<GetRevenueSummaryUseCase>(
  (ref) => GetRevenueSummaryUseCase(ref.read(reportRepositoryProvider)),
);

/// Today's dashboard summary (revenue, patients, appointments, outstanding balance).
final dashboardSummaryProvider = FutureProvider<DashboardSummary>((ref) async {
  final useCase = ref.read(getDashboardSummaryUseCaseProvider);
  return useCase.execute();
});

/// Revenue for the last 7 days (default range), used for the bar chart.
final revenueSummaryProvider = FutureProvider<List<RevenuePoint>>((ref) async {
  final useCase = ref.read(getRevenueSummaryUseCaseProvider);
  return useCase.execute();
});
