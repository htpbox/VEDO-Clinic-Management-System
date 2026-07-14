using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using MediCore.Application.DTOs.Encounter;
using MediCore.Application.Interfaces.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MediCore.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class EncountersController : ControllerBase
{
    private readonly IEncounterService _encounterService;

    public EncountersController(IEncounterService encounterService)
    {
        _encounterService = encounterService;
    }

    [HttpGet("{id:guid}")]
    public async Task<IActionResult> GetById(Guid id)
    {
        var tenantId = GetTenantId();
        var result = await _encounterService.GetByIdAsync(tenantId, id);
        return result.Success ? Ok(result) : NotFound(result);
    }

    [HttpGet("patient/{patientId:guid}")]
    public async Task<IActionResult> GetByPatient(Guid patientId)
    {
        var tenantId = GetTenantId();
        var result = await _encounterService.GetByPatientAsync(tenantId, patientId);
        return Ok(result);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateEncounterDto dto)
    {
        var tenantId = GetTenantId();
        var branchId = GetBranchId();
        var userId = GetUserId();

        if (branchId == null)
            return BadRequest("لا يوجد فرع محدد لهذا المستخدم");

        var result = await _encounterService.CreateAsync(tenantId, branchId.Value, userId, dto);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> Update(Guid id, [FromBody] UpdateEncounterDto dto)
    {
        var tenantId = GetTenantId();
        var result = await _encounterService.UpdateAsync(tenantId, id, dto);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    [HttpPut("{id:guid}/close")]
    public async Task<IActionResult> Close(Guid id)
    {
        var tenantId = GetTenantId();
        var result = await _encounterService.CloseAsync(tenantId, id);
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