using MediCore.Domain.Common;

namespace MediCore.Domain.Entities.Medical;

public class PrescriptionItem : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid PrescriptionId { get; set; }
    public string DrugName { get; set; } = string.Empty;
    public string? ActiveIngredient { get; set; }
    public string? Dose { get; set; }
    public string? Frequency { get; set; }
    public string? Route { get; set; }
    public int? DurationDays { get; set; }
    public int? Quantity { get; set; }
    public string? Instructions { get; set; }
    public bool IsDispensed { get; set; } = false;
    public int SortOrder { get; set; } = 0;

    // Navigation Properties
    public Prescription Prescription { get; set; } = null!;
}