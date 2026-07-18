using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Inventory;
using MediCore.Infrastructure.Data;

namespace MediCore.Infrastructure.Repositories;

public class StockAdjustmentRepository : GenericRepository<StockAdjustment>, IStockAdjustmentRepository
{
    public StockAdjustmentRepository(MediCoreDbContext context) : base(context)
    {
    }
}
