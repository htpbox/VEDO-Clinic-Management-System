using MediCore.Application.DTOs.Inventory;
using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Inventory;
using MediCore.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace MediCore.Infrastructure.Repositories;

public class StockBatchRepository : GenericRepository<StockBatch>, IStockBatchRepository
{
    public StockBatchRepository(MediCoreDbContext context) : base(context)
    {
    }

    public async Task<List<ExpiringBatchDto>> GetExpiringSoonAsync(Guid tenantId, int withinDays)
    {
        var cutoff = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(withinDays));

        return await _context.StockBatches
            .Include(b => b.Item)
            .Include(b => b.Warehouse)
            .Where(b => b.TenantId == tenantId
                && !b.IsDeleted
                && b.QuantityRemaining > 0
                && b.ExpiryDate != null
                && b.ExpiryDate <= cutoff)
            .OrderBy(b => b.ExpiryDate)
            .Select(b => new ExpiringBatchDto
            {
                BatchId = b.Id,
                ItemId = b.ItemId,
                ItemName = b.Item.Name,
                BatchNumber = b.BatchNumber,
                ExpiryDate = b.ExpiryDate!.Value,
                QuantityRemaining = b.QuantityRemaining,
                WarehouseName = b.Warehouse.Name,
            })
            .ToListAsync();
    }

    public async Task<List<StockBatch>> GetConsumableBatchesAsync(Guid tenantId, Guid warehouseId, Guid itemId)
    {
        return await _context.StockBatches
            .Where(b => b.TenantId == tenantId
                && b.WarehouseId == warehouseId
                && b.ItemId == itemId
                && !b.IsDeleted
                && b.QuantityRemaining > 0)
            .OrderBy(b => b.ExpiryDate == null) // batches with an expiry date come first
            .ThenBy(b => b.ExpiryDate)
            .ToListAsync();
    }
}
