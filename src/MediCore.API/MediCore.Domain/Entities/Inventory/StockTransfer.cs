using MediCore.Domain.Common;
using MediCore.Domain.Enums;

namespace MediCore.Domain.Entities.Inventory;

public class StockTransfer : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid FromWarehouseId { get; set; }
    public Guid ToWarehouseId { get; set; }
    public StockTransferStatus Status { get; set; } = StockTransferStatus.Pending;
    public DateOnly TransferDate { get; set; }
    public string? Notes { get; set; }

    public Warehouse FromWarehouse { get; set; } = null!;
    public Warehouse ToWarehouse { get; set; } = null!;
    public List<StockTransferItem> Items { get; set; } = new();
}

public class StockTransferItem : BaseEntity
{
    public Guid StockTransferId { get; set; }
    public Guid ItemId { get; set; }
    public decimal Quantity { get; set; }
    public string? BatchNumber { get; set; }

    public StockTransfer StockTransfer { get; set; } = null!;
    public InventoryItem Item { get; set; } = null!;
}
