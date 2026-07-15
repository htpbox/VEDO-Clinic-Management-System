import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/dashboard_summary.dart';

/// Today's key metrics as a responsive grid of cards. Shared between the
/// home Dashboard and the Reports screen so both stay in sync with a single
/// implementation.
class DashboardSummaryCards extends StatelessWidget {
  final DashboardSummary summary;

  const DashboardSummaryCards({super.key, required this.summary});

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
