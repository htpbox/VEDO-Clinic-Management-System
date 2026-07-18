using MediCore.Domain.Common;

namespace MediCore.Domain.Entities.Inventory;

public class GoodsReceipt : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid PurchaseOrderId { get; set; }
    public Guid WarehouseId { get; set; }
    public string ReceiptNumber { get; set; } = string.Empty;
    public DateOnly ReceivedDate { get; set; }
    public Guid ReceivedBy { get; set; }
    public string? Notes { get; set; }

    public PurchaseOrder PurchaseOrder { get; set; } = null!;
    public Warehouse Warehouse { get; set; } = null!;
    public List<GoodsReceiptItem> Items { get; set; } = new();
}

public class GoodsReceiptItem : BaseEntity
{
    public Guid GoodsReceiptId { get; set; }
    public Guid ItemId { get; set; }
    public decimal QuantityReceived { get; set; }
    public decimal UnitCost { get; set; }
    public string? BatchNumber { get; set; }
    public DateOnly? ExpiryDate { get; set; }

    public GoodsReceipt GoodsReceipt { get; set; } = null!;
    public InventoryItem Item { get; set; } = null!;
}
