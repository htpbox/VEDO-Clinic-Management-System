using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Inventory;
using MediCore.Infrastructure.Data;

namespace MediCore.Infrastructure.Repositories;

public class PurchaseReturnRepository : GenericRepository<PurchaseReturn>, IPurchaseReturnRepository
{
    public PurchaseReturnRepository(MediCoreDbContext context) : base(context)
    {
    }
}
