using MediCore.Application.DTOs.Staff;
using MediCore.Application.Interfaces.Services;
using MediCore.Application.Common;
using MediCore.Application.Interfaces;
using MediCore.Domain.Entities;
using MediCore.Domain.Enums;

namespace MediCore.Application.Services;

public class StaffService : IStaffService
{
    private readonly IUnitOfWork _unitOfWork;

    public StaffService(IUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }

    public async Task<ApiResponse<IEnumerable<StaffMemberDto>>> GetDoctorsAsync(Guid tenantId)
    {
        // يشمل أي دور قادر فعلياً على إجراء كشف طبي، وليس Doctor فقط —
        // في عيادات فردية صغيرة يكون الطبيب هو نفسه ClinicAdmin.
        var allStaff = await _unitOfWork.Users.GetByTenantAsync(tenantId);
        var clinicalRoles = new List<UserRole> { UserRole.Doctor, UserRole.ClinicAdmin };
        var doctors = allStaff.Where(u => clinicalRoles.Contains(u.Role) && u.IsActive);
        return ApiResponse<IEnumerable<StaffMemberDto>>.Ok(doctors.Select(MapToDto));
    }

    public async Task<ApiResponse<IEnumerable<StaffMemberDto>>> GetAllStaffAsync(Guid tenantId)
    {
        var staff = await _unitOfWork.Users.GetByTenantAsync(tenantId);
        return ApiResponse<IEnumerable<StaffMemberDto>>.Ok(staff.Select(MapToDto));
    }

    private static StaffMemberDto MapToDto(UserProfile user)
    {
        return new StaffMemberDto
        {
            Id = user.Id,
            FullName = user.FullName,
            Email = user.Email,
            Phone = user.Phone,
            Role = user.Role.ToString(),
            IsActive = user.IsActive
        };
    }
}