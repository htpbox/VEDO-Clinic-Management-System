using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Inventory;
using MediCore.Infrastructure.Data;

namespace MediCore.Infrastructure.Repositories;

public class PurchaseOrderRepository : GenericRepository<PurchaseOrder>, IPurchaseOrderRepository
{
    public PurchaseOrderRepository(MediCoreDbContext context) : base(context)
    {
    }
}
