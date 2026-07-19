using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Pharmacy;
using MediCore.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace MediCore.Infrastructure.Repositories;

public class PharmacySaleRepository : GenericRepository<PharmacySale>, IPharmacySaleRepository
{
    public PharmacySaleRepository(MediCoreDbContext context) : base(context)
    {
    }

    public async Task<PharmacySale?> GetByIdWithItemsAsync(Guid tenantId, Guid saleId)
    {
        return await _context.PharmacySales
            .Include(s => s.Items)
            .FirstOrDefaultAsync(s => s.Id == saleId && s.TenantId == tenantId && !s.IsDeleted);
    }

    public async Task<List<PharmacySale>> GetByPatientWithItemsAsync(Guid tenantId, Guid patientId)
    {
        return await _context.PharmacySales
            .Include(s => s.Items)
            .Where(s => s.TenantId == tenantId && s.PatientId == patientId && !s.IsDeleted)
            .OrderByDescending(s => s.SaleDate)
            .ToListAsync();
    }
}
