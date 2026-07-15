import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../di/report_di.dart';
import '../../domain/entities/revenue_point.dart';
import '../widgets/dashboard_summary_cards.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final revenueAsync = ref.watch(revenueSummaryProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'ملخص اليوم',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          summaryAsync.when(
            data: (summary) => DashboardSummaryCards(summary: summary),
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, _) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  'تعذر تحميل ملخص اليوم',
                  style: TextStyle(color: AppTheme.errorColor),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'الإيرادات خلال آخر 7 أيام',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          revenueAsync.when(
            data: (points) => _RevenueBarChart(points: points),
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, _) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  'تعذر تحميل بيانات الإيرادات',
                  style: TextStyle(color: AppTheme.errorColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A minimal bar chart built from plain widgets, deliberately avoiding a new
/// pub.dev dependency (this sandbox has no network access to pub.dev to
/// verify one resolves and builds correctly).
class _RevenueBarChart extends StatelessWidget {
  final List<RevenuePoint> points;

  const _RevenueBarChart({required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد بيانات إيرادات لهذه الفترة',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
      );
    }

    final maxRevenue = points
        .map((p) => p.totalRevenue)
        .fold<double>(0, (max, v) => v > max ? v : max);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 220,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final point in points)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          point.totalRevenue.toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: maxRevenue == 0
                              ? 4
                              : 8 + (point.totalRevenue / maxRevenue) * 140,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(6),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${point.date.day}/${point.date.month}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
