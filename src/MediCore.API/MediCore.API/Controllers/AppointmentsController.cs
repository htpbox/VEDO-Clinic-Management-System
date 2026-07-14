using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using MediCore.Application.DTOs.Appointment;
using MediCore.Application.Interfaces.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MediCore.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class AppointmentsController : ControllerBase
{
    private readonly IAppointmentService _appointmentService;

    public AppointmentsController(IAppointmentService appointmentService)
    {
        _appointmentService = appointmentService;
    }

    [HttpGet("{id:guid}")]
    public async Task<IActionResult> GetById(Guid id)
    {
        var tenantId = GetTenantId();
        var result = await _appointmentService.GetByIdAsync(tenantId, id);
        return result.Success ? Ok(result) : NotFound(result);
    }

    [HttpGet("search")]
    public async Task<IActionResult> Search([FromQuery] DateOnly date, [FromQuery] Guid? doctorId)
    {
        var tenantId = GetTenantId();
        var result = await _appointmentService.SearchByDateAsync(tenantId, date, doctorId);
        return Ok(result);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateAppointmentDto dto)
    {
        var tenantId = GetTenantId();
        var branchId = GetBranchId();
        var userId = GetUserId();

        if (branchId == null)
            return BadRequest("لا يوجد فرع محدد لهذا المستخدم");

        var result = await _appointmentService.CreateAsync(tenantId, branchId.Value, userId, dto);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    [HttpPut("{id:guid}/cancel")]
    public async Task<IActionResult> Cancel(Guid id, [FromBody] CancelAppointmentDto dto)
    {
        var tenantId = GetTenantId();
        var result = await _appointmentService.CancelAsync(tenantId, id, dto);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    [HttpGet("queue")]
    public async Task<IActionResult> GetQueue([FromQuery] DateOnly date, [FromQuery] Guid? doctorId)
    {
        var tenantId = GetTenantId();
        var result = await _appointmentService.GetQueueAsync(tenantId, date, doctorId);
        return Ok(result);
    }

    [HttpPut("{id:guid}/checkin")]
    public async Task<IActionResult> CheckIn(Guid id)
    {
        var tenantId = GetTenantId();
        var result = await _appointmentService.CheckInAsync(tenantId, id);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    [HttpPut("{id:guid}/add-to-queue")]
    public async Task<IActionResult> AddToQueue(Guid id)
    {
        var tenantId = GetTenantId();
        var result = await _appointmentService.AddToQueueAsync(tenantId, id);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    [HttpPut("{id:guid}/call")]
    public async Task<IActionResult> CallPatient(Guid id)
    {
        var tenantId = GetTenantId();
        var result = await _appointmentService.CallPatientAsync(tenantId, id);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    [HttpPut("{id:guid}/complete")]
    public async Task<IActionResult> CompleteVisit(Guid id)
    {
        var tenantId = GetTenantId();
        var result = await _appointmentService.CompleteVisitAsync(tenantId, id);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    private Guid GetTenantId()
    {
        var value = User.FindFirst("tenant_id")?.Value;
        return Guid.Parse(value!);
    }

    private Guid? GetBranchId()
    {
        var value = User.FindFirst("branch_id")?.Value;
        return string.IsNullOrEmpty(value) ? null : Guid.Parse(value);
    }

    private Guid GetUserId()
    {
        var value = User.FindFirst(ClaimTypes.NameIdentifier)?.Value
            ?? User.FindFirst(JwtRegisteredClaimNames.Sub)?.Value;
        return Guid.Parse(value!);
    }
}