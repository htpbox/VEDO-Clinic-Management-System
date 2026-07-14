using MediCore.Domain.Common;

namespace MediCore.Domain.Entities.Medical;

public class MedicalRecord : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid PatientId { get; set; }
    public string? GeneralNotes { get; set; }

    // Navigation Properties
    public Patient Patient { get; set; } = null!;
}