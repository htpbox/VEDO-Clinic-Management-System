namespace MediCore.Application.DTOs.Appointment;

public class CreateAppointmentDto
{
    public Guid PatientId { get; set; }
    public Guid DoctorId { get; set; }
    public DateOnly AppointmentDate { get; set; }
    public TimeOnly StartTime { get; set; }
    public TimeOnly EndTime { get; set; }
    public string? ChiefComplaint { get; set; }
    public string? Notes { get; set; }
}