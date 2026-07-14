namespace MediCore.Application.DTOs.Appointment;

public class QueueAppointmentDto
{
    public Guid Id { get; set; }
    public Guid PatientId { get; set; }
    public string PatientFullName { get; set; } = string.Empty;
    public string PatientFileNumber { get; set; } = string.Empty;
    public string? PatientPhone { get; set; }
    public Guid DoctorId { get; set; }
    public string DoctorFullName { get; set; } = string.Empty;
    public string StartTime { get; set; } = string.Empty;
    public string EndTime { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public string? ChiefComplaint { get; set; }
    public DateTime? ArrivedAt { get; set; }
    public DateTime? StartedAt { get; set; }
}