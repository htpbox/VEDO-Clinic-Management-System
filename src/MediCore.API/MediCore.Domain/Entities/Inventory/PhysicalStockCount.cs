using System.ComponentModel.DataAnnotations.Schema;
using MediCore.Domain.Common;
using MediCore.Domain.Enums;

namespace MediCore.Domain.Entities.Inventory;

public class PhysicalStockCount : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid WarehouseId { get; set; }
    public DateOnly CountDate { get; set; }
    public PhysicalCountStatus Status { get; set; } = PhysicalCountStatus.InProgress;
    public Guid CountedBy { get; set; }
    public string? Notes { get; set; }

    public Warehouse Warehouse { get; set; } = null!;
    public List<PhysicalStockCountItem> Items { get; set; } = new();
}

public class PhysicalStockCountItem : BaseEntity
{
    public Guid PhysicalStockCountId { get; set; }
    public Guid ItemId { get; set; }
    public decimal SystemQuantity { get; set; }
    public decimal CountedQuantity { get; set; }
    [NotMapped]
    public decimal VarianceQuantity => CountedQuantity - SystemQuantity;

    public PhysicalStockCount PhysicalStockCount { get; set; } = null!;
    public InventoryItem Item { get; set; } = null!;
}
