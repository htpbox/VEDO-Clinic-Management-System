using MediCore.Domain.Common;

namespace MediCore.Domain.Entities.Inventory;

/// <summary>
/// Current on-hand quantity for one item at one warehouse. AverageCost is
/// maintained as a moving weighted average, recalculated on every Receipt -
/// this is the valuation method chosen for v1 (simpler and safer to reason
/// about than FIFO/LIFO lot-matching); swapping methods later only touches
/// StockService, not the schema.
/// </summary>
public class StockLevel : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid WarehouseId { get; set; }
    public Guid ItemId { get; set; }
    public decimal QuantityOnHand { get; set; }
    public decimal AverageCost { get; set; }

    public Warehouse Warehouse { get; set; } = null!;
    public InventoryItem Item { get; set; } = null!;
}
