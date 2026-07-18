using System.ComponentModel.DataAnnotations.Schema;
using MediCore.Domain.Common;
using MediCore.Domain.Enums;

namespace MediCore.Domain.Entities.Laboratory;

public class LabResult : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid LabOrderItemId { get; set; }
    public decimal? NumericValue { get; set; }
    public string? TextValue { get; set; }
    public LabResultFlag Flag { get; set; } = LabResultFlag.Normal;
    public Guid EnteredBy { get; set; }
    public DateTime EnteredAt { get; set; } = DateTime.UtcNow;
    public bool ReviewedByDoctor { get; set; } = false;
    public Guid? ReviewedBy { get; set; }
    public DateTime? ReviewedAt { get; set; }
    public string? DoctorComment { get; set; }

    /// <summary>True if the value fell outside the catalog's normal range.</summary>
    [NotMapped]
    public bool IsAbnormal => Flag != LabResultFlag.Normal;

    public LabOrderItem LabOrderItem { get; set; } = null!;
}
