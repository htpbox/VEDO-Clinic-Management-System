using MediCore.Application.Interfaces.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MediCore.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class ReportsController : ControllerBase
{
    private readonly IReportService _reportService;

    public ReportsController(IReportService reportService)
    {
        _reportService = reportService;
    }

    [HttpGet("dashboard")]
    public async Task<IActionResult> GetDashboardSummary([FromQuery] DateOnly? date)
    {
        var tenantId = GetTenantId();
        var targetDate = date ?? DateOnly.FromDateTime(DateTime.UtcNow);
        var result = await _reportService.GetDashboardSummaryAsync(tenantId, targetDate);
        return Ok(result);
    }

    [HttpGet("revenue")]
    public async Task<IActionResult> GetRevenueSummary([FromQuery] DateOnly? from, [FromQuery] DateOnly? to)
    {
        var tenantId = GetTenantId();
        var rangeEnd = to ?? DateOnly.FromDateTime(DateTime.UtcNow);
        var rangeStart = from ?? rangeEnd.AddDays(-6);
        var result = await _reportService.GetRevenueSummaryAsync(tenantId, rangeStart, rangeEnd);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    private Guid GetTenantId()
    {
        var value = User.FindFirst("tenant_id")?.Value;
        return Guid.Parse(value!);
    }
}
