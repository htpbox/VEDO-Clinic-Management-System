namespace MediCore.Application.DTOs.Reports;

public class DashboardSummaryDto
{
    public DateOnly Date { get; set; }
    public decimal TotalRevenue { get; set; }
    public int PaymentsCount { get; set; }
    public int NewPatientsCount { get; set; }
    public int AppointmentsCount { get; set; }
    public int CompletedAppointmentsCount { get; set; }
    public int CancelledAppointmentsCount { get; set; }
    public int NoShowAppointmentsCount { get; set; }
    public decimal OutstandingAmount { get; set; }
}
