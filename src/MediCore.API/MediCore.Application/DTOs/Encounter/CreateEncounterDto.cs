namespace MediCore.Application.DTOs.Encounter;

public class CreateEncounterDto
{
    public Guid PatientId { get; set; }
    public Guid? AppointmentId { get; set; }
    public string EncounterType { get; set; } = "outpatient";
    public string? ChiefComplaint { get; set; }
}