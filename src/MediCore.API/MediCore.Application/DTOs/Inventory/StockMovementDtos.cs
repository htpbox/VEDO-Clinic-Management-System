using MediCore.Domain.Enums;

namespace MediCore.Application.DTOs.Inventory;

public class ReceiveStockRequest
{
    public Guid TenantId { get; set; }
    public Guid WarehouseId { get; set; }
    public Guid ItemId { get; set; }
    public decimal Quantity { get; set; }
    public decimal UnitCost { get; set; }
    public string? BatchNumber { get; set; }
    public DateOnly? ExpiryDate { get; set; }
    public string ReferenceType { get; set; } = string.Empty;
    public Guid? ReferenceId { get; set; }
}

public class IssueStockRequest
{
    public Guid TenantId { get; set; }
    public Guid WarehouseId { get; set; }
    public Guid ItemId { get; set; }
    public decimal Quantity { get; set; }
    public StockMovementType MovementType { get; set; } = StockMovementType.Issue;
    public string ReferenceType { get; set; } = string.Empty;
    public Guid? ReferenceId { get; set; }
}

public class LowStockItemDto
{
    public Guid ItemId { get; set; }
    public string ItemName { get; set; } = string.Empty;
    public string Sku { get; set; } = string.Empty;
    public Guid WarehouseId { get; set; }
    public string WarehouseName { get; set; } = string.Empty;
    public decimal QuantityOnHand { get; set; }
    public int ReorderPoint { get; set; }
    public int SafetyStock { get; set; }
}

public class ExpiringBatchDto
{
    public Guid BatchId { get; set; }
    public Guid ItemId { get; set; }
    public string ItemName { get; set; } = string.Empty;
    public string BatchNumber { get; set; } = string.Empty;
    public DateOnly ExpiryDate { get; set; }
    public decimal QuantityRemaining { get; set; }
    public string WarehouseName { get; set; } = string.Empty;
}
