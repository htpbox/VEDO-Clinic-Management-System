using MediCore.Domain.Common;

namespace MediCore.Domain.Entities.Inventory;

public class InventoryItem : BaseEntity
{
    public Guid TenantId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Sku { get; set; } = string.Empty;
    public string? Barcode { get; set; }
    public Guid? CategoryId { get; set; }
    public string UnitOfMeasure { get; set; } = "unit";

    /// <summary>True for medications dispensed/sold through the Pharmacy module.</summary>
    public bool IsPharmacyItem { get; set; } = false;

    /// <summary>True when this item is tracked by batch/lot number and expiry date.</summary>
    public bool TracksBatches { get; set; } = false;

    public decimal CostPrice { get; set; }
    public decimal SalePrice { get; set; }
    public int ReorderPoint { get; set; } = 0;
    public int SafetyStock { get; set; } = 0;
    public bool IsActive { get; set; } = true;

    public InventoryCategory? Category { get; set; }
}
