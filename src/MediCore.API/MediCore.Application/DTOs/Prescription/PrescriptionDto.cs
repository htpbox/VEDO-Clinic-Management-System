namespace MediCore.Application.DTOs.Prescription;

public class PrescriptionDto
{
    public Guid Id { get; set; }
    public Guid EncounterId { get; set; }
    public Guid PatientId { get; set; }
    public Guid DoctorId { get; set; }
    public string PrescriptionNumber { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public string? Notes { get; set; }
    public List<PrescriptionItemDto> Items { get; set; } = new();
    public DateTime CreatedAt { get; set; }
}