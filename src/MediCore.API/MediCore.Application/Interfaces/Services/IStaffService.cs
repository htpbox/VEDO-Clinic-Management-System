using MediCore.Application.Common;
using MediCore.Application.DTOs.Staff;

namespace MediCore.Application.Interfaces.Services;

public interface IStaffService
{
    Task<ApiResponse<IEnumerable<StaffMemberDto>>> GetDoctorsAsync(Guid tenantId);
    Task<ApiResponse<IEnumerable<StaffMemberDto>>> GetAllStaffAsync(Guid tenantId);
    Task<ApiResponse<StaffMemberDto>> CreateAsync(Guid tenantId, Guid? branchId, CreateStaffDto dto);
    Task<ApiResponse<StaffMemberDto>> UpdateAsync(Guid tenantId, Guid staffId, UpdateStaffDto dto);
    Task<ApiResponse<StaffMemberDto>> DeactivateAsync(Guid tenantId, Guid staffId);
    Task<ApiResponse<StaffMemberDto>> ActivateAsync(Guid tenantId, Guid staffId);
}