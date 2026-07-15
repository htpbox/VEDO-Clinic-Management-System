import '../../domain/entities/dashboard_summary.dart';

class DashboardSummaryModel extends DashboardSummary {
  const DashboardSummaryModel({
    required super.date,
    required super.totalRevenue,
    required super.paymentsCount,
    required super.newPatientsCount,
    required super.appointmentsCount,
    required super.completedAppointmentsCount,
    required super.cancelledAppointmentsCount,
    required super.noShowAppointmentsCount,
    required super.outstandingAmount,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      date: DateTime.parse(json['date'] as String),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      paymentsCount: json['paymentsCount'] as int,
      newPatientsCount: json['newPatientsCount'] as int,
      appointmentsCount: json['appointmentsCount'] as int,
      completedAppointmentsCount: json['completedAppointmentsCount'] as int,
      cancelledAppointmentsCount: json['cancelledAppointmentsCount'] as int,
      noShowAppointmentsCount: json['noShowAppointmentsCount'] as int,
      outstandingAmount: (json['outstandingAmount'] as num).toDouble(),
    );
  }

  DashboardSummary toEntity() => this;
}
