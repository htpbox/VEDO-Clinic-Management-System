using MediCore.Application.DTOs.Settings;
using MediCore.Application.Interfaces.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MediCore.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class SettingsController : ControllerBase
{
    private readonly ISettingsService _settingsService;

    public SettingsController(ISettingsService settingsService)
    {
        _settingsService = settingsService;
    }

    [HttpGet]
    public async Task<IActionResult> Get()
    {
        var tenantId = GetTenantId();
        var result = await _settingsService.GetSettingsAsync(tenantId);
        return result.Success ? Ok(result) : NotFound(result);
    }

    [HttpPut]
    [Authorize(Roles = "SuperAdmin,ClinicAdmin")]
    public async Task<IActionResult> Update([FromBody] UpdateTenantSettingsDto dto)
    {
        var tenantId = GetTenantId();
        var result = await _settingsService.UpdateSettingsAsync(tenantId, dto);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    private Guid GetTenantId()
    {
        var value = User.FindFirst("tenant_id")?.Value;
        return Guid.Parse(value!);
    }
}
