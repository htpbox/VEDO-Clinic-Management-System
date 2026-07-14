using MediCore.Domain.Common;

namespace MediCore.Domain.Entities.Medical;

public class VitalSigns : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid EncounterId { get; set; }
    public Guid PatientId { get; set; }
    public int? BpSystolic { get; set; }
    public int? BpDiastolic { get; set; }
    public int? HeartRate { get; set; }
    public int? RespiratoryRate { get; set; }
    public decimal? Temperature { get; set; }
    public decimal? OxygenSaturation { get; set; }
    public decimal? WeightKg { get; set; }
    public decimal? HeightCm { get; set; }
    public decimal? Bmi { get; set; }
    public decimal? BloodGlucose { get; set; }
    public string? BloodGlucoseType { get; set; }
    public int? PainScale { get; set; }
    public string? Notes { get; set; }
    public Guid RecordedBy { get; set; }

    // Navigation Properties
    public Encounter Encounter { get; set; } = null!;
    public Patient Patient { get; set; } = null!;
}