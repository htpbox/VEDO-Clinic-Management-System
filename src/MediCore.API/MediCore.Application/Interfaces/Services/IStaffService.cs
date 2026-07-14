using MediCore.Application.Common;
using MediCore.Application.DTOs.Staff;

namespace MediCore.Application.Interfaces.Services;

public interface IStaffService
{
    Task<ApiResponse<IEnumerable<StaffMemberDto>>> GetDoctorsAsync(Guid tenantId);
    Task<ApiResponse<IEnumerable<StaffMemberDto>>> GetAllStaffAsync(Guid tenantId);
}