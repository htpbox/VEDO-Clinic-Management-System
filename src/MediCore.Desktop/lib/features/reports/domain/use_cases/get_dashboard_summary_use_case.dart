import '../entities/dashboard_summary.dart';
import '../repositories/report_repository.dart';

class GetDashboardSummaryUseCase {
  final ReportRepository repository;

  const GetDashboardSummaryUseCase(this.repository);

  Future<DashboardSummary> execute({DateTime? date}) {
    return repository.getDashboardSummary(date);
  }
}
