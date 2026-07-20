using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using MediCore.Application.DTOs.Laboratory;
using MediCore.Application.Interfaces.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MediCore.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class LabController : ControllerBase
{
    private readonly ILabService _labService;

    public LabController(ILabService labService)
    {
        _labService = labService;
    }

    [HttpGet("catalog")]
    public async Task<IActionResult> GetCatalog()
    {
        var result = await _labService.GetCatalogAsync(GetTenantId());
        return Ok(result);
    }

    [HttpPost("catalog")]
    [Authorize(Roles = "SuperAdmin,ClinicAdmin")]
    public async Task<IActionResult> CreateCatalogEntry([FromBody] CreateLabTestCatalogDto dto)
    {
        var result = await _labService.CreateCatalogEntryAsync(GetTenantId(), dto);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    [HttpPost("orders")]
    [Authorize(Roles = "SuperAdmin,ClinicAdmin,Doctor,SeniorDoctor")]
    public async Task<IActionResult> CreateOrder([FromBody] CreateLabOrderDto dto)
    {
        var branchId = GetBranchId();
        if (branchId == null)
            return BadRequest("لا يوجد فرع محدد لهذا المستخدم");

        var result = await _labService.CreateOrderAsync(GetTenantId(), branchId.Value, GetUserId(), dto);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    [HttpGet("orders/{id:guid}")]
    public async Task<IActionResult> GetOrder(Guid id)
    {
        var result = await _labService.GetByIdAsync(GetTenantId(), id);
        return result.Success ? Ok(result) : NotFound(result);
    }

    [HttpGet("orders/patient/{patientId:guid}")]
    public async Task<IActionResult> GetByPatient(Guid patientId)
    {
        var result = await _labService.GetByPatientAsync(GetTenantId(), patientId);
        return Ok(result);
    }

    [HttpGet("orders/pending")]
    [Authorize(Roles = "SuperAdmin,ClinicAdmin,LabTechnician,Doctor,SeniorDoctor")]
    public async Task<IActionResult> GetPendingOrders()
    {
        var result = await _labService.GetPendingOrdersAsync(GetTenantId());
        return Ok(result);
    }

    [HttpPost("results")]
    [Authorize(Roles = "SuperAdmin,ClinicAdmin,LabTechnician")]
    public async Task<IActionResult> EnterResult([FromBody] EnterLabResultDto dto)
    {
        var result = await _labService.EnterResultAsync(GetTenantId(), GetUserId(), dto);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    [HttpPost("results/{labOrderItemId:guid}/review")]
    [Authorize(Roles = "SuperAdmin,ClinicAdmin,Doctor,SeniorDoctor")]
    public async Task<IActionResult> ReviewResult(Guid labOrderItemId, [FromBody] ReviewLabResultDto dto)
    {
        var result = await _labService.ReviewResultAsync(GetTenantId(), labOrderItemId, GetUserId(), dto);
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
