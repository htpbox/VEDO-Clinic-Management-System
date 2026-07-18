using MediCore.Application.DTOs.Inventory;
using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Inventory;
using MediCore.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace MediCore.Infrastructure.Repositories;

public class StockLevelRepository : GenericRepository<StockLevel>, IStockLevelRepository
{
    public StockLevelRepository(MediCoreDbContext context) : base(context)
    {
    }

    public async Task<List<LowStockItemDto>> GetLowStockAsync(Guid tenantId, Guid? warehouseId)
    {
        var query = _context.StockLevels
            .Include(sl => sl.Item)
            .Include(sl => sl.Warehouse)
            .Where(sl => sl.TenantId == tenantId
                && !sl.IsDeleted
                && sl.Item.IsActive
                && sl.QuantityOnHand <= sl.Item.ReorderPoint);

        if (warehouseId.HasValue)
            query = query.Where(sl => sl.WarehouseId == warehouseId.Value);

        return await query
            .Select(sl => new LowStockItemDto
            {
                ItemId = sl.ItemId,
                ItemName = sl.Item.Name,
                Sku = sl.Item.Sku,
                WarehouseId = sl.WarehouseId,
                WarehouseName = sl.Warehouse.Name,
                QuantityOnHand = sl.QuantityOnHand,
                ReorderPoint = sl.Item.ReorderPoint,
                SafetyStock = sl.Item.SafetyStock,
            })
            .ToListAsync();
    }

    public async Task<StockLevel?> GetForItemAsync(Guid tenantId, Guid warehouseId, Guid itemId)
    {
        return await _context.StockLevels.FirstOrDefaultAsync(sl =>
            sl.TenantId == tenantId
            && sl.WarehouseId == warehouseId
            && sl.ItemId == itemId
            && !sl.IsDeleted);
    }
}
