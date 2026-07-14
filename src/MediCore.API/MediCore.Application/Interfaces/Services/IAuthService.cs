using MediCore.Application.Common;
using MediCore.Application.DTOs.Auth;

namespace MediCore.Application.Interfaces.Services;

public interface IAuthService
{
    Task<ApiResponse<LoginResponseDto>> LoginAsync(LoginDto dto);
}