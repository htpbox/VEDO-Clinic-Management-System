using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Laboratory;
using MediCore.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace MediCore.Infrastructure.Repositories;

public class LabOrderItemRepository : GenericRepository<LabOrderItem>, ILabOrderItemRepository
{
    public LabOrderItemRepository(MediCoreDbContext context) : base(context)
    {
    }

    public async Task<LabOrderItem?> GetByIdWithDetailsAsync(Guid id)
    {
        return await _context.LabOrderItems
            .Include(i => i.LabTestCatalog)
            .Include(i => i.LabOrder)
            .Include(i => i.Result)
            .FirstOrDefaultAsync(i => i.Id == id && !i.IsDeleted);
    }
}
