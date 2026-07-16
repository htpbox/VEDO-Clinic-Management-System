using MediCore.Application.Common;
using MediCore.Application.DTOs.Settings;

namespace MediCore.Application.Interfaces.Services;

public interface ISettingsService
{
    Task<ApiResponse<TenantSettingsDto>> GetSettingsAsync(Guid tenantId);
    Task<ApiResponse<TenantSettingsDto>> UpdateSettingsAsync(Guid tenantId, UpdateTenantSettingsDto dto);
}
