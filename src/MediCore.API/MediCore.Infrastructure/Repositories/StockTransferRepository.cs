using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Inventory;
using MediCore.Infrastructure.Data;

namespace MediCore.Infrastructure.Repositories;

public class StockTransferRepository : GenericRepository<StockTransfer>, IStockTransferRepository
{
    public StockTransferRepository(MediCoreDbContext context) : base(context)
    {
    }
}
