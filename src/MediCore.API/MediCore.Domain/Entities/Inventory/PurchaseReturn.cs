using MediCore.Domain.Common;

namespace MediCore.Domain.Entities.Inventory;

public class PurchaseReturn : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid SupplierId { get; set; }
    public Guid? PurchaseOrderId { get; set; }
    public Guid WarehouseId { get; set; }
    public DateOnly ReturnDate { get; set; }
    public string Reason { get; set; } = string.Empty;
    public decimal TotalAmount { get; set; }

    public Supplier Supplier { get; set; } = null!;
    public Warehouse Warehouse { get; set; } = null!;
    public List<PurchaseReturnItem> Items { get; set; } = new();
}

public class PurchaseReturnItem : BaseEntity
{
    public Guid PurchaseReturnId { get; set; }
    public Guid ItemId { get; set; }
    public decimal Quantity { get; set; }
    public decimal UnitCost { get; set; }

    public PurchaseReturn PurchaseReturn { get; set; } = null!;
    public InventoryItem Item { get; set; } = null!;
}
