using MediCore.Application.Common;
using MediCore.Application.DTOs.Reports;
using MediCore.Application.Interfaces;
using MediCore.Application.Interfaces.Services;
using MediCore.Domain.Enums;

namespace MediCore.Application.Services;

public class ReportService : IReportService
{
    private readonly IUnitOfWork _unitOfWork;

    public ReportService(IUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }

    public async Task<ApiResponse<DashboardSummaryDto>> GetDashboardSummaryAsync(Guid tenantId, DateOnly date)
    {
        var dayStart = date.ToDateTime(TimeOnly.MinValue);
        var dayEnd = date.ToDateTime(TimeOnly.MaxValue);

        var payments = await _unitOfWork.Payments.FindAsync(p =>
            p.TenantId == tenantId && p.PaymentDate >= dayStart && p.PaymentDate <= dayEnd);

        var newPatients = await _unitOfWork.Patients.FindAsync(p =>
            p.TenantId == tenantId && p.CreatedAt >= dayStart && p.CreatedAt <= dayEnd);

        var appointments = await _unitOfWork.Appointments.FindAsync(a =>
            a.TenantId == tenantId && a.AppointmentDate == date);

        var outstandingInvoices = await _unitOfWork.Invoices.FindAsync(i =>
            i.TenantId == tenantId &&
            (i.Status == InvoiceStatus.Issued || i.Status == InvoiceStatus.PartiallyPaid));

        var paymentsList = payments.ToList();
        var appointmentsList = appointments.ToList();

        var summary = new DashboardSummaryDto
        {
            Date = date,
            TotalRevenue = paymentsList.Sum(p => p.Amount),
            PaymentsCount = paymentsList.Count,
            NewPatientsCount = newPatients.Count(),
            AppointmentsCount = appointmentsList.Count,
            CompletedAppointmentsCount = appointmentsList.Count(a => a.Status == AppointmentStatus.Done),
            CancelledAppointmentsCount = appointmentsList.Count(a => a.Status == AppointmentStatus.Cancelled),
            NoShowAppointmentsCount = appointmentsList.Count(a => a.Status == AppointmentStatus.NoShow),
            OutstandingAmount = outstandingInvoices.Sum(i => i.RemainingAmount),
        };

        return ApiResponse<DashboardSummaryDto>.Ok(summary);
    }

    public async Task<ApiResponse<IEnumerable<RevenuePointDto>>> GetRevenueSummaryAsync(Guid tenantId, DateOnly from, DateOnly to)
    {
        if (to < from)
            return ApiResponse<IEnumerable<RevenuePointDto>>.Fail("تاريخ النهاية يجب أن يكون بعد تاريخ البداية");

        var rangeStart = from.ToDateTime(TimeOnly.MinValue);
        var rangeEnd = to.ToDateTime(TimeOnly.MaxValue);

        var payments = await _unitOfWork.Payments.FindAsync(p =>
            p.TenantId == tenantId && p.PaymentDate >= rangeStart && p.PaymentDate <= rangeEnd);

        var paymentsByDay = payments
            .GroupBy(p => DateOnly.FromDateTime(p.PaymentDate))
            .ToDictionary(g => g.Key, g => g.Sum(p => p.Amount));

        var points = new List<RevenuePointDto>();
        for (var day = from; day <= to; day = day.AddDays(1))
        {
            points.Add(new RevenuePointDto
            {
                Date = day,
                TotalRevenue = paymentsByDay.TryGetValue(day, out var total) ? total : 0m,
            });
        }

        return ApiResponse<IEnumerable<RevenuePointDto>>.Ok(points);
    }
}
