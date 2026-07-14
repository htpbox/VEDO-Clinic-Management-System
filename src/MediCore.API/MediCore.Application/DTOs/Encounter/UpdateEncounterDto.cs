namespace MediCore.Application.DTOs.Encounter;

public class UpdateEncounterDto
{
    public string? ChiefComplaint { get; set; }
    public string? Hpi { get; set; }
    public string? PhysicalExam { get; set; }
    public string? ClinicalNotes { get; set; }
    public string? TreatmentPlan { get; set; }
    public DateOnly? FollowUpDate { get; set; }
    public string? FollowUpNotes { get; set; }
}