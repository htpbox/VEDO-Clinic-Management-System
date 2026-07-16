using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using MediCore.Application.DTOs.Invoice;
using MediCore.Application.Interfaces.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MediCore.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class InvoicesController : ControllerBase
{
    private readonly IInvoiceService _invoiceService;

    public InvoicesController(IInvoiceService invoiceService)
    {
        _invoiceService = invoiceService;
    }

    [HttpGet("{id:guid}")]
    public async Task<IActionResult> GetById(Guid id)
    {
        var tenantId = GetTenantId();
        var result = await _invoiceService.GetByIdAsync(tenantId, id);
        return result.Success ? Ok(result) : NotFound(result);
    }

    [HttpGet("patient/{patientId:guid}")]
    public async Task<IActionResult> GetByPatient(Guid patientId)
    {
        var tenantId = GetTenantId();
        var result = await _invoiceService.GetByPatientAsync(tenantId, patientId);
        return Ok(result);
    }

    [HttpPost]
    [Authorize(Roles = "SuperAdmin,ClinicAdmin,Receptionist,Accountant")]
    public async Task<IActionResult> Create([FromBody] CreateInvoiceDto dto)
    {
        var tenantId = GetTenantId();
        var branchId = GetBranchId();
        var userId = GetUserId();

        if (branchId == null)
            return BadRequest("لا يوجد فرع محدد لهذا المستخدم");

        var result = await _invoiceService.CreateAsync(tenantId, branchId.Value, userId, dto);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    [HttpPost("{id:guid}/payments")]
    [Authorize(Roles = "SuperAdmin,ClinicAdmin,Receptionist,Accountant")]
    public async Task<IActionResult> RecordPayment(Guid id, [FromBody] RecordPaymentDto dto)
    {
        var tenantId = GetTenantId();
        var userId = GetUserId();
        var result = await _invoiceService.RecordPaymentAsync(tenantId, id, userId, dto);
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