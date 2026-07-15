import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../../reports/di/report_di.dart';
import '../../../reports/presentation/widgets/dashboard_summary_cards.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final user = ref.watch(authNotifierProvider).user;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            user != null ? 'أهلاً بك، ${user.fullName}' : 'أهلاً بك',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'إليك ملخص أداء العيادة اليوم',
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 24),
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
            'وصول سريع',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _QuickLinks(),
        ],
      ),
    );
  }
}

class _QuickLinkData {
  final String label;
  final IconData icon;
  final String route;

  const _QuickLinkData({
    required this.label,
    required this.icon,
    required this.route,
  });
}

class _QuickLinks extends StatelessWidget {
  _QuickLinks();

  final List<_QuickLinkData> _links = const [
    _QuickLinkData(
      label: 'المرضى',
      icon: Icons.people_alt_outlined,
      route: AppConstants.patientsRoute,
    ),
    _QuickLinkData(
      label: 'قائمة الانتظار',
      icon: Icons.hourglass_empty_outlined,
      route: AppConstants.queueRoute,
    ),
    _QuickLinkData(
      label: 'المواعيد',
      icon: Icons.event_outlined,
      route: AppConstants.appointmentsRoute,
    ),
    _QuickLinkData(
      label: 'الموظفون',
      icon: Icons.badge_outlined,
      route: AppConstants.staffRoute,
    ),
    _QuickLinkData(
      label: 'التقارير',
      icon: Icons.bar_chart_outlined,
      route: AppConstants.reportsRoute,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900
            ? 5
            : (constraints.maxWidth > 560 ? 3 : 2);
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.3,
          children: [
            for (final link in _links)
              _QuickLinkCard(
                data: link,
                onTap: () => context.go(link.route),
              ),
          ],
        );
      },
    );
  }
}

class _QuickLinkCard extends StatelessWidget {
  final _QuickLinkData data;
  final VoidCallback onTap;

  const _QuickLinkCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(data.icon, color: AppTheme.primaryColor, size: 28),
              const SizedBox(height: 8),
              Text(
                data.label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
