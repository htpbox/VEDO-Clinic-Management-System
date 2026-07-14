namespace MediCore.Application.DTOs.Prescription;

public class CreatePrescriptionDto
{
    public Guid EncounterId { get; set; }
    public Guid PatientId { get; set; }
    public string? Notes { get; set; }
    public List<CreatePrescriptionItemDto> Items { get; set; } = new();
}