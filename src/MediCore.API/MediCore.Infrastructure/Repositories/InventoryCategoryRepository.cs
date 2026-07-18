using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Inventory;
using MediCore.Infrastructure.Data;

namespace MediCore.Infrastructure.Repositories;

public class InventoryCategoryRepository : GenericRepository<InventoryCategory>, IInventoryCategoryRepository
{
    public InventoryCategoryRepository(MediCoreDbContext context) : base(context)
    {
    }
}
