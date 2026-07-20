using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Laboratory;
using MediCore.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace MediCore.Infrastructure.Repositories;

public class LabOrderRepository : GenericRepository<LabOrder>, ILabOrderRepository
{
    public LabOrderRepository(MediCoreDbContext context) : base(context)
    {
    }

    public async Task<LabOrder?> GetByIdWithDetailsAsync(Guid tenantId, Guid orderId)
    {
        return await _context.LabOrders
            .Include(o => o.Items).ThenInclude(i => i.LabTestCatalog)
            .Include(o => o.Items).ThenInclude(i => i.Result)
            .FirstOrDefaultAsync(o => o.Id == orderId && o.TenantId == tenantId && !o.IsDeleted);
    }

    public async Task<List<LabOrder>> GetByPatientWithDetailsAsync(Guid tenantId, Guid patientId)
    {
        return await _context.LabOrders
            .Include(o => o.Items).ThenInclude(i => i.LabTestCatalog)
            .Include(o => o.Items).ThenInclude(i => i.Result)
            .Where(o => o.TenantId == tenantId && o.PatientId == patientId && !o.IsDeleted)
            .OrderByDescending(o => o.OrderedAt)
            .ToListAsync();
    }

    public async Task<List<LabOrder>> GetPendingWithDetailsAsync(Guid tenantId)
    {
        return await _context.LabOrders
            .Include(o => o.Items).ThenInclude(i => i.LabTestCatalog)
            .Include(o => o.Items).ThenInclude(i => i.Result)
            .Where(o => o.TenantId == tenantId
                && !o.IsDeleted
                && o.Status != Domain.Enums.LabOrderStatus.ReviewedByDoctor
                && o.Status != Domain.Enums.LabOrderStatus.Cancelled)
            .OrderBy(o => o.OrderedAt)
            .ToListAsync();
    }
}
