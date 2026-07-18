using MediCore.Domain.Common;
using MediCore.Domain.Enums;

namespace MediCore.Domain.Entities.Pharmacy;

public class PharmacySale : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid BranchId { get; set; }
    public Guid WarehouseId { get; set; }
    public Guid? PatientId { get; set; }
    public Guid? PrescriptionId { get; set; }
    public Guid? InvoiceId { get; set; }
    public PharmacySaleType SaleType { get; set; }
    public PharmacySaleStatus Status { get; set; } = PharmacySaleStatus.Completed;
    public DateTime SaleDate { get; set; } = DateTime.UtcNow;
    public decimal TotalAmount { get; set; }
    public Guid SoldBy { get; set; }

    public List<PharmacySaleItem> Items { get; set; } = new();
}

public class PharmacySaleItem : BaseEntity
{
    public Guid PharmacySaleId { get; set; }
    public Guid ItemId { get; set; }
    public Guid? BatchId { get; set; }
    public Guid? PrescriptionItemId { get; set; }
    public decimal Quantity { get; set; }
    public decimal UnitPrice { get; set; }

    public PharmacySale PharmacySale { get; set; } = null!;
}
