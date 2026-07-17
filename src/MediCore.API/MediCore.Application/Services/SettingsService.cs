using MediCore.Application.Common;
using MediCore.Application.DTOs.Settings;
using MediCore.Application.Interfaces;
using MediCore.Application.Interfaces.Services;
using MediCore.Domain.Entities;

namespace MediCore.Application.Services;

public class SettingsService : ISettingsService
{
    private readonly IUnitOfWork _unitOfWork;

    public SettingsService(IUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }

    public async Task<ApiResponse<TenantSettingsDto>> GetSettingsAsync(Guid tenantId)
    {
        var tenant = await _unitOfWork.Tenants.GetByIdAsync(tenantId);
        if (tenant == null)
            return ApiResponse<TenantSettingsDto>.Fail("العيادة غير موجودة");

        return ApiResponse<TenantSettingsDto>.Ok(MapToDto(tenant));
    }

    public async Task<ApiResponse<TenantSettingsDto>> UpdateSettingsAsync(Guid tenantId, UpdateTenantSettingsDto dto)
    {
        var tenant = await _unitOfWork.Tenants.GetByIdAsync(tenantId);
        if (tenant == null)
            return ApiResponse<TenantSettingsDto>.Fail("العيادة غير موجودة");

        tenant.Name = dto.Name;
        tenant.NameEn = dto.NameEn;
        tenant.Phone = dto.Phone;
        tenant.Email = dto.Email;
        tenant.Address = dto.Address;
        tenant.City = dto.City;
        tenant.Governorate = dto.Governorate;
        tenant.TaxNumber = dto.TaxNumber;

        await _unitOfWork.Tenants.UpdateAsync(tenant);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<TenantSettingsDto>.Ok(MapToDto(tenant), "تم حفظ الإعدادات بنجاح");
    }

    private static TenantSettingsDto MapToDto(Tenant tenant) => new()
    {
        Id = tenant.Id,
        Name = tenant.Name,
        NameEn = tenant.NameEn,
        LogoUrl = tenant.LogoUrl,
        Phone = tenant.Phone,
        Email = tenant.Email,
        Address = tenant.Address,
        City = tenant.City,
        Governorate = tenant.Governorate,
        TaxNumber = tenant.TaxNumber,
    };
}
