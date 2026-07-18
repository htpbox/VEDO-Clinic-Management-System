using MediCore.Domain.Common;
using MediCore.Domain.Enums;

namespace MediCore.Domain.Entities.Inventory;

public class PurchaseOrder : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid BranchId { get; set; }
    public Guid WarehouseId { get; set; }
    public Guid SupplierId { get; set; }
    public string PoNumber { get; set; } = string.Empty;
    public PurchaseOrderStatus Status { get; set; } = PurchaseOrderStatus.Draft;
    public DateOnly OrderDate { get; set; }
    public DateOnly? ExpectedDate { get; set; }
    public decimal TotalAmount { get; set; }
    public string? Notes { get; set; }

    public Warehouse Warehouse { get; set; } = null!;
    public Supplier Supplier { get; set; } = null!;
    public List<PurchaseOrderItem> Items { get; set; } = new();
}

public class PurchaseOrderItem : BaseEntity
{
    public Guid PurchaseOrderId { get; set; }
    public Guid ItemId { get; set; }
    public decimal QuantityOrdered { get; set; }
    public decimal QuantityReceived { get; set; } = 0;
    public decimal UnitCost { get; set; }

    public PurchaseOrder PurchaseOrder { get; set; } = null!;
    public InventoryItem Item { get; set; } = null!;
}
