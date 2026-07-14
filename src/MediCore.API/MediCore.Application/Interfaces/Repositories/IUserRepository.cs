using MediCore.Domain.Entities;

namespace MediCore.Application.Interfaces.Repositories;

public interface IUserRepository : IGenericRepository<UserProfile>
{
    Task<UserProfile?> GetByEmailAsync(string email);
    Task<IEnumerable<UserProfile>> GetByTenantAsync(Guid tenantId);
    Task<IEnumerable<UserProfile>> GetDoctorsByTenantAsync(Guid tenantId);
    Task<bool> EmailExistsAsync(string email);
}