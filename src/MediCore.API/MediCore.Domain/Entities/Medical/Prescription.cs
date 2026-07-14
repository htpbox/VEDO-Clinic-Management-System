using MediCore.Domain.Common;

namespace MediCore.Domain.Entities.Medical;

public class Prescription : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid EncounterId { get; set; }
    public Guid PatientId { get; set; }
    public Guid DoctorId { get; set; }
    public string PrescriptionNumber { get; set; } = string.Empty;
    public string Status { get; set; } = "draft";
    public string? Notes { get; set; }
    public DateTime? DispensedAt { get; set; }
    public Guid? DispensedBy { get; set; }

    // Navigation Properties
    public Encounter Encounter { get; set; } = null!;
    public Patient Patient { get; set; } = null!;
    public ICollection<PrescriptionItem> Items { get; set; } = new List<PrescriptionItem>();
}