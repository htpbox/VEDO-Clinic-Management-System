using MediCore.Domain.Entities;

namespace MediCore.Application.Interfaces.Services;

public interface IJwtTokenGenerator
{
    string GenerateToken(UserProfile user);
}