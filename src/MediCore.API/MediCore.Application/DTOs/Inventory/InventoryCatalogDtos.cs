namespace MediCore.Application.DTOs.Inventory;

public class InventoryItemDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Sku { get; set; } = string.Empty;
    public string? Barcode { get; set; }
    public Guid? CategoryId { get; set; }
    public string? CategoryName { get; set; }
    public string UnitOfMeasure { get; set; } = "unit";
    public bool IsPharmacyItem { get; set; }
    public bool TracksBatches { get; set; }
    public decimal CostPrice { get; set; }
    public decimal SalePrice { get; set; }
    public int ReorderPoint { get; set; }
    public int SafetyStock { get; set; }
    public bool IsActive { get; set; }
}

public class CreateInventoryItemDto
{
    public string Name { get; set; } = string.Empty;
    public string Sku { get; set; } = string.Empty;
    public string? Barcode { get; set; }
    public Guid? CategoryId { get; set; }
    public string UnitOfMeasure { get; set; } = "unit";
    public bool IsPharmacyItem { get; set; }
    public bool TracksBatches { get; set; }
    public decimal CostPrice { get; set; }
    public decimal SalePrice { get; set; }
    public int ReorderPoint { get; set; }
    public int SafetyStock { get; set; }
}

public class UpdateInventoryItemDto
{
    public string Name { get; set; } = string.Empty;
    public string? Barcode { get; set; }
    public Guid? CategoryId { get; set; }
    public string UnitOfMeasure { get; set; } = "unit";
    public decimal CostPrice { get; set; }
    public decimal SalePrice { get; set; }
    public int ReorderPoint { get; set; }
    public int SafetyStock { get; set; }
    public bool IsActive { get; set; }
}

public class WarehouseDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Location { get; set; }
    public bool IsActive { get; set; }
}

public class CreateWarehouseDto
{
    public string Name { get; set; } = string.Empty;
    public string? Location { get; set; }
}

public class InventoryCategoryDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public Guid? ParentCategoryId { get; set; }
}

public class CreateInventoryCategoryDto
{
    public string Name { get; set; } = string.Empty;
    public Guid? ParentCategoryId { get; set; }
}

public class SupplierDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? ContactPerson { get; set; }
    public string? Phone { get; set; }
    public string? Email { get; set; }
    public string? Address { get; set; }
    public string? TaxNumber { get; set; }
    public bool IsActive { get; set; }
}

public class CreateSupplierDto
{
    public string Name { get; set; } = string.Empty;
    public string? ContactPerson { get; set; }
    public string? Phone { get; set; }
    public string? Email { get; set; }
    public string? Address { get; set; }
    public string? TaxNumber { get; set; }
}

public class StockLevelDto
{
    public Guid ItemId { get; set; }
    public string ItemName { get; set; } = string.Empty;
    public Guid WarehouseId { get; set; }
    public string WarehouseName { get; set; } = string.Empty;
    public decimal QuantityOnHand { get; set; }
    public decimal AverageCost { get; set; }
}

public class AdjustStockDto
{
    public Guid WarehouseId { get; set; }
    public Guid ItemId { get; set; }
    public decimal NewQuantity { get; set; }
    public string Reason { get; set; } = string.Empty;
}

public class TransferStockDto
{
    public Guid FromWarehouseId { get; set; }
    public Guid ToWarehouseId { get; set; }
    public Guid ItemId { get; set; }
    public decimal Quantity { get; set; }
}
