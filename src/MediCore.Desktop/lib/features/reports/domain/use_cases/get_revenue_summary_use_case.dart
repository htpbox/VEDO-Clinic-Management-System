import '../entities/revenue_point.dart';
import '../repositories/report_repository.dart';

class GetRevenueSummaryUseCase {
  final ReportRepository repository;

  const GetRevenueSummaryUseCase(this.repository);

  Future<List<RevenuePoint>> execute({DateTime? from, DateTime? to}) {
    return repository.getRevenueSummary(from, to);
  }
}
