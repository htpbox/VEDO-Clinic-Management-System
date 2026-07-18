using MediCore.Domain.Common;

namespace MediCore.Domain.Entities.Radiology;

public class RadiologyReport : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid RadiologyOrderId { get; set; }
    public string Findings { get; set; } = string.Empty;
    public string? Impression { get; set; }
    public Guid ReportedBy { get; set; }
    public DateTime ReportedAt { get; set; } = DateTime.UtcNow;
    public bool ReviewedByDoctor { get; set; } = false;
    public Guid? ReviewedBy { get; set; }
    public DateTime? ReviewedAt { get; set; }
    public string? DoctorComment { get; set; }

    public RadiologyOrder RadiologyOrder { get; set; } = null!;
    public List<RadiologyImage> Images { get; set; } = new();
}

/// <summary>
/// A pointer to an image associated with a report - NOT a DICOM store.
/// StorageProvider/ExternalReference are intentionally generic (e.g.
/// "PACS" + a WADO-URI, or "S3" + an object key, or "Local" + a file path)
/// so a real PACS/DICOM integration can be plugged in later by adding an
/// implementation that resolves these references, without changing this
/// schema. No image bytes are stored or parsed by this system today.
/// </summary>
public class RadiologyImage : BaseEntity
{
    public Guid RadiologyReportId { get; set; }
    public string StorageProvider { get; set; } = "Local";
    public string ExternalReference { get; set; } = string.Empty;
    public string? Description { get; set; }

    public RadiologyReport RadiologyReport { get; set; } = null!;
}
