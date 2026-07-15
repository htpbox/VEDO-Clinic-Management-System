class DashboardSummary {
  final DateTime date;
  final double totalRevenue;
  final int paymentsCount;
  final int newPatientsCount;
  final int appointmentsCount;
  final int completedAppointmentsCount;
  final int cancelledAppointmentsCount;
  final int noShowAppointmentsCount;
  final double outstandingAmount;

  const DashboardSummary({
    required this.date,
    required this.totalRevenue,
    required this.paymentsCount,
    required this.newPatientsCount,
    required this.appointmentsCount,
    required this.completedAppointmentsCount,
    required this.cancelledAppointmentsCount,
    required this.noShowAppointmentsCount,
    required this.outstandingAmount,
  });
}
