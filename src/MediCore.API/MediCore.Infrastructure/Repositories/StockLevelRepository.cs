using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Inventory;
using MediCore.Infrastructure.Data;

namespace MediCore.Infrastructure.Repositories;

public class StockLevelRepository : GenericRepository<StockLevel>, IStockLevelRepository
{
    public StockLevelRepository(MediCoreDbContext context) : base(context)
    {
    }
}
