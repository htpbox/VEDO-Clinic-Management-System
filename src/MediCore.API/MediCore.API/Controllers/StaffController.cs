using MediCore.Application.DTOs.Staff;
using MediCore.Application.Interfaces.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MediCore.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class StaffController : ControllerBase
{
    private readonly IStaffService _staffService;

    public StaffController(IStaffService staffService)
    {
        _staffService = staffService;
    }

    [HttpGet("doctors")]
    public async Task<IActionResult> GetDoctors()
    {
        var tenantId = GetTenantId();
        var result = await _staffService.GetDoctorsAsync(tenantId);
        return Ok(result);
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var tenantId = GetTenantId();
        var result = await _staffService.GetAllStaffAsync(tenantId);
        return Ok(result);
    }

    [HttpPost]
    [Authorize(Roles = "SuperAdmin,ClinicAdmin")]
    public async Task<IActionResult> Create([FromBody] CreateStaffDto dto)
    {
        var tenantId = GetTenantId();
        var branchId = GetBranchId();
        var result = await _staffService.CreateAsync(tenantId, branchId, dto);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    [HttpPut("{id:guid}")]
    [Authorize(Roles = "SuperAdmin,ClinicAdmin")]
    public async Task<IActionResult> Update(Guid id, [FromBody] UpdateStaffDto dto)
    {
        var tenantId = GetTenantId();
        var result = await _staffService.UpdateAsync(tenantId, id, dto);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    [HttpPut("{id:guid}/deactivate")]
    [Authorize(Roles = "SuperAdmin,ClinicAdmin")]
    public async Task<IActionResult> Deactivate(Guid id)
    {
        var tenantId = GetTenantId();
        var result = await _staffService.DeactivateAsync(tenantId, id);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    [HttpPut("{id:guid}/activate")]
    [Authorize(Roles = "SuperAdmin,ClinicAdmin")]
    public async Task<IActionResult> Activate(Guid id)
    {
        var tenantId = GetTenantId();
        var result = await _staffService.ActivateAsync(tenantId, id);
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
}