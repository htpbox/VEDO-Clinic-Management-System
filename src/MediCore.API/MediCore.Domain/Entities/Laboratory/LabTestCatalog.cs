using MediCore.Domain.Common;

namespace MediCore.Domain.Entities.Laboratory;

/// <summary>
/// Catalog of tests this clinic's lab offers. ReferenceLow/ReferenceHigh
/// define the normal range used to auto-flag results (see LabResult).
/// For panel tests with multiple components (e.g. CBC), model each
/// component as its own catalog entry rather than one row with sub-fields -
/// keeps the reference-range/flagging logic in one place per component.
/// </summary>
public class LabTestCatalog : BaseEntity
{
    public Guid TenantId { get; set; }
    public string Code { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string? Unit { get; set; }
    public decimal? ReferenceLow { get; set; }
    public decimal? ReferenceHigh { get; set; }
    public decimal? CriticalLow { get; set; }
    public decimal? CriticalHigh { get; set; }
    public decimal Price { get; set; }
    public bool IsActive { get; set; } = true;
}
