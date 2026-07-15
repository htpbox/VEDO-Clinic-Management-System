import '../entities/dashboard_summary.dart';
import '../entities/revenue_point.dart';

abstract class ReportRepository {
  Future<DashboardSummary> getDashboardSummary(DateTime? date);
  Future<List<RevenuePoint>> getRevenueSummary(DateTime? from, DateTime? to);
}
