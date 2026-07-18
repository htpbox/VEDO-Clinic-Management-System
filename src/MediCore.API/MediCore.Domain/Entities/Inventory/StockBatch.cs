using MediCore.Domain.Common;

namespace MediCore.Domain.Entities.Inventory;

public class StockBatch : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid WarehouseId { get; set; }
    public Guid ItemId { get; set; }
    public string BatchNumber { get; set; } = string.Empty;
    public DateOnly? ExpiryDate { get; set; }
    public decimal QuantityReceived { get; set; }
    public decimal QuantityRemaining { get; set; }
    public decimal UnitCost { get; set; }

    public Warehouse Warehouse { get; set; } = null!;
    public InventoryItem Item { get; set; } = null!;
}
