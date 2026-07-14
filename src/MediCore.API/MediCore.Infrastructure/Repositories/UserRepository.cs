using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities;
using MediCore.Domain.Enums;
using MediCore.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace MediCore.Infrastructure.Repositories;

public class UserRepository : GenericRepository<UserProfile>, IUserRepository
{
    public UserRepository(MediCoreDbContext context) : base(context) { }

    public async Task<UserProfile?> GetByEmailAsync(string email)
        => await _dbSet
            .FirstOrDefaultAsync(u => u.Email == email && !u.IsDeleted);

    public async Task<IEnumerable<UserProfile>> GetByTenantAsync(Guid tenantId)
        => await _dbSet
            .Where(u => u.TenantId == tenantId && !u.IsDeleted)
            .OrderBy(u => u.FullName)
            .ToListAsync();

    public async Task<IEnumerable<UserProfile>> GetDoctorsByTenantAsync(Guid tenantId)
        => await _dbSet
            .Where(u => u.TenantId == tenantId
                && u.Role == UserRole.Doctor
                && u.IsActive
                && !u.IsDeleted)
            .OrderBy(u => u.FullName)
            .ToListAsync();

    public async Task<bool> EmailExistsAsync(string email)
        => await _dbSet.AnyAsync(u => u.Email == email && !u.IsDeleted);
}