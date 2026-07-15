using MediCore.Application.Common;
using MediCore.Application.DTOs.Reports;

namespace MediCore.Application.Interfaces.Services;

public interface IReportService
{
    Task<ApiResponse<DashboardSummaryDto>> GetDashboardSummaryAsync(Guid tenantId, DateOnly date);
    Task<ApiResponse<IEnumerable<RevenuePointDto>>> GetRevenueSummaryAsync(Guid tenantId, DateOnly from, DateOnly to);
}
