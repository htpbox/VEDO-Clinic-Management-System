using MediCore.Application.Common;
using MediCore.Application.DTOs.Inventory;

namespace MediCore.Application.Interfaces.Services;

/// <summary>
/// Every quantity change to stock goes through here - this is the one place
/// that touches StockLevel, StockBatch, and StockMovement together, so
/// receiving, dispensing, transferring, and adjusting can never drift out
/// of sync with each other. Callers (PharmacyService, PurchaseOrderService,
/// etc.) should never write to StockLevel/StockMovement directly.
/// </summary>
public interface IStockService
{
    /// <summary>Increases stock (goods receipt). Creates/updates the batch if TracksBatches, recalculates moving-average cost.</summary>
    Task<ApiResponse<string>> ReceiveStockAsync(ReceiveStockRequest request);

    /// <summary>Decreases stock (sale/dispense/issue). Consumes oldest-expiring batch first (FEFO) when TracksBatches. Fails if insufficient quantity.</summary>
    Task<ApiResponse<string>> IssueStockAsync(IssueStockRequest request);

    /// <summary>Sets an item's stock to an exact counted quantity, recording the before/after as a StockAdjustment.</summary>
    Task<ApiResponse<string>> AdjustStockAsync(Guid tenantId, Guid warehouseId, Guid itemId, decimal newQuantity, string reason, Guid adjustedBy);

    /// <summary>Moves stock between two warehouses of the same tenant in one atomic operation.</summary>
    Task<ApiResponse<string>> TransferStockAsync(Guid tenantId, Guid fromWarehouseId, Guid toWarehouseId, Guid itemId, decimal quantity, Guid transferredBy);

    Task<ApiResponse<List<LowStockItemDto>>> GetLowStockItemsAsync(Guid tenantId, Guid? warehouseId);
    Task<ApiResponse<List<ExpiringBatchDto>>> GetExpiringBatchesAsync(Guid tenantId, int withinDays);
}
