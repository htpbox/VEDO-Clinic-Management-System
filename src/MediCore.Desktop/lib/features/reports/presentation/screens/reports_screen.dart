import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../di/report_di.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/entities/revenue_point.dart';

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
            data: (summary) => _SummaryCards(summary: summary),
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

class _SummaryCards extends StatelessWidget {
  final DashboardSummary summary;

  const _SummaryCards({required this.summary});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _StatCardData(
        label: 'إيرادات اليوم',
        value: '${summary.totalRevenue.toStringAsFixed(2)} ج.م',
        icon: Icons.payments_outlined,
        color: AppTheme.secondaryColor,
      ),
      _StatCardData(
        label: 'مرضى جدد',
        value: '${summary.newPatientsCount}',
        icon: Icons.person_add_alt_outlined,
        color: AppTheme.primaryColor,
      ),
      _StatCardData(
        label: 'المواعيد',
        value:
            '${summary.appointmentsCount} (منجز ${summary.completedAppointmentsCount})',
        icon: Icons.event_available_outlined,
        color: AppTheme.primaryColor,
      ),
      _StatCardData(
        label: 'مبالغ مستحقة',
        value: '${summary.outstandingAmount.toStringAsFixed(2)} ج.م',
        icon: Icons.account_balance_wallet_outlined,
        color: AppTheme.warningColor,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900
            ? 4
            : (constraints.maxWidth > 560 ? 2 : 1);
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2.4,
          children: [for (final card in cards) _StatCard(data: card)],
        );
      },
    );
  }
}

class _StatCardData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCardData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class _StatCard extends StatelessWidget {
  final _StatCardData data;

  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: data.color.withValues(alpha: 0.12),
              child: Icon(data.icon, color: data.color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    data.value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    data.label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
