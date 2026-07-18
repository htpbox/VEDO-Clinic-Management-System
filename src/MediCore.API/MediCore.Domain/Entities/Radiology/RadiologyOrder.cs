using MediCore.Domain.Common;
using MediCore.Domain.Enums;

namespace MediCore.Domain.Entities.Radiology;

public class RadiologyOrder : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid BranchId { get; set; }
    public Guid PatientId { get; set; }
    public Guid DoctorId { get; set; }
    public Guid RadiologyTestCatalogId { get; set; }
    public Guid? EncounterId { get; set; }
    public Guid? InvoiceId { get; set; }
    public RadiologyOrderStatus Status { get; set; } = RadiologyOrderStatus.Ordered;
    public DateTime OrderedAt { get; set; } = DateTime.UtcNow;
    public string? ClinicalIndication { get; set; }

    public RadiologyTestCatalog RadiologyTestCatalog { get; set; } = null!;
    public RadiologyReport? Report { get; set; }
}
