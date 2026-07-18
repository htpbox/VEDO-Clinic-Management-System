using MediCore.Domain.Common;

namespace MediCore.Domain.Entities.Inventory;

public class StockAdjustment : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid WarehouseId { get; set; }
    public Guid ItemId { get; set; }
    public decimal QuantityBefore { get; set; }
    public decimal QuantityAfter { get; set; }
    public string Reason { get; set; } = string.Empty;
    public Guid AdjustedBy { get; set; }
    public DateTime AdjustmentDate { get; set; } = DateTime.UtcNow;

    public Warehouse Warehouse { get; set; } = null!;
    public InventoryItem Item { get; set; } = null!;
}
