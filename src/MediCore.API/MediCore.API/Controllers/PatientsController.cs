using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using MediCore.Application.DTOs.Patient;
using MediCore.Application.Interfaces.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MediCore.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class PatientsController : ControllerBase
{
    private readonly IPatientService _patientService;

    public PatientsController(IPatientService patientService)
    {
        _patientService = patientService;
    }

    [HttpGet("{id:guid}")]
    public async Task<IActionResult> GetById(Guid id)
    {
        var tenantId = GetTenantId();
        var result = await _patientService.GetByIdAsync(tenantId, id);
        return result.Success ? Ok(result) : NotFound(result);
    }

    [HttpGet("search")]
    public async Task<IActionResult> Search([FromQuery] string searchTerm = "")
    {
        var tenantId = GetTenantId();
        var result = await _patientService.SearchAsync(tenantId, searchTerm);
        return Ok(result);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreatePatientDto dto)
    {
        var tenantId = GetTenantId();
        var branchId = GetBranchId();
        var userId = GetUserId();

        if (branchId == null)
            return BadRequest("لا يوجد فرع محدد لهذا المستخدم");

        var result = await _patientService.CreateAsync(tenantId, branchId.Value, userId, dto);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> Update(Guid id, [FromBody] UpdatePatientDto dto)
    {
        var tenantId = GetTenantId();
        var userId = GetUserId();
        var result = await _patientService.UpdateAsync(tenantId, id, userId, dto);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Delete(Guid id)
    {
        var tenantId = GetTenantId();
        var userId = GetUserId();
        var result = await _patientService.DeleteAsync(tenantId, id, userId);
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