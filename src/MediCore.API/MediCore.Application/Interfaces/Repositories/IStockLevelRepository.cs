using MediCore.Application.DTOs.Inventory;
using MediCore.Domain.Entities.Inventory;

namespace MediCore.Application.Interfaces.Repositories;

public interface IStockLevelRepository : IGenericRepository<StockLevel>
{
    /// <summary>Items whose QuantityOnHand has fallen to or below the item's ReorderPoint.</summary>
    Task<List<LowStockItemDto>> GetLowStockAsync(Guid tenantId, Guid? warehouseId);

    Task<StockLevel?> GetForItemAsync(Guid tenantId, Guid warehouseId, Guid itemId);
}
