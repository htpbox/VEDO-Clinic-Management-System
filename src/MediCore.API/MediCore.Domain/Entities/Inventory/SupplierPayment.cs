using MediCore.Domain.Common;

namespace MediCore.Domain.Entities.Inventory;

public class SupplierPayment : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid SupplierId { get; set; }
    public Guid? PurchaseOrderId { get; set; }
    public decimal Amount { get; set; }
    public DateOnly PaymentDate { get; set; }
    public string Method { get; set; } = "Cash";
    public string? Notes { get; set; }

    public Supplier Supplier { get; set; } = null!;
}
