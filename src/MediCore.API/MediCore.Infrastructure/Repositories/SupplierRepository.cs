using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Inventory;
using MediCore.Infrastructure.Data;

namespace MediCore.Infrastructure.Repositories;

public class SupplierRepository : GenericRepository<Supplier>, ISupplierRepository
{
    public SupplierRepository(MediCoreDbContext context) : base(context)
    {
    }
}
