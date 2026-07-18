using MediCore.Application.DTOs.Inventory;
using MediCore.Domain.Entities.Inventory;

namespace MediCore.Application.Interfaces.Repositories;

public interface IStockBatchRepository : IGenericRepository<StockBatch>
{
    Task<List<ExpiringBatchDto>> GetExpiringSoonAsync(Guid tenantId, int withinDays);

    /// <summary>Batches with remaining quantity for one item at one warehouse, oldest expiry first (FEFO consumption order). Batches with no expiry date sort last.</summary>
    Task<List<StockBatch>> GetConsumableBatchesAsync(Guid tenantId, Guid warehouseId, Guid itemId);
}
