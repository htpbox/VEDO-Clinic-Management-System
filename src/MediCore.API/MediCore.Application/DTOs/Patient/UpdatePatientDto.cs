namespace MediCore.Application.DTOs.Patient;

public class UpdatePatientDto
{
    public string FullName { get; set; } = string.Empty;
    public DateOnly? DateOfBirth { get; set; }
    public string? Phone { get; set; }
    public string? PhoneSecondary { get; set; }
    public string? Email { get; set; }
    public string? Address { get; set; }
    public string? Governorate { get; set; }
    public string? BloodType { get; set; }
    public string? EmergencyContactName { get; set; }
    public string? EmergencyContactPhone { get; set; }
    public string? EmergencyContactRelation { get; set; }
    public string? InsuranceCompany { get; set; }
    public string? InsuranceNumber { get; set; }
    public DateOnly? InsuranceExpiry { get; set; }
    public string? Notes { get; set; }
}