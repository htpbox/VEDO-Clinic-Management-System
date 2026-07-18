using MediCore.Domain.Common;
using MediCore.Domain.Enums;

namespace MediCore.Domain.Entities.Laboratory;

public class LabOrder : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid BranchId { get; set; }
    public Guid PatientId { get; set; }
    public Guid DoctorId { get; set; }
    public Guid? EncounterId { get; set; }
    public Guid? InvoiceId { get; set; }
    public LabOrderStatus Status { get; set; } = LabOrderStatus.Ordered;
    public DateTime OrderedAt { get; set; } = DateTime.UtcNow;
    public DateTime? SampleCollectedAt { get; set; }
    public Guid? SampleCollectedBy { get; set; }
    public string? ClinicalNotes { get; set; }

    public List<LabOrderItem> Items { get; set; } = new();
}

public class LabOrderItem : BaseEntity
{
    public Guid LabOrderId { get; set; }
    public Guid LabTestCatalogId { get; set; }

    public LabOrder LabOrder { get; set; } = null!;
    public LabTestCatalog LabTestCatalog { get; set; } = null!;
    public LabResult? Result { get; set; }
}
