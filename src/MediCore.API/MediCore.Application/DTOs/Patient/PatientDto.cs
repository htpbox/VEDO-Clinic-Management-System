namespace MediCore.Application.DTOs.Patient;

public class PatientDto
{
    public Guid Id { get; set; }
    public string FileNumber { get; set; } = string.Empty;
    public string FullName { get; set; } = string.Empty;
    public string Gender { get; set; } = string.Empty;
    public DateOnly? DateOfBirth { get; set; }
    public int? Age { get; set; }
    public string? Phone { get; set; }
    public string? Email { get; set; }
    public string? BloodType { get; set; }
    public string? InsuranceCompany { get; set; }
    public string Status { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
}