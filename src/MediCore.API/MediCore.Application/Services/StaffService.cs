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

    public async Task<ApiResponse<StaffMemberDto>> CreateAsync(Guid tenantId, Guid? branchId, CreateStaffDto dto)
    {
        var emailExists = await _unitOfWork.Users.EmailExistsAsync(dto.Email);
        if (emailExists)
            return ApiResponse<StaffMemberDto>.Fail("البريد الإلكتروني مستخدم مسبقاً");

        if (!Enum.TryParse<UserRole>(dto.Role, true, out var role))
            return ApiResponse<StaffMemberDto>.Fail("الدور الوظيفي غير صحيح");

        var staffMember = new UserProfile
        {
            TenantId = tenantId,
            BranchId = branchId,
            FullName = dto.FullName,
            Email = dto.Email,
            PasswordHash = BCrypt.Net.BCrypt.HashPassword(dto.Password),
            Phone = dto.Phone,
            Role = role,
            IsActive = true,
            MustChangePassword = true
        };

        await _unitOfWork.Users.AddAsync(staffMember);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<StaffMemberDto>.Ok(MapToDto(staffMember), "تم إضافة الموظف بنجاح");
    }

    public async Task<ApiResponse<StaffMemberDto>> UpdateAsync(Guid tenantId, Guid staffId, UpdateStaffDto dto)
    {
        var staffMember = await _unitOfWork.Users.GetByIdAsync(staffId);
        if (staffMember == null || staffMember.TenantId != tenantId)
            return ApiResponse<StaffMemberDto>.Fail("الموظف غير موجود");

        if (!Enum.TryParse<UserRole>(dto.Role, true, out var role))
            return ApiResponse<StaffMemberDto>.Fail("الدور الوظيفي غير صحيح");

        staffMember.FullName = dto.FullName;
        staffMember.Phone = dto.Phone;
        staffMember.Role = role;

        await _unitOfWork.Users.UpdateAsync(staffMember);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<StaffMemberDto>.Ok(MapToDto(staffMember), "تم تحديث بيانات الموظف");
    }

    public async Task<ApiResponse<StaffMemberDto>> DeactivateAsync(Guid tenantId, Guid staffId)
    {
        var staffMember = await _unitOfWork.Users.GetByIdAsync(staffId);
        if (staffMember == null || staffMember.TenantId != tenantId)
            return ApiResponse<StaffMemberDto>.Fail("الموظف غير موجود");

        staffMember.IsActive = false;
        await _unitOfWork.Users.UpdateAsync(staffMember);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<StaffMemberDto>.Ok(MapToDto(staffMember), "تم إيقاف حساب الموظف");
    }

    public async Task<ApiResponse<StaffMemberDto>> ActivateAsync(Guid tenantId, Guid staffId)
    {
        var staffMember = await _unitOfWork.Users.GetByIdAsync(staffId);
        if (staffMember == null || staffMember.TenantId != tenantId)
            return ApiResponse<StaffMemberDto>.Fail("الموظف غير موجود");

        staffMember.IsActive = true;
        await _unitOfWork.Users.UpdateAsync(staffMember);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<StaffMemberDto>.Ok(MapToDto(staffMember), "تم تفعيل حساب الموظف");
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