using BCrypt.Net;
using MediCore.Application.Common;
using MediCore.Application.DTOs.Auth;
using MediCore.Application.Interfaces;
using MediCore.Application.Interfaces.Services;

namespace MediCore.Application.Services;

public class AuthService : IAuthService
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IJwtTokenGenerator _jwtTokenGenerator;

    public AuthService(IUnitOfWork unitOfWork, IJwtTokenGenerator jwtTokenGenerator)
    {
        _unitOfWork = unitOfWork;
        _jwtTokenGenerator = jwtTokenGenerator;
    }

    public async Task<ApiResponse<LoginResponseDto>> LoginAsync(LoginDto dto)
    {
        var user = await _unitOfWork.Users.GetByEmailAsync(dto.Email);

        if (user == null || !user.IsActive)
            return ApiResponse<LoginResponseDto>.Fail("البريد الإلكتروني أو كلمة المرور غير صحيحة");

        if (!BCrypt.Net.BCrypt.Verify(dto.Password, user.PasswordHash))            return ApiResponse<LoginResponseDto>.Fail("البريد الإلكتروني أو كلمة المرور غير صحيحة");

        var token = _jwtTokenGenerator.GenerateToken(user);
        var expiresAt = DateTime.UtcNow.AddMinutes(60);

        user.LastLoginAt = DateTime.UtcNow;
        await _unitOfWork.Users.UpdateAsync(user);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<LoginResponseDto>.Ok(new LoginResponseDto
{
    Token = token,
    UserId = user.Id,
    Email = user.Email,           // جديد
    FullName = user.FullName,
    Role = user.Role.ToString(),
    TenantId = user.TenantId,
    BranchId = user.BranchId,     // جديد
    ExpiresAt = expiresAt
});
    }
}