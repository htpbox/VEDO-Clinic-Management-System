using MediCore.Domain.Enums;

namespace MediCore.Application.DTOs.Pharmacy;

public class CreatePharmacySaleItemDto
{
    public Guid ItemId { get; set; }
    public decimal Quantity { get; set; }
    public decimal UnitPrice { get; set; }

    /// <summary>Set when this line fulfills a specific prescription line item (marks it IsDispensed).</summary>
    public Guid? PrescriptionItemId { get; set; }
}

public class CreatePharmacySaleDto
{
    public Guid WarehouseId { get; set; }
    public Guid? PatientId { get; set; }
    public Guid? PrescriptionId { get; set; }
    public PharmacySaleType SaleType { get; set; } = PharmacySaleType.Retail;

    /// <summary>If true, an Invoice is created and linked automatically via the existing Invoices module.</summary>
    public bool CreateInvoice { get; set; } = true;

    public List<CreatePharmacySaleItemDto> Items { get; set; } = new();
}

public class PharmacySaleItemDto
{
    public Guid Id { get; set; }
    public Guid ItemId { get; set; }
    public string ItemName { get; set; } = string.Empty;
    public decimal Quantity { get; set; }
    public decimal UnitPrice { get; set; }
}

public class PharmacySaleDto
{
    public Guid Id { get; set; }
    public Guid WarehouseId { get; set; }
    public Guid? PatientId { get; set; }
    public Guid? PrescriptionId { get; set; }
    public Guid? InvoiceId { get; set; }
    public PharmacySaleType SaleType { get; set; }
    public PharmacySaleStatus Status { get; set; }
    public DateTime SaleDate { get; set; }
    public decimal TotalAmount { get; set; }
    public List<PharmacySaleItemDto> Items { get; set; } = new();
}

public class ReturnPharmacySaleItemDto
{
    public Guid PharmacySaleItemId { get; set; }
    public decimal Quantity { get; set; }
}

public class ReturnPharmacySaleDto
{
    public string Reason { get; set; } = string.Empty;
    public List<ReturnPharmacySaleItemDto> Items { get; set; } = new();
}
