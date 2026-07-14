using MediCore.Domain.Common;
using MediCore.Domain.Enums;

namespace MediCore.Domain.Entities.Financial;

public class Payment : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid InvoiceId { get; set; }
    public Guid PatientId { get; set; }
    public DateTime PaymentDate { get; set; }
    public decimal Amount { get; set; }
    public PaymentMethod PaymentMethod { get; set; }
    public string? ReferenceNumber { get; set; }
    public Guid ReceivedBy { get; set; }
    public string? Notes { get; set; }

    // Navigation Properties
    public Invoice Invoice { get; set; } = null!;
}