using MediCore.Domain.Common;

namespace MediCore.Domain.Entities.Financial;

public class InvoiceItem : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid InvoiceId { get; set; }
    public string Description { get; set; } = string.Empty;
    public decimal Quantity { get; set; } = 1;
    public decimal UnitPrice { get; set; }
    public decimal TotalPrice { get; set; }
    public int SortOrder { get; set; } = 0;

    // Navigation Properties
    public Invoice Invoice { get; set; } = null!;
}