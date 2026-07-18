using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Inventory;
using MediCore.Infrastructure.Data;

namespace MediCore.Infrastructure.Repositories;

public class StockBatchRepository : GenericRepository<StockBatch>, IStockBatchRepository
{
    public StockBatchRepository(MediCoreDbContext context) : base(context)
    {
    }
}
