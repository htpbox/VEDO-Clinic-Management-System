using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using MediCore.Application.DTOs.Pharmacy;
using MediCore.Application.Interfaces.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MediCore.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize(Roles = "SuperAdmin,ClinicAdmin,Pharmacist")]
public class PharmacyController : ControllerBase
{
    private readonly IPharmacyService _pharmacyService;

    public PharmacyController(IPharmacyService pharmacyService)
    {
        _pharmacyService = pharmacyService;
    }

    [HttpPost("sales")]
    public async Task<IActionResult> CreateSale([FromBody] CreatePharmacySaleDto dto)
    {
        var branchId = GetBranchId();
        if (branchId == null)
            return BadRequest("لا يوجد فرع محدد لهذا المستخدم");

        var result = await _pharmacyService.CreateSaleAsync(GetTenantId(), branchId.Value, GetUserId(), dto);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    [HttpGet("sales/{id:guid}")]
    public async Task<IActionResult> GetSale(Guid id)
    {
        var result = await _pharmacyService.GetByIdAsync(GetTenantId(), id);
        return result.Success ? Ok(result) : NotFound(result);
    }

    [HttpGet("sales/patient/{patientId:guid}")]
    public async Task<IActionResult> GetByPatient(Guid patientId)
    {
        var result = await _pharmacyService.GetByPatientAsync(GetTenantId(), patientId);
        return Ok(result);
    }

    [HttpPost("sales/{id:guid}/return")]
    public async Task<IActionResult> ReturnSale(Guid id, [FromBody] ReturnPharmacySaleDto dto)
    {
        var result = await _pharmacyService.ReturnSaleAsync(GetTenantId(), id, GetUserId(), dto);
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
