using MediCore.Domain.Common;
using MediCore.Domain.Enums;

namespace MediCore.Domain.Entities.Inventory;

/// <summary>
/// Append-only ledger entry for every stock change. This is the audit trail:
/// StockLevel holds the current balance, StockMovement explains how it got
/// there. ReferenceType/ReferenceId point at whatever caused the movement
/// (a PurchaseOrder, a PharmacySale, a StockAdjustment, etc.) without a hard
/// FK, so this table doesn't need to know about every other module.
/// </summary>
public class StockMovement : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid WarehouseId { get; set; }
    public Guid ItemId { get; set; }
    public Guid? BatchId { get; set; }
    public StockMovementType MovementType { get; set; }
    public decimal Quantity { get; set; }
    public decimal UnitCost { get; set; }
    public string? ReferenceType { get; set; }
    public Guid? ReferenceId { get; set; }
    public string? Notes { get; set; }
    public DateTime MovementDate { get; set; } = DateTime.UtcNow;

    public Warehouse Warehouse { get; set; } = null!;
    public InventoryItem Item { get; set; } = null!;
}
