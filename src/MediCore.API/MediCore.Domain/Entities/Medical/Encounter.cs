using MediCore.Domain.Common;

namespace MediCore.Domain.Entities.Medical;

public class Encounter : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid BranchId { get; set; }
    public Guid PatientId { get; set; }
    public Guid DoctorId { get; set; }
    public Guid? AppointmentId { get; set; }
    public string EncounterType { get; set; } = "outpatient";
    public string Status { get; set; } = "in_progress";
    public string? ChiefComplaint { get; set; }
    public string? Hpi { get; set; }
    public string? PhysicalExam { get; set; }
    public string? ClinicalNotes { get; set; }
    public string? TreatmentPlan { get; set; }
    public DateOnly? FollowUpDate { get; set; }
    public string? FollowUpNotes { get; set; }
    public bool IsLocked { get; set; } = false;
    public DateTime? LockedAt { get; set; }

    // Navigation Properties
    public Patient Patient { get; set; } = null!;
    public Branch Branch { get; set; } = null!;
    public Appointment? Appointment { get; set; }
}