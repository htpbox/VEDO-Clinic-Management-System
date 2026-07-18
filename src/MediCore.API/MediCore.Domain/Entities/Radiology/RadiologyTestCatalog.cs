using MediCore.Domain.Common;

namespace MediCore.Domain.Entities.Radiology;

public class RadiologyTestCatalog : BaseEntity
{
    public Guid TenantId { get; set; }
    public string Code { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string Modality { get; set; } = string.Empty; // X-Ray, Ultrasound, CT, MRI, etc.
    public decimal Price { get; set; }
    public bool IsActive { get; set; } = true;
}
