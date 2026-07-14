using MediCore.Domain.Common;
using MediCore.Domain.Enums;

namespace MediCore.Domain.Entities.Medical;

public class Patient : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid? BranchId { get; set; }
    public string FileNumber { get; set; } = string.Empty;
    public string? NationalId { get; set; }
    public string FullName { get; set; } = string.Empty;
    public Gender Gender { get; set; }
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
    public PatientStatus Status { get; set; } = PatientStatus.Active;

    // Navigation Properties
    public Tenant Tenant { get; set; } = null!;
    public Branch? Branch { get; set; }
    public MedicalRecord? MedicalRecord { get; set; }
    public ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();
}