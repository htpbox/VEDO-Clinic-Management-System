using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Medical;
using MediCore.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace MediCore.Infrastructure.Repositories;

public class PatientRepository : GenericRepository<Patient>, IPatientRepository
{
    public PatientRepository(MediCoreDbContext context) : base(context) { }

    public async Task<Patient?> GetByFileNumberAsync(Guid tenantId, string fileNumber)
        => await _dbSet
            .FirstOrDefaultAsync(p => p.TenantId == tenantId
                && p.FileNumber == fileNumber
                && !p.IsDeleted);

    public async Task<Patient?> GetByNationalIdAsync(Guid tenantId, string nationalId)
        => await _dbSet
            .FirstOrDefaultAsync(p => p.TenantId == tenantId
                && p.NationalId == nationalId
                && !p.IsDeleted);

    public async Task<IEnumerable<Patient>> SearchAsync(Guid tenantId, string searchTerm)
        => await _dbSet
            .Where(p => p.TenantId == tenantId
                && !p.IsDeleted
                && (p.FullName.Contains(searchTerm)
                    || p.Phone!.Contains(searchTerm)
                    || p.FileNumber.Contains(searchTerm)
                    || p.NationalId!.Contains(searchTerm)))
            .OrderBy(p => p.FullName)
            .Take(50)
            .ToListAsync();

    public async Task<Patient?> GetWithMedicalRecordAsync(Guid tenantId, Guid patientId)
        => await _dbSet
            .Include(p => p.MedicalRecord)
            .FirstOrDefaultAsync(p => p.TenantId == tenantId
                && p.Id == patientId
                && !p.IsDeleted);

    public async Task<string> GenerateFileNumberAsync(Guid tenantId)
    {
        var count = await _dbSet.CountAsync(p => p.TenantId == tenantId);
        return $"P{(count + 1):D6}";
    }

    public async Task<bool> FileNumberExistsAsync(Guid tenantId, string fileNumber)
        => await _dbSet.AnyAsync(p => p.TenantId == tenantId
            && p.FileNumber == fileNumber);
}