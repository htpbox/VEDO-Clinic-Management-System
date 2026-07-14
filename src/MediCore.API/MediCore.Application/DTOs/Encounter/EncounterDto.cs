namespace MediCore.Application.DTOs.Encounter;

public class EncounterDto
{
    public Guid Id { get; set; }
    public Guid PatientId { get; set; }
    public Guid DoctorId { get; set; }
    public Guid? AppointmentId { get; set; }
    public string EncounterType { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public string? ChiefComplaint { get; set; }
    public string? Hpi { get; set; }
    public string? PhysicalExam { get; set; }
    public string? ClinicalNotes { get; set; }
    public string? TreatmentPlan { get; set; }
    public DateOnly? FollowUpDate { get; set; }
    public string? FollowUpNotes { get; set; }
    public bool IsLocked { get; set; }
    public DateTime CreatedAt { get; set; }
}